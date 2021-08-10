//
//  BeersDataStore.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

class BeersDataStore: BaseApiProtocol, BeersDataStoreProtocol {
    func getBeers(page: Int, count: Int) -> AnyPublisher<[BeerDTO], Error> {
        requestArray(type: BeerDTO.self, .beers(page: page, count: count))
    }

    func getBeerDetails(id: Int) -> AnyPublisher<BeerDTO, Error> {
        requestArray(type: BeerDTO.self, .beerDetails(id: id))
            .flatMap { beers -> AnyPublisher<BeerDTO, Error> in
                guard let first = beers.first else { return Fail(error: ApiError.genericError).eraseToAnyPublisher() }
                return Just(first).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
