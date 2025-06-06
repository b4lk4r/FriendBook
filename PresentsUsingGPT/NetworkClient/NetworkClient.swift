//
//  NetworkClient.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Alamofire

final class NetworkClient: NetworkClientInput {
    func request<T: Decodable, U: Encodable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        body: U?,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var request: URLRequest
        do {
            request = try URLRequest(url: url, method: method, headers: headers)
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
            }
        } catch {
            completion(.failure(.encodingFailed))
            return
        }
        
        AF.request(request)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(.alamofireError(error)))
            }
        }
    }
    
    func request<T: Decodable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(.alamofireError(error)))
            }
        }
    }
}
