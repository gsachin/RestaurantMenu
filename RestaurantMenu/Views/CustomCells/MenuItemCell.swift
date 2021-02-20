//
//  MenuItemCell.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/11/21.
//

import Foundation
import Foundation
import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImage:UIImageView!
    
    func configure(_ vm: MenuItemViewModel?) {
        vm?.name.Binding(callback: { (name) in
            if let name = name {
            self.itemNameLabel.text = name
            }
        })
       
        
        //self.itemPriceLabel.text = "\(String(describing: vm.price.value))"
       // self.itemImage = UIImageView(image: UIImage())
    }
    
    var onReuse: () -> Void = {}

      override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        itemImage.image = nil
      }
}
