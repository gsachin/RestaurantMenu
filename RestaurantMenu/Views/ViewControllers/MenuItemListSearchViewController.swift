//
//  MenuItemListSearchViewController.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/14/21.
//

import Foundation

import UIKit
import Combine
// This protocol helps inform ViewController that a suggested search or menuItem was selected.
protocol SelectedMenuItemDelegate: AnyObject {
    // A menuItem was selected; inform our delgeate that a menuItem was selected to view.
    func didSelect(menuItemVM: MenuItemViewModel?)
}
class MenuItemListSearchViewController: UIViewController {
    var searchController : UISearchController!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBarContainer:UIView!
    @IBOutlet var confirmButton:UIButton!
    var searchTokens: [UISearchToken] = []
    var cancellable : AnyCancellable?
    //@IBOutlet var searchBarContainer:UIView!
    
    private var menuItemListViewModel = MenuItemListViewModel() 
    
    
    class func suggestedTitle(fromIndex: Int) -> Category {
        return MenuItemListViewModel.categories.value?[fromIndex] ?? Category.all
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchBarContainer.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = false
        searchController.searchBar.searchTextField.backgroundColor = .blue
        searchController.searchBar.searchTextField.textColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        cancellable = MenuItemListService().loadMenuItems().sink(receiveCompletion: {_ in}) { [self] (itms) in
            let list = itms.map { item in MenuItemViewModel(menuItem: item )}
            menuItemListViewModel.Items = BindableViewModelProperty(list)
            menuItemListViewModel.filterItems?.Binding(callback: { _ in
                self.tableView.reloadData()
            })
            
        }
        menuItemListViewModel.showSuggestedSearch.Binding {[weak self] _ in
            if self != nil && self!.searchController.searchBar.searchTextField.tokens.isEmpty {
                
                self?.tableView.reloadData()
                // We are no longer interested in cell navigating, since we are now showing the suggested searches.
                self?.tableView.delegate = self
            }
        }
        
        menuItemListViewModel.validOrder.Binding {[weak self] (validOrder) in
            //self?.confirmButton.isUserInteractionEnabled = validOrder ?? false
            self?.confirmButton.isEnabled = validOrder ?? false
        }
    }
    
    
}

extension MenuItemListSearchViewController:UITableViewDelegate {
    
}

extension MenuItemListSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            menuItemListViewModel.showSuggestedSearch.value = true
        } else {
            menuItemListViewModel.showSuggestedSearch.value = false
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // User tapped the Done button in the keyboard.
        searchController.dismiss(animated: true, completion: nil)
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        menuItemListViewModel.showSuggestedSearch.value = false
    }
}


extension MenuItemListSearchViewController : UISearchControllerDelegate {
    
    // We are being asked to present the search controller, so from the start - show suggested searches.
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        menuItemListViewModel.showSuggestedSearch.value = true
    }
}

extension MenuItemListSearchViewController : UITableViewDataSource, SelectedMenuItemDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemListViewModel.showSuggestedSearch.value ?? false ? MenuItemListViewModel.categories.value?.count ?? 0 : menuItemListViewModel.numberOfRows(section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuItemListViewModel.showSuggestedSearch.value ?? false {
            return 44
        } else {
            return 74
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (menuItemListViewModel.showSuggestedSearch.value ?? false) ? NSLocalizedString("Suggested Searches", comment: "") : NSLocalizedString("Menu Items", comment: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuItemDetailViewController {
            destinationViewController.menuItemViewModel = menuItemListViewModel.modelAt(tableView.indexPathForSelectedRow!.row)
            destinationViewController.selectedMenuItemDelegate = self
        } else if let destinationViewController = segue.destination as? OrderItemViewController {
            
            let orderList = menuItemListViewModel.getOrderMenuItems() 
            destinationViewController.orderViewModel = OrderViewModel(orderItemViewModelList: orderList )
        }
                //menuItemListViewModel.modelAt(tableView.indexPathForSelectedRow!.row)
//            destinationViewController.selectedMenuItemDelegate = self
    }
    func didSelect(menuItemVM: MenuItemViewModel?) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if menuItemListViewModel.showSuggestedSearch.value ?? false {
            let cell = UITableViewCell()
            let suggestedtitle = MenuItemListViewModel.categories.value?[indexPath.row].rawValue ?? ""
            // No detailed text or accessory for suggested searches.
            cell.textLabel?.text = suggestedtitle
            cell.accessoryType = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCellID") as? MenuItemCell else {
                return UITableViewCell()
            }
            let menuItem = menuItemListViewModel.modelAt(indexPath.row)
            // cell.textLabel?.text = menuItem?.name.value ?? ""
            cell.configure(menuItem,  notify:{ menuItemViewModel in
                self.menuItemListViewModel.notifyItemQuantityChanges(menuItemViewModel: menuItemViewModel)
            })
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We must have a delegate to respond to row selection.
        //guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Make sure we are showing suggested searches before notifying which token was selected.
        if menuItemListViewModel.showSuggestedSearch.value ?? false {
            // A suggested search was selected; inform our delegate that the selected search token was selected.
            let tokenToInsert = MenuItemListSearchViewController.searchToken(tokenValue: indexPath.row)
            if let searchField = searchController?.searchBar.searchTextField {
                searchField.insertToken(tokenToInsert, at: 0)
                
                // Hide the suggested searches now that we have a token.
                menuItemListViewModel.showSuggestedSearch.value = false
                
                // Update the search query with the newly inserted token.
                updateSearchResults(for: searchController)
            }
            //suggestedSearchDelegate.didSelectSuggestedSearch(token: tokenToInsert)
        } else {
            // A menuItem was selected; inform our delgeate that a menuItem was selected to view.
            
            _ = menuItemListViewModel.modelAt(indexPath.row)
            //performSegue(withIdentifier: "MenuItemDetailIdentifire", sender: self)
        }
    }
    
    // Search a search token from an input value.
    class func searchToken(tokenValue: Int) -> UISearchToken {
        let searchToken = UISearchToken(icon: nil, text: suggestedTitle(fromIndex: tokenValue).rawValue)
        searchToken.representedObject = suggestedTitle(fromIndex: tokenValue)
        return searchToken
    }
    
}
extension MenuItemListSearchViewController: UISearchResultsUpdating {
    // Called when the search bar's text has changed or when the search bar becomes first responder.
    func updateSearchResults(for searchController: UISearchController) {
        // Update the results's filtered items based on the search terms and suggested search token.
        if searchController.searchBar.text!.isEmpty && searchController.searchBar.searchTextField.tokens.isEmpty {
            // Text is empty, show suggested searches again.
            menuItemListViewModel.showSuggestedSearch.value = true
        } else {
            menuItemListViewModel.showSuggestedSearch.value = false
        }
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
        // Filter further down for the right colored flowers.
        if !searchController.searchBar.searchTextField.tokens.isEmpty {
            let searchCategory = searchController.searchBar.searchTextField.tokens[0]
            print(searchCategory)
            if let searchTokenValue = searchCategory.representedObject as? Category {
                menuItemListViewModel.filterByCategoriesAndText(selectedCategory:searchTokenValue , searchToken: strippedString)
            }
        } else {
            menuItemListViewModel.filterByText(strippedString)
        }
    }
    
}
