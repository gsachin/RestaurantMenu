//
//  ViewController.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import UIKit
import Combine
class MenuItemListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var searchControllerContainerView:UIView!
    @IBOutlet var tableView:UITableView!
    var searchTokens: [UISearchToken] = []
    var searchController : UISearchController!
    var cancellable : AnyCancellable?
//    var isFilteringByCategory: Bool {
//      return categories != nil
//    }

    private var menuItemListViewModel = MenuItemListViewModel() 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController:nil)
        self.searchControllerContainerView.addSubview(self.searchController.searchBar)
        self.searchController.obscuresBackgroundDuringPresentation = false
        makeTokens()
        let filterImage = UIImage(systemName: "gear")
        let filterButton = UIButton(frame: CGRect(x: 0,y: 0, width: 44,height: 44))
        filterButton.setBackgroundImage(filterImage, for: .normal)
        //self.searchController.searchBar.searchTextField.rightView = UIImageView(image:filterImage)
        //self.searchController.searchBar//.setRightImage(normalImage: UIImage(named: "filter")!,highLightedImage: UIImage(named: "filter_selected")!)
        cancellable = MenuItemListService().loadMenuItems().sink(receiveCompletion: {_ in}) { [self] (itms) in
            let list = itms.map { item in MenuItemViewModel(menuItem: item )}
            menuItemListViewModel.Items = BindableViewModelProperty(list)
            //print(itms)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemListViewModel.numberOfRows(section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "AddWeatherCityViewController" {
//
//            prepareSegueForAddWeatherCityViewController(segue: segue)
//
//        } else if segue.identifier == "SettingsTableViewController" {
//
//            prepareSegueForSettingsTableViewController(segue: segue)
//
//        } else if segue.identifier == "WeatherDetailsViewController" {
//
//            prepareSegueForWeatherDetailsViewController(segue: segue)
//        }
       
        
    }
    
    private func prepareSegueForWeatherDetailsViewController(segue: UIStoryboardSegue) {
        
//        guard let weatherDetailsVC = segue.destination as? WeatherDetailsViewController,
//            let indexPath = self.tableView.indexPathForSelectedRow else {
//                return
//        }
//
//        let weatherVM = self.menuItemListViewModel.modelAt(indexPath.row)
//        weatherDetailsVC.weatherViewModel = weatherVM
    }
    
    private func prepareSegueForSettingsTableViewController(segue: UIStoryboardSegue) {
        
//        guard let nav = segue.destination as? UINavigationController else {
//            fatalError("NavigationController not found")
//        }
//
//        guard let settingsTVC = nav.viewControllers.first as? SettingsTableViewController else {
//            fatalError("SettingsTableViewController not found")
//        }
//
//        settingsTVC.delegate = self
        
    }
    
    private func prepareSegueForAddWeatherCityViewController(segue: UIStoryboardSegue) {
        
//        guard let nav = segue.destination as? UINavigationController else {
//            fatalError("NavigationController not found")
//        }
//
//        guard let addWeatherCityVC = nav.viewControllers.first as? AddWeatherCityViewController else {
//            fatalError("AddWeatherCityController not found")
//        }
//
//        addWeatherCityVC.delegate = self
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        
        let menuItemVM = self.menuItemListViewModel.modelAt(indexPath.row)
        
        cell.configure(menuItemVM)
       
        return cell
    }
    
    func setToSuggestedSearches() {
        // Show suggested searches only if we don't have a search token in the search field.
        if searchController.searchBar.searchTextField.tokens.isEmpty {
           // self.showSuggestedSearches = true
            
            // We are no longer interested in cell navigating, since we are now showing the suggested searches.
            tableView.delegate = self
        }
    }
    
}

extension MenuItemListViewController {
  func makeTokens() {
    // 1
    let continents = Category.allCases
    searchTokens = continents.map { (categories) -> UISearchToken in
      // 2
      let globeImage = UIImage(systemName: "globe")
      let token = UISearchToken(icon: globeImage, text: categories.description)
      // 3
      token.representedObject = Category(rawValue: categories.description)
      // 4
      return token
    }
  }
}
