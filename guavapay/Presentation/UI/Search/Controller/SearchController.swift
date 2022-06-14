//
//  SearchController.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation
import UIKit
import SwiftUI


class SearchController: ViewController {
    
    private typealias TableDataSource = UITableViewDiffableDataSource<Int, Country>

    private lazy var tableDataSource: TableDataSource = {
        let datasource = TableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
            cell.textLabel?.text = model.name.common
            return cell
        })
        
        return datasource
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIComponents()
        setupUIConstraints()
    }
    
    private func setupUIComponents() {
        view.backgroundColor = .white
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        navigationItem.searchController = search
        navigationController?.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
    }
    
    private func setupUIConstraints() {
        view.addSubview(tableView)
        view.addSubview(indicatorView)
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            messageLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
}

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = tableDataSource.itemIdentifier(for: indexPath) {
            let repository = CountriesRepositoryImpl(apiService: .shared, cacheService: .shared)
            let vm = CountryDetailViewModelImpl(country: country, countriesRepository: repository)
            let vc = UIHostingController(rootView: CountyDetailView(viewModel: vm))
            
            show(vc, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SearchController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            await viewModel.updateSearch(query: searchText)
        }
    }
}

extension SearchController: SearchViewModelDelegate {
    func didSuccess(countries: Countries) {
        DispatchQueue.main.async { [weak self] in
            self?.messageLabel.isHidden = !countries.isEmpty
            self?.messageLabel.text = "No countries found"
            
            if var snapshot = self?.tableDataSource.snapshot() {
                snapshot.deleteSections([0])
                snapshot.appendSections([0])
                snapshot.appendItems(countries, toSection: 0)
                self?.tableDataSource.apply(snapshot)
            }
        }
    }
    
    func didReceiveError(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.messageLabel.isHidden = false
            self?.messageLabel.text = error.localizedDescription
        }
    }
    
    func isLoading(value: Bool) {
        DispatchQueue.main.async { [weak self] in
            if value {
                self?.messageLabel.isHidden = true
                self?.indicatorView.startAnimating()
            } else {
                self?.indicatorView.stopAnimating()
            }
        }
    }
}
