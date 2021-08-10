//
//  GetBeersUseCase.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

protocol GetBeersUseCaseProtocol {
    func execute(page: Int, count: Int) -> AnyPublisher<[Beer], Error>
}

class GetBeersUseCase: GetBeersUseCaseProtocol {
    
    private var repository: BeersRepositoryProtocol

    init(repository: BeersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, count: Int) -> AnyPublisher<[Beer], Error> {
        repository.getBeers(page: page, count: count)
    }
}
