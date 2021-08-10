//
//  BeersRepositoryProtocol.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

protocol BeersRepositoryProtocol {
    func getBeers(page: Int, count: Int) -> AnyPublisher<[Beer], Error>
    func getBeerDetails(id: Int) -> AnyPublisher<Beer, Error>
    func getFavoriteBeers() -> AnyPublisher<[Beer], Error>
    func favoriteBeer(id: Int) -> AnyPublisher<Void, Error>
    func unfavoriteBeer(id: Int) -> AnyPublisher<Void, Error>
}
