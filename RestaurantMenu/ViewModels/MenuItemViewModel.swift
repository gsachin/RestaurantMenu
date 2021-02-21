//
//  MenuItemViewModel.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation
struct MenuItemViewModel {
    var menuItem: MenuItem
    var id : BindableProperty<Int>? {
        didSet {
            if let id = id?.value {
                menuItem.id = id
            } else {
                menuItem.id = 0
            }
        }
    }
    
    var categories:BindableProperty<[Category]>? {
        didSet {
            menuItem.categories = categories?.value
        }
    }
    
    var price : BindableProperty<Double> {
        didSet {
            if let price = price.value {
                menuItem.price = price
            } else {
                menuItem.price = 0.0
            }
        }
    }
    
    var name : BindableProperty<String> {
        didSet {
            if let name = name.value {
                menuItem.name = name
            } else {
                menuItem.name = ""
            }
        }
    }
    
    var descriptions : BindableProperty<String?> {
        didSet {
            if let descriptions = descriptions.value {
                menuItem.descriptions = descriptions
            }else {
                menuItem.descriptions = ""
            }
        }
    }
    
    var ingredients : BindableProperty<String?> {
        didSet {
            if let ingredients = ingredients.value {
                menuItem.ingredients = ingredients
            }else {
                menuItem.ingredients = ""
            }
        }
    }
    
    var thumbnailURL : BindableProperty<String?> {
        didSet {
            if let thumbnailURL = thumbnailURL.value {
                menuItem.thumbnailURL = thumbnailURL
            }else {
                menuItem.thumbnailURL = ""
            }
        }
    }
    
    
    var imageURL : BindableProperty<String?>{
        didSet {
            if let imageURL = imageURL.value {
                menuItem.imageURL = imageURL
            }else {
                menuItem.imageURL = ""
            }
        }
    }
    
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        self.id = BindableProperty<Int>(menuItem.id)
        self.categories = BindableProperty<[Category]>(menuItem.categories)
        self.price = BindableProperty<Double>(menuItem.price)
        self.name = BindableProperty<String>(menuItem.name)
        self.descriptions = BindableProperty<String?>(menuItem.descriptions)
        self.ingredients = BindableProperty<String?>(menuItem.ingredients)
        self.thumbnailURL = BindableProperty<String?>(menuItem.thumbnailURL)
        self.imageURL = BindableProperty<String?>(menuItem.imageURL)
    }
}


