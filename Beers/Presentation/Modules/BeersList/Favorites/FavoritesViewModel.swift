//
//  FavoritesViewModel.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import Foundation
import Combine

final class FavoritesViewModel: BaseBeersViewModel {
    enum ViewEvent {
        case viewWillAppear
        case didSelectBeer(row: Int)
    }

    // MARK: - Inputs
    var viewEvent = PassthroughSubject<ViewEvent, Never>()
    private var getFavoriteBeersUseCase: GetFavoriteBeersUseCaseProtocol
    var beers: [BeerViewData] = []

    init(getFavoriteBeersUseCase: GetFavoriteBeersUseCaseProtocol) {
        self.getFavoriteBeersUseCase = getFavoriteBeersUseCase
        
        super.init()
        viewEvent
            .sink { [weak self] event in
                switch event {
                case .viewWillAppear: self?.getBeers()
                case .didSelectBeer(let row):
                    guard let beer = self?.beers[row] else { return }
                    self?.coordinatorOutput.send(.openBeerDetails(beer))
                }
            }
            .store(in: &cancellables)
    }
    
    override func getBeers() {
        loadingState.send(.start)
        getFavoriteBeersUseCase
            .execute()
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] beers in
                self?.handleSuccessResponse(beers)
            }
            .store(in: &cancellables)
    }
    
    func handleSuccessResponse(_ beers: [Beer]) {
        loadingState.send(.stop)
        self.beers = beers.map { $0.toViewData()}
        viewState.send(.beers(self.beers))
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        loadingState.send(.stop)
        if case .failure(let error) = completion {
            viewState.send(.error(error))
        }
    }
}
