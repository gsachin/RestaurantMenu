//
//  MenuItemDetailViewController.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/21/21.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    var menuItemViewModel:MenuItemViewModel?
    @IBOutlet var itemName:UILabel!
    @IBOutlet var itemDescription:UILabel!
    @IBOutlet var itemIngredient:UILabel!
    @IBOutlet var itemPrice:UILabel!
    @IBOutlet var itemImage:LazyImageView!
    // Your delegate to receive selected Item to Add in OrderList.
    weak var selectedMenuItemDelegate: SelectedMenuItemDelegate?
    var addToOrder: ((_ menuItemViewModel:MenuItemViewModel?)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        bind()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addToOrder(_ sender: Any) {
        selectedMenuItemDelegate?.didSelect(menuItemVM: menuItemViewModel)
        self.dismiss(animated: true, completion: nil)
    }
    
    func bind() {
        menuItemViewModel?.descriptions.Binding(callback: {[weak self] (desc) in
            if let value = desc {
                self?.itemDescription.text = value
            }
        })
        
        menuItemViewModel?.ingredients.Binding(callback: {[weak self] (ing) in
            if let value = ing {
                self?.itemIngredient.text = value
            }
        })
        
        menuItemViewModel?.name.Binding(callback: {[weak self] (name) in
            if let value = name {
                self?.itemName.text = value
            }
        })
        
        menuItemViewModel?.price.Binding(callback: {[weak self] (price) in
            if let value = price {
                self?.itemPrice.text = "$\(value)"
            }
        })
        
        if let url = menuItemViewModel?.imageURL.value, let imageUrl = url {
            self.itemImage.loadImageAsync(url: imageUrl)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
