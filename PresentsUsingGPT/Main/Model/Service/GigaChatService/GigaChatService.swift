//
//  GigaChatService.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Alamofire

final class GigaChatService: GigaChatServiceInput {
    
    // MARK: Private Properties
    
    private let gigaChatAuthURL: String
    private let gigaChatURL: String
    private let networkClient: NetworkClientInput
    private let keyChainManager: KeychainManagerInput
    private var gigaChatTokenExpiringTime: Int64?
    
    init(
        networkClient: NetworkClientInput,
        keychainManager: KeychainManagerInput,
        gigaChatAuthURL: String,
        gigaChatURL: String,
    ) {
        self.networkClient = networkClient
        self.keyChainManager = keychainManager
        self.gigaChatAuthURL = gigaChatAuthURL
        self.gigaChatURL = gigaChatURL
    }
    
    // MARK: Internal functions
    
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, GigaChatServiceError>) -> Void) {
        ensureValidToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let request = ChatCompletionRequest(
                    model: "GigaChat",
                    messages: [.init(role: "user", content: prompt)]
                )
                
                guard let token = self.keyChainManager.get(forKey: "gigachat.token") else {
                    completion(.failure(.authFailed))
                    return
                }
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(token)",
                    "Content-Type": "application/json"
                ]
                
                self.networkClient.request(
                    gigaChatURL,
                    method: .post,
                    body: request,
                    headers: headers
                ) { (result: Result<ChatCompletionResponse, NetworkError>) in
                    switch result {
                    case .success(let response):
                        let content = response.choices.first?.message.content ?? ""
                        completion(.success(content))
                        
                    case .failure(let error):
                        completion(.failure(.networkError(error)))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Private functions
    
    private func ensureValidToken(completion: @escaping (Result<Void, GigaChatServiceError>) -> Void) {
        if let token = gigaChatTokenExpiringTime, TimeInterval(token) / 1000 > Date().timeIntervalSince1970 {
            completion(.success(()))
            return
        }
        
        authenticate { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.authFailed))
            }
        }
    }
    
    private func authenticate(completion: @escaping (Result<Void, GigaChatServiceError>) -> Void) {
        guard let apiKey = keyChainManager.get(forKey: "gigachat.apikey") else {
            completion(.failure(.authFailed))
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "RqUID": UUID().uuidString,
            "Authorization": "Basic \(apiKey)"
        ]
        
        let parameters: Parameters = [
            "scope": "GIGACHAT_API_PERS"
        ]
        
        networkClient.request(
            gigaChatAuthURL,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        ) { [weak self] (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let saved = self?.keyChainManager.save(response.accessToken, forKey: "gigachat.token")
                if saved ?? false {
                    self?.gigaChatTokenExpiringTime = response.expiresAt
                    completion(.success(()))
                } else {
                    print("Ошибка при сохранении токена")
                    completion(.failure(.keychainError))
                }
            case .failure:
                completion(.failure(.authFailed))
            }
        }
    }
}
