//
//  GetFavoriteBeersUseCase.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import Foundation
import Combine

protocol GetFavoriteBeersUseCaseProtocol {
    func execute() -> AnyPublisher<[Beer], Error>
}

class GetFavoriteBeersUseCase: GetFavoriteBeersUseCaseProtocol {
    
    private var repository: BeersRepositoryProtocol

    init(repository: BeersRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Beer], Error> {
        repository.getFavoriteBeers()
    }
}
