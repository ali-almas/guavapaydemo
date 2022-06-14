//
//  CountriesController.swift
//  guavapay
//
//  Created by Ali Almasli on 11.06.22.
//

import Foundation
import UIKit
import SwiftUI

class CountriesController: ViewController {
    
    typealias TableDataSource = UITableViewDiffableDataSource<Int, Country>
    
    lazy var tableDataSource: TableDataSource = {
        let dataSource = TableDataSource(tableView: tableView) { (tableView, indexPath, country) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
            
            var configuration = cell.defaultContentConfiguration()
            configuration.text = country.name.common
            configuration.secondaryText = country.name.commonNativeName
            configuration.image = country.flag.image()

            var textProperties = configuration.textProperties
            textProperties.color = UIColor.black
            configuration.textProperties = textProperties
            
            cell.contentConfiguration = configuration
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        return dataSource
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.addSubview(refreshControl)
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var viewModel: CountriesViewModel
    
    init(viewModel: CountriesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)

        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIComonents()
        setupUIConstraints()
    }
    
    private func setupUIComonents() {
        title = viewModel.title
        view.backgroundColor = .white
        
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        
        Task {
            await viewModel.fetchCountries()
        }
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
    
    @objc private func onRefresh(_ sender: UIRefreshControl) {
        Task {
            await viewModel.fetchCountries()
        }
    }
}

extension CountriesController: UITableViewDelegate {
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

extension CountriesController: CountriesViewModelDelegate {
    func didReceiveSuccess(countries: Countries) {
        DispatchQueue.main.async { [weak self] in
            self?.messageLabel.isHidden = true
            
            if var snapshot = self?.tableDataSource.snapshot() {
                snapshot.deleteSections([0])
                snapshot.appendSections([0])
                snapshot.appendItems(countries, toSection: 0)
                self?.tableDataSource.apply(snapshot)
            }
        }
    }
    
    func isLoading(value: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if value && !self.refreshControl.isRefreshing  {
                self.messageLabel.isHidden = true
                self.indicatorView.startAnimating()
            } else {
                self.indicatorView.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func didReceiveError(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.messageLabel.isHidden = false
            self?.messageLabel.text = error.localizedDescription
        }
    }
}

