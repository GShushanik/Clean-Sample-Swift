//
//  BeersDIContainer.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import Foundation

class BeersDIContainer {
    
    func createBeersUseCase() -> GetBeersUseCaseProtocol {
        GetBeersUseCase(repository: createBeerRepository())
    }

    func createFavoritesUseCase() -> GetFavoriteBeersUseCaseProtocol {
        GetFavoriteBeersUseCase(repository: createBeerRepository())
    }

    func createBeerRepository() -> BeersRepositoryProtocol {
        BeersRepository(dataStore: createBeersDataStore(), storage: CoreDataStore.shared)
    }

    func createBeersDataStore() -> BeersDataStoreProtocol {
        BeersDataStore()
    }
    
    func createBeersViewModel() -> BaseBeersViewModel {
        BeersViewModel(getBeersUseCase: createBeersUseCase())
    }
    
    func createFavoritesViewModel() -> BaseBeersViewModel {
        FavoritesViewModel(getFavoriteBeersUseCase: createFavoritesUseCase())
    }

    func createBeersViewController() -> BaseViewController? {
        let vc = R.storyboard.beers.beersViewController()
        vc?.viewModel = createBeersViewModel()
        return vc
    }
    
    func createFavoritesViewController() -> BaseViewController? {
        let vc = R.storyboard.favorites.favoritesViewController()
        vc?.viewModel = createFavoritesViewModel()
        return vc
    }
}
