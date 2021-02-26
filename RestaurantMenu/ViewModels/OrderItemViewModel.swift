//
//  OrderItemViewModel.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/21/21.
//

import Foundation
struct OrderItemViewModel {
    var orderItem: OrderItem
    var id : BindableProperty<Int>? {
        didSet {
            if let id = id?.value {
                orderItem.menuItemId = id
            } else {
                orderItem.menuItemId = 0
            }
        }
    }
    
    var price : BindableProperty<Double> {
        didSet {
            if let price = price.value {
                orderItem.price = price
            } else {
                orderItem.price = 0.0
            }
        }
    }
    
    
//    var instructions : BindableProperty<String> {
//        didSet {
//            if let instructions = instructions.value {
//                orderItem.instructions = instructions
//            }else {
//                orderItem.instructions = ""
//            }
//        }
//    }
    
    var quantities : BindableProperty<Int> {
        didSet {
            if let quantities = quantities.value {
                orderItem.quantities = quantities
            }else {
                orderItem.quantities = 0
            }
        }
    }
    
    

    init(menuItem: MenuItem, quantities:Int, instructions:String = "") {
        self.orderItem = menuItem.createOrder(quantities: quantities,withInstructions: instructions)
        self.id = BindableProperty<Int>(menuItem.id)
        self.quantities = BindableProperty<Int>(quantities)
        self.price = BindableProperty<Double>(menuItem.price)
        //self.instructions = BindableProperty<String>(instructions)
    }
}
