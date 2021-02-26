//
//  OrderItemViewController.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/22/21.
//

import Foundation
import UIKit

class OrderItemViewController : UIViewController
{
    var orderViewModel:OrderViewModel?
    @IBOutlet var tableView:UITableView!
    
    // MARK: - UITableViewDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        orderViewModel?.orderItemViewModelList?.Binding(callback: {[weak self] (_) in
            self?.tableView.reloadData()
        })
        self.title = NSLocalizedString("Order Confirmation", comment: "")
    }
    
    
}

extension OrderItemViewController:UITableViewDelegate {
    
}

extension OrderItemViewController : UITableViewDataSource, SelectedMenuItemDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  2 //orderViewModel?.numberOfRows(section) ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 74
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Order Details", comment: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuItemDetailViewController {
            destinationViewController.menuItemViewModel = orderViewModel?.modelAt(tableView.indexPathForSelectedRow!.row)
            destinationViewController.selectedMenuItemDelegate = self
        }
    }
    func didSelect(menuItemVM: MenuItemViewModel?) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCellID") as? MenuItemCell else {
                return UITableViewCell()
            }
        let menuItem = orderViewModel?.modelAt(indexPath.row)
            // cell.textLabel?.text = menuItem?.name.value ?? ""
            cell.configure(menuItem,  notify:{ menuItemViewModel in
                //self.orderViewModel.notifyItemQuantityChanges(menuItemViewModel: menuItemViewModel)
            })
            return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We must have a delegate to respond to row selection.
        //guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
        
    }
    
    
    
}

