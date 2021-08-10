//
//  BaseBeersCoordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import Foundation
import Combine

extension BaseBeersCoordinator {
    enum OutputEvent {
        case openDetails(BeerViewData)
    }
}

class BaseBeersCoordinator: BaseCoordinator {
    
    var coordinatorOutput = PassthroughSubject<OutputEvent, Never>()
    var diContainer: BeersDIContainer

    init(diContainer: BeersDIContainer, routerType: RouterType) {
        self.diContainer = diContainer
        super.init(router: routerType)
    }
    
    func bindViewModel(_ viewModel: BaseBeersViewModel) {
        viewModel
            .coordinatorOutput
            .sink { [weak self] output in
                switch output {
                case .openBeerDetails(let beer):
                    self?.coordinatorOutput.send(.openDetails(beer))
                }
            }
            .store(in: &cancellables)
    }
    
    func createViewController() -> BaseViewController? { nil }
}
