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
    var cancellable : Any?
    func configure(_ vm: MenuItemViewModel?) {
        
        vm?.name.Binding(callback: { (name) in
            if let name = name {
            self.itemNameLabel.text = name
            }
        })
       // vm?.thumbnailURL.Binding(callback: {[weak self] (url) in
        if let url = vm?.thumbnailURL.value, let imageUrl = url {
            self.itemImage.loadImageAsync(url: imageUrl)
            }
        //})
       
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
