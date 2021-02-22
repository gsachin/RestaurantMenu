//
//  MenuItem.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation
enum Category : String, CaseIterable, Codable {
    case vegan = "Vegan"
    case vegetarian = "Vegetarian"
    case glutenfree = "Gluten free"
    case nonvegetarian = "Non Vegetarian"
    case desserts = "Desserts"
    case beverages = "Beverages"
    case all = "All"
}
extension Category: CustomStringConvertible {
  var description: String { rawValue }
}
struct MenuItem : Codable {
    var id : Int =  0
    var categories : [Category]? = [Category]()
    var price : Double = 0.0
    var name : String = ""
    var descriptions : String? = ""
    var ingredients : String? = ""
    var thumbnailURL : String? = ""
    var imageURL : String? = ""
    
    enum CodingKeys : CodingKey {
        case id
        case categories
        case price
        case name
        case descriptions
        case ingredients
        case thumbnailURL
        case imageURL
        
    }
    
    init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(Double.self, forKey: .price)
        self.name  = try container.decode(String.self, forKey:.name)
        self.descriptions = try container.decode(String.self, forKey:.descriptions)
        self.ingredients  = try container.decode(String.self, forKey:.ingredients)
        self.thumbnailURL  = try container.decode(String.self, forKey:.thumbnailURL)
        self.imageURL  = try container.decode(String.self, forKey:.imageURL)
        let categories = try container.decode([String].self, forKey: .categories)
        self.categories =  categories.compactMap({
             Category(rawValue: $0)
        })
    }
    init() {
        
    }
    func createOrder(quantities:Int, withInstructions instructions:String = "")->OrderItem {
        return OrderItem(menuItem: self, quantities: quantities, price: self.price, Instructions: instructions)
    }
}


