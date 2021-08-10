//
//  BeerDetailsViewController.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 08.08.21.
//

import UIKit

class BeerDetailsViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func configureUI() {
        title = "Beer details"
    }

    override func bindViewModel() {
        guard let viewModel = viewModel as? BeerDetailsViewModel else { return }
        viewModel.viewEvent.send(.viewDidLoad)
        
        viewModel
            .viewState
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel
            .loadingState
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel
            .favoriteButtonState
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Rendering
private extension BeerDetailsViewController {
    func render(_ state: BeerDetailsViewModel.ViewState) {
        switch state {
        case .beer(let beer):
            imageView.setImage(from: beer.imageURL)
            descriptionLabel.text = beer.beerDescription
            titleLabel.text = beer.name
            taglineLabel.text = beer.tagline
            favoriteButton.setImage(beer.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
            
        case .error(let error):
            showAlert(title: "Oops!", message: error.localizedDescription)
        }
    }

    func render(_ state: BeerDetailsViewModel.LoadingState) {
        switch state {
        case .start:
            startActivity()
        case .stop:
            stopActivity()
        }
    }
    
    func render(_ state: BeerDetailsViewModel.FavoriteButtonState) {
        switch state {
        case .favorite:
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        case .unfavorite:
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}

// MARK: - Actions
private extension BeerDetailsViewController {
    @IBAction func favoriteAction(_ sender: Any) {
        guard let viewModel = viewModel as? BeerDetailsViewModel else { return }
        viewModel.viewEvent.send(.didFavoriteBeer)
    }
}
