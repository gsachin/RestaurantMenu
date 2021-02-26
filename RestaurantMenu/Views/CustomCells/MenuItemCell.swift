//
//  MenuItemCell.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/11/21.
//

import Foundation
import UIKit
import Combine
class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImage:LazyImageView!
    @IBOutlet weak var quantityStepper:BindableStepper!
    @IBOutlet weak var quantity: BindableTextField!
    var cancellable : Any?
    var notify:((_ menuItemViewModel:MenuItemViewModel?)->Void)?
    func configure(_ vm: MenuItemViewModel?, notify:@escaping (_ menuItemViewModel:MenuItemViewModel?)->Void) {
        self.notify = notify
        vm?.name.Binding(callback: {[weak self] (name) in
            if let name = name {
            self?.itemNameLabel.text = name
            }
        })
        vm?.price.Binding(callback: {[weak self] (price) in
            if let price = price {
            self?.itemPriceLabel.text = "\(price)"
            }
        })
        vm?.quantities.Binding(callback: {[weak self] (value) in
            if let value = value {
                self?.quantity.text = "\(value)"
                self?.quantityStepper.value = Double(value)
                notify(vm)
            }
        })
        
        self.quantityStepper.Binding {[weak self] (value) in
            if let value = value {
                vm?.quantities.value = value
                self?.notify?(vm)
                //self?.quantity.text = value
            }
        }
        
       // vm?.thumbnailURL.Binding(callback: {[weak self] (url) in
        if let url = vm?.thumbnailURL.value, let imageUrl = url {
            self.itemImage.loadImageAsync(url: imageUrl)
            }
        //})
       
        //self.itemPriceLabel.text = "\(String(describing: vm.price.value))"
       // self.itemImage = UIImageView(image: UIImage())
    }
    
    var onReuse: () -> Void = {
        
    }

      override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        notify = nil
        itemImage.image = nil
      }
}
