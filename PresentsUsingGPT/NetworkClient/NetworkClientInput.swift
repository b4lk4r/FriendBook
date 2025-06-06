//
//  NetworkClientInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Foundation
import Alamofire

protocol NetworkClientInput {
    func request<T: Decodable, U: Encodable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        body: U?,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func request<T: Decodable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
