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
    static var orderNumber = 221
    var orderViewModel:OrderViewModel?
    @IBOutlet var tableView:UITableView!
    @IBOutlet var confirmButton:UIButton!
    @IBOutlet var mobileNumber:BindableTextField!
    @IBOutlet var tableNumber:BindableTextField!
    @IBOutlet var totalAmount:UILabel!
    // MARK: - UITableViewDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableNumber.delegate = self
        mobileNumber.delegate = self
        orderViewModel?.orderItemViewModelList?.Binding(callback: {[weak self] (_) in
            self?.tableView.reloadData()
        })
        self.title = NSLocalizedString("Order Confirmation", comment: "")
        
        mobileNumber.Binding {[weak self] (text) in
            self?.orderViewModel?.mobileNumber?.value = text
            self?.orderViewModel?.validate()
        }
        tableNumber.Binding {[weak self] (text) in
            self?.orderViewModel?.tableNumber?.value = text
            self?.orderViewModel?.validate()
        }
        orderViewModel?.isVailid.Binding {[weak self] (validOrder) in
            //self?.confirmButton.isUserInteractionEnabled = validOrder ?? false
            self?.confirmButton.isEnabled = validOrder ?? false
        }
        orderViewModel?.total?.Binding(callback: {[weak self] (amount) in
            if let amount = amount {
                self?.totalAmount.text = String(format: "Total Amount: %.2f", amount)
            }
        })
    }
    
    
}

extension OrderItemViewController:UITableViewDelegate {
    
}

extension OrderItemViewController : UITableViewDataSource, SelectedMenuItemDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  orderViewModel?.numberOfRows(section) ?? 0
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
                self.orderViewModel?.calculateAmount()
            })
            return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We must have a delegate to respond to row selection.
        //guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
        
    }
   
    @IBAction func confirmOrder(_ sender:UIButton) {
        showAlertWithThreeButton()
    }
    func showAlertWithThreeButton() {
        let alert = UIAlertController(title: "Order Confirmated", message: "Your order is confimred, \n Order Number: \(OrderItemViewController.orderNumber)", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
               // self.dismiss(animated: true) {
               // }
            }))

            self.present(alert, animated: true, completion: nil)
        }
    
}

extension OrderItemViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            textField.resignFirstResponder()
            return true;
        }
}
