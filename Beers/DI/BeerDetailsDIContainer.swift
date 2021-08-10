//
//  BeerDetailsDIContainer.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import Foundation

class BeerDetailsDIContainer {
    
    private var dependency: BeersDIContainer
    
    init(dependency: BeersDIContainer) {
        self.dependency = dependency
    }

    func createBeerDetailsUseCase() -> GetBeerDetailsUseCaseProtocol {
        GetBeerDetailsUseCase(repository: dependency.createBeerRepository())
    }
    
    func createFavoriteBeerUseCase() -> FavoriteBeerUseCaseProtocol {
        FavoriteBeerUseCase(repository: dependency.createBeerRepository())
    }

    func createUnfavoriteBeerUseCase() -> UnfavoriteBeerUseCaseProtocol {
        UnfavoriteBeerUseCase(repository: dependency.createBeerRepository())
    }

    func createBeerDetailsViewModel(beer: BeerViewData) -> BeerDetailsViewModel {
        BeerDetailsViewModel(beer: beer,
                             getBeerDetailsUseCase: createBeerDetailsUseCase(),
                             favoriteBeerUseCase: createFavoriteBeerUseCase(),
                             unfavoriteBeerUseCase: createUnfavoriteBeerUseCase())
    }

    func createBeerDetailsViewController(beer: BeerViewData) -> BeerDetailsViewController? {
        let vc = R.storyboard.beerDetails.beerDetailsViewController()
        vc?.viewModel = createBeerDetailsViewModel(beer: beer)
        return vc
    }
}
