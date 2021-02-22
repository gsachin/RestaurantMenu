//
//  OrderItemViewController.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/22/21.
//

import Foundation
import UIKit
class OrderItemViewController : UIViewController, UITableViewDataSource
{
    var orderViewModel:OrderViewModel?
    @IBOutlet var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // bind()
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel?.numberOfRows(section) ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 74
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
    
}
