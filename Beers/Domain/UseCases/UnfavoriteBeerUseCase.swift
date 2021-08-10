//
//  UnfavoriteBeerUseCase.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import Foundation
import Combine

protocol UnfavoriteBeerUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<Void, Error>
}

class UnfavoriteBeerUseCase: UnfavoriteBeerUseCaseProtocol {
    
    private var repository: BeersRepositoryProtocol

    init(repository: BeersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<Void, Error> {
        repository.unfavoriteBeer(id: id)
    }
}
