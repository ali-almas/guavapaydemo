//
//  HomeController.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import UIKit

class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIComonents()
    }
    
    private func setupUIComonents() {
        let continentsViewModel = ContinentsViewModelImpl()
        let continentsVc = ContinentsController(viewModel: continentsViewModel)
        
        let continentsController = UINavigationController(
            rootViewController: continentsVc
        )
        
        let continentsTabItem = UITabBarItem(
            title: "Continents",
            image: UIImage(systemName: "globe.asia.australia"),
            selectedImage:  UIImage(systemName: "globe.asia.australia.fill")
        )
        
        continentsController.tabBarItem = continentsTabItem
        
        let countriesRepository = CountriesRepositoryImpl(apiService: .shared, cacheService: .shared)
        let searchViewModel = SearchViewModelImpl(countriesRepository:  countriesRepository)
        let searchVc = SearchController(viewModel: searchViewModel)
        
        let searchController = UINavigationController(
            rootViewController: searchVc
        )
        
        let searchTabItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        
        searchController.tabBarItem = searchTabItem
        
        viewControllers = [continentsController, searchController]
    }
}
