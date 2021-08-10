//
//  BaseAPI.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

protocol BaseApiProtocol {
    func requestObject<T: Codable>(type: T.Type, _ target: PunkApi) -> AnyPublisher<T, Error>
    func requestArray<T: Codable>(type: T.Type, _ target: PunkApi) -> AnyPublisher<[T], Error>
}

extension BaseApiProtocol {
    
    func requestObject<T: Codable>(type: T.Type, _ target: PunkApi) -> AnyPublisher<T, Error> {
        guard var urlComponents = URLComponents(string: target.baseURL + target.path) else {
            return Fail(error: ApiError.genericError).eraseToAnyPublisher()
        }
        urlComponents.queryItems = target.params
        guard let url = urlComponents.url else {
            return Fail(error: ApiError.genericError).eraseToAnyPublisher()
        }
        let request = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestArray<T: Codable>(type: T.Type, _ target: PunkApi) -> AnyPublisher<[T], Error> {
        guard var urlComponents = URLComponents(string: target.baseURL + target.path) else {
            return Fail(error: ApiError.genericError).eraseToAnyPublisher()
        }
        urlComponents.queryItems = target.params
        
        guard let url = urlComponents.url else {
            return Fail(error: ApiError.genericError).eraseToAnyPublisher()
        }
        let request = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [T].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
