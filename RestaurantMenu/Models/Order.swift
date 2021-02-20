//
//  Order.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation

struct Order : Codable {
    var restaurantId:UUID
    var menuItems : [OrderItem]
    var mobileNumber:String
    var tableNumber:String?
}

struct OrderItem : Codable {
    var menuItemId:Int
    var quantities:Int
    var price:Double
    var Instructions:String?
}
