//
//  ContinentsController.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation
import UIKit

class ContinentsController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var viewModel: ContinentsViewModel
    
    init(viewModel: ContinentsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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
        title = "Continents"
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUIConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ContinentsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.continents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        var configuration = cell.defaultContentConfiguration()
        configuration.text = viewModel.continents[indexPath.row].title

        var textProperties = configuration.textProperties
        textProperties.color = UIColor.black
        configuration.textProperties = textProperties
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let continent = viewModel.continents[indexPath.row]
        let countriesRepository = CountriesRepositoryImpl(apiService: .shared, cacheService: .shared)
        let vm = CountriesViewModelImpl(continent: continent, countriesRepository: countriesRepository)
        let vc = CountriesController(viewModel: vm)
    
        show(vc, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
