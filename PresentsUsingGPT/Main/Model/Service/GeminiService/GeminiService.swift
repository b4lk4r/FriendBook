//
//  Service.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Alamofire

final class GeminiService: GeminiServiceInput {
    
    // MARK: Private Properties
    
    private let geminiURL: String
    private let networkClient: NetworkClientInput
    private let keyChainManager: KeychainManagerInput
    
    init(
        networkClient: NetworkClientInput,
        keychainManager: KeychainManagerInput,
        geminiURL: String,
    ) {
        self.networkClient = networkClient
        self.keyChainManager = keychainManager
        self.geminiURL = geminiURL
    }
    
    // MARK: Internal functions
    
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, GeminiServiceError>) -> Void) {
        let request = GeminiApiRequest(
            contents: [.init(parts: [.init(text: prompt)])]
        )

        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        guard let apiKey = keyChainManager.get(forKey: "gemini.apikey") else {
            completion(.failure(.keychainError))
            return
        }
        
        let fullURL = "\(geminiURL)\(apiKey)"

        self.networkClient.request(
            fullURL,
            method: .post,
            body: request,
            headers: headers
        ) { (result: Result<GeminiApiResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let reply = response.candidates.first?.content.parts.first?.text ?? ""
                completion(.success(reply))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}
