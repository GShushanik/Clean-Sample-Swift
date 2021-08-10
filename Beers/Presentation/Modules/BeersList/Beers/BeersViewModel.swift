//
//  BeersViewModel.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import Foundation
import Combine

final class BeersViewModel: BaseBeersViewModel {
    enum ViewEvent {
        case viewDidLoad
        case didSelectBeer(row: Int)
        case didDisplayCell(row: Int)
        case sortBy(Sort)
    }
    
    enum Sort: Int {
        case all
        case abv
        case ibu
        case ebc
    }
    
    // MARK: - Inputs
    var viewEvent = PassthroughSubject<ViewEvent, Never>()
    private var getBeersUseCase: GetBeersUseCaseProtocol
    var currentPage = 1
    var count = 25
    var beers: [BeerViewData] = []
    var initialBeers: [BeerViewData] = []

    init(getBeersUseCase: GetBeersUseCaseProtocol) {
        self.getBeersUseCase = getBeersUseCase
        
        super.init()
        viewEvent
            .sink { [weak self] event in
                switch event {
                case .viewDidLoad: self?.getBeers()
                case .didSelectBeer(let row):
                    guard let beer = self?.beers[row] else { return }
                    self?.coordinatorOutput.send(.openBeerDetails(beer))
                case .didDisplayCell(let row): self?.isThresholdItem(at: row)
                case .sortBy(let sort): self?.sortBeersBy(sort)
                }
            }
            .store(in: &cancellables)
    }
    
    override func getBeers() {
        loadingState.send(.start)
        getBeersUseCase
            .execute(page: currentPage, count: count)
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] beers in
                self?.handleSuccessResponse(beers)
            }
            .store(in: &cancellables)
    }

    func handleSuccessResponse(_ beers: [Beer]) {
        loadingState.send(.stop)
        currentPage += 1
        let beersViewDataArray = beers.map { $0.toViewData()}
        for beer in beersViewDataArray {
            if !self.beers.contains(beer) {
                self.beers.append(beer)
            }
        }
        initialBeers = self.beers
        viewState.send(.beers(self.beers))
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        loadingState.send(.stop)
        if case .failure(let error) = completion {
            viewState.send(.error(error))
        }
    }

    func isThresholdItem(at row: Int) {
        if beers.isThresholdItem(offset: 5, item: beers[row]) {
            getBeers()
        }
    }

    func sortBeersBy(_ sort: Sort) {
        switch sort {
        case .all:
            beers = initialBeers
            viewState.send(.beers(beers))
        case .abv:
            beers = beers.sorted { $0.abv > $1.abv }
            viewState.send(.beers(beers))
        case .ibu:
            beers = beers.sorted { $0.ibu > $1.ibu }
            viewState.send(.beers(beers))
        case .ebc:
            beers = beers.sorted { $0.ebc > $1.ebc }
            viewState.send(.beers(beers))
        }
    }
}
