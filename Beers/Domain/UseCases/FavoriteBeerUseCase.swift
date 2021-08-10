//
//  FavoriteBeerUseCase.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import Foundation
import Combine

protocol FavoriteBeerUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<Void, Error>
}

class FavoriteBeerUseCase: FavoriteBeerUseCaseProtocol {
    
    private var repository: BeersRepositoryProtocol

    init(repository: BeersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<Void, Error> {
        repository.favoriteBeer(id: id)
    }
}
