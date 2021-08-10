//
//  UIViewController.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import UIKit
import Combine

class FavoritesViewController: BaseBeersViewController {
    
    override func configureUI() {
        super.configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = viewModel as? FavoritesViewModel else { return }
        viewModel.viewEvent.send(.viewWillAppear)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? FavoritesViewModel else { return }
        viewModel.viewEvent.send(.didSelectBeer(row: indexPath.row))
    }
}
