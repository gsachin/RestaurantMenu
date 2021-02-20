//
//  ViewController.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import UIKit
import Combine
class MenuItemListViewController: UIViewController {
    var cancellable : AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = Items()
        print(item)
         cancellable = MenuItemsService().loadMenuItems().sink(receiveCompletion: {_ in}) { (itms) in
            print(itms)
        }
        // Do any additional setup after loading the view.
    }


}

