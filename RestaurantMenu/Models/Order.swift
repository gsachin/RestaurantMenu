//
//  Order.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation

struct Order : Codable {
    var restaurantId:UUID
    var orderItems = [MenuItem]()
    var mobileNumber:String?
    var tableNumber:String?
    var emailId:String?
    var total:Double?
}

struct OrderItem : Codable {
    var menuItem:MenuItem?
    var menuItemId:Int
    var itemName:String
    var quantities:Int
    var price:Double
    var instructions:String?
    init(menuItem:MenuItem, quantities:Int,price:Double,Instructions:String?) {
        self.menuItem = menuItem
        self.menuItemId = menuItem.id
        self.quantities = quantities
        self.price = price
        self.instructions = Instructions
        self.itemName = menuItem.name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.menuItemId = try container.decode(Int.self, forKey: .menuItemId)
        self.quantities = try container.decode(Int.self, forKey: .quantities)
        self.price = try container.decode(Double.self, forKey: .price)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.itemName = try container.decode(String.self, forKey: .itemName)
    }
    private enum CodingKeys: String, CodingKey {
        case menuItemId = "menuItemId"
        case quantities = "quantities"
        case price = "price"
        case instructions = "instructions"
        case itemName = "itemName"
    }
}
