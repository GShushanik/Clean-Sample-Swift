//
//  BaseBeerViewModel.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import Foundation
import Combine

class BaseBeersViewModel: BaseViewModel {
    enum CoordinatorOutput {
        case openBeerDetails(BeerViewData)
    }
    
    enum ViewState {
        case beers([BeerViewData])
        case error(Error)
    }
    
    enum LoadingState {
        case start, stop
    }

    // MARK: - Outputs
    var viewState = PassthroughSubject<ViewState, Never>()
    var loadingState = PassthroughSubject<LoadingState, Never>()
    var coordinatorOutput = PassthroughSubject<CoordinatorOutput, Never>()
    
    var cancellables = Set<AnyCancellable>()

    func getBeers() {}
}
