//
//  BeersDataStoreProtocol.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

protocol BeersDataStoreProtocol {
    func getBeers(page: Int, count: Int) -> AnyPublisher<[BeerDTO], Error>
    func getBeerDetails(id: Int) -> AnyPublisher<BeerDTO, Error>
}
