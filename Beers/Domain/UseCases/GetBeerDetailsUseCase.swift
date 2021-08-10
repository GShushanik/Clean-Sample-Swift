//
//  GetBeerDetailsUseCase.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

protocol GetBeerDetailsUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<Beer, Error>
}

class GetBeerDetailsUseCase: GetBeerDetailsUseCaseProtocol {
    private var repository: BeersRepositoryProtocol

    init(repository: BeersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<Beer, Error> {
        repository.getBeerDetails(id: id)
    }
}
