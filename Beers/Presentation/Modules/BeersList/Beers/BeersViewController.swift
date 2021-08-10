//
//  BeersViewController.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import UIKit
import Combine

class BeersViewController: BaseBeersViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func configureUI() {
        super.configureUI()
        configureSegmentedControl()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? BeersViewModel else { return }
        viewModel.viewEvent.send(.viewDidLoad)
    }
}

// MARK: - SegmentedControl
private extension BeersViewController {
    func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = .systemOrange
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }

    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        guard let viewModel = viewModel as? BeersViewModel,
              let sort = BeersViewModel.Sort(rawValue: sender.selectedSegmentIndex) else { return }
        viewModel.viewEvent.send(.sortBy(sort))
    }
}

// MARK: - UITableView
extension BeersViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? BeersViewModel else { return }
        viewModel.viewEvent.send(.didDisplayCell(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? BeersViewModel else { return }
        viewModel.viewEvent.send(.didSelectBeer(row: indexPath.row))
    }
}
