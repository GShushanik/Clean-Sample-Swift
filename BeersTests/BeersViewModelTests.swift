//
//  BeersViewModelTests.swift
//  BeersViewModelTests
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import XCTest
@testable import Beers
import Combine

class BeersViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var getBeersUseCase: MockGetBeersUseCase!
    
    private var mockBeers: [BeerViewData] {
        [
            BeerViewData(id: 1,
                         name: "Beer 1",
                         tagline: "Tagline of Beer 1",
                         beerDescription: nil,
                         imageURL: nil,
                         abv: 0.0,
                         ibu: 0.0,
                         ebc: 0.0,
                         isFavorite: false),
            BeerViewData(id: 2,
                         name: "Beer 2",
                         tagline: "Tagline of Beer 2",
                         beerDescription: nil,
                         imageURL: nil,
                         abv: 0.0,
                         ibu: 0.0,
                         ebc: 0.0,
                         isFavorite: false),
        ]
    }

    override func setUp() {
        super.setUp()
        cancellables = []
        getBeersUseCase = MockGetBeersUseCase()
    }

    func testGetBeersSuccess() {
        
        let beer1 = Beer(id: 1,
                         name: "Beer 1",
                         tagline: "Tagline of Beer 1",
                         imageURL: nil,
                         beerDescription: nil,
                         abv: 0.0,
                         ibu: 0.0,
                         ebc: 0.0,
                         isFavorite: false)
        
        let beer2 = Beer(id: 2,
                         name: "Beer 2",
                         tagline: "Tagline of Beer 2",
                         imageURL: nil,
                         beerDescription: nil,
                         abv: 0.0,
                         ibu: 0.0,
                         ebc: 0.0,
                         isFavorite: false)
        
        getBeersUseCase.data = [beer1, beer2]

        let viewModel = BeersViewModel(getBeersUseCase: getBeersUseCase)
        
        viewModel.getBeers()
            
        XCTAssertEqual(viewModel.beers, mockBeers)
    }

    func testGetBeersFailure() {
    
        let viewModel = BeersViewModel(getBeersUseCase: getBeersUseCase)
        
        getBeersUseCase.error = ApiError.genericError
    
        viewModel.getBeers()
            
        XCTAssert(viewModel.beers.isEmpty)
    }
}

class MockGetBeersUseCase: GetBeersUseCaseProtocol {
    
    var data: [Beer]?
    var error: Error?

    func execute(page: Int, count: Int) -> AnyPublisher<[Beer], Error> {
        if let data = data {
            return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
