//
//  LazyImageView.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/20/21.
//

import Foundation
import UIKit
import Combine
class LazyImageView: UIImageView {
    let cacheImages = NSCache<AnyObject,UIImage>()
//    var viewModel:MenuItemViewModel?
    var cancellable : AnyCancellable?
    func loadImageAsync(url:String) {
        if let imageData = cacheImages.object(forKey: NSString(string:url)) {
            self.image = imageData
            return
        }
        //self.cancellable?.cancel()
        
        MenuItemService().loadMenuItemImage(url: url) {[weak self] (data) in
            if let data = data, let imageData = UIImage(data:data) {
                self?.cacheImages.setObject(imageData, forKey: NSString(string: url))
                self?.image = imageData
                return
            }
        } failer: { (error) in
            
        }
    }
}
