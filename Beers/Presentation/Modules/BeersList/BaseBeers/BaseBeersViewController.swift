//
//  BaseBeersViewController.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import UIKit
import Combine

class BaseBeersViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!

    private lazy var dataSource = makeDataSource()
    
    override func configureUI() {
        configureTableView()
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel as? BaseBeersViewModel else { return }
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
    }
}

// MARK: - Rendering
extension BaseBeersViewController {
    func render(_ state: BaseBeersViewModel.ViewState) {
        switch state {
        case .beers(let beers):
            update(with: beers)
        case .error(let error):
            showAlert(title: "Oops!", message: error.localizedDescription)
        }
    }

    func render(_ state: BaseBeersViewModel.LoadingState) {
        switch state {
        case .start:
            startActivity()
        case .stop:
            stopActivity()
        }
    }
}

extension BaseBeersViewController: UITableViewDelegate {

    private func configureTableView() {
        tableView.register(UINib(nibName: R.nib.beerTableViewCell.name, bundle: Bundle.main), forCellReuseIdentifier: R.reuseIdentifier.beerTableViewCell.identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
   
    enum Section: CaseIterable {
        case beers
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, BeerViewData> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, viewData in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.beerTableViewCell.identifier) as? BeerTableViewCell else {
                    assertionFailure("Failed to dequeue!")
                    return UITableViewCell()
                }
                cell.bind(to: viewData)
                cell.selectionStyle = .none
                return cell
            }
        )
    }

    func update(with beers: [BeerViewData], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BeerViewData>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(beers, toSection: .beers)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}
