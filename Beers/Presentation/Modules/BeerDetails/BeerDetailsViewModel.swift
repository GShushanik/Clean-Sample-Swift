//
//  BeerDetailsViewModel.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 08.08.21.
//

import Foundation
import Combine

class BeerDetailsViewModel: BaseViewModel {
    enum ViewEvent {
        case viewDidLoad
        case didFavoriteBeer
    }
    
    enum ViewState {
        case beer(BeerViewData)
        case error(Error)
    }
    
    enum LoadingState {
        case start, stop
    }

    enum FavoriteButtonState {
        case favorite, unfavorite
    }

    // MARK: - Outputs
    var viewState = PassthroughSubject<ViewState, Never>()
    var loadingState = PassthroughSubject<LoadingState, Never>()
    var favoriteButtonState = PassthroughSubject<FavoriteButtonState, Never>()

    // MARK: - Inputs
    var viewEvent = PassthroughSubject<ViewEvent, Never>()
   
    private var cancellables = Set<AnyCancellable>()
    private var getBeerDetailsUseCase: GetBeerDetailsUseCaseProtocol
    private var favoriteBeerUseCase: FavoriteBeerUseCaseProtocol
    private var unfavoriteBeerUseCase: UnfavoriteBeerUseCaseProtocol
    private var beer: BeerViewData

    init(beer: BeerViewData, getBeerDetailsUseCase: GetBeerDetailsUseCaseProtocol,
         favoriteBeerUseCase: FavoriteBeerUseCaseProtocol,
         unfavoriteBeerUseCase: UnfavoriteBeerUseCaseProtocol) {
        self.beer = beer
        self.getBeerDetailsUseCase = getBeerDetailsUseCase
        self.favoriteBeerUseCase = favoriteBeerUseCase
        self.unfavoriteBeerUseCase = unfavoriteBeerUseCase

        viewEvent
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .viewDidLoad:
                    self.getBeerDetails()
                case .didFavoriteBeer:
                    self.favoriteButtonState.send(beer.isFavorite ? .favorite : .unfavorite)
                    if beer.isFavorite {
                        self.unfavorite()
                    } else {
                        self.favorite()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension BeerDetailsViewModel {
    func getBeerDetails() {
        getBeerDetailsUseCase
            .execute(id: beer.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.viewState.send(.error(error))
                }
            } receiveValue: { [weak self] beer in
                self?.viewState.send(.beer(beer.toViewData()))
            }
            .store(in: &cancellables)
    }
}

private extension BeerDetailsViewModel {
    func unfavorite() {
        unfavoriteBeerUseCase
            .execute(id: beer.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.viewState.send(.error(error))
                    self?.favoriteButtonState.send(.favorite)
                }
            } receiveValue: { [weak self] in
                self?.beer.isFavorite = false
                self?.favoriteButtonState.send(.unfavorite)
            }
            .store(in: &self.cancellables)
    }
    
    func favorite() {
        favoriteBeerUseCase
            .execute(id: beer.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.viewState.send(.error(error))
                    self?.favoriteButtonState.send(.unfavorite)
                }
            } receiveValue: { [weak self] in
                self?.beer.isFavorite = true
                self?.favoriteButtonState.send(.favorite)
            }
            .store(in: &self.cancellables)
    }
}
