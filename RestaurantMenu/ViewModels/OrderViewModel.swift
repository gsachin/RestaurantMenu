//
//  OrderViewModel.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/21/21.
//

import Foundation
struct OrderViewModel {
    var order:Order
    var restaurantId:BindableProperty<UUID>? {
        didSet {
            if let restaurantid = restaurantId?.value {
                order.restaurantId = restaurantid
            }
        }
    }
    var orderItemViewModelList:BindableViewModelProperty<[OrderItemViewModel]>? {
        didSet {
            if let restaurantid = restaurantId?.value {
                order.restaurantId = restaurantid
            }
        }
    }
    var orderItems = [OrderItem]()
    var mobileNumber:String?
    var tableNumber:String?
    
    init(order:Order) {
        self.order = order
    }
}
