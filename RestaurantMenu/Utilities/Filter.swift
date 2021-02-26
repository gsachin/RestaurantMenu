//
//  Filter.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/15/21.
//

import Foundation
//MenuItemViewModel Filter which follow Open Close Principle
protocol Specification {
    associatedtype T
    func isSatisfied(_ item:T) -> Bool
}


protocol Filter {
    associatedtype T
    func filter<S:Specification>(_ items:[T], _ spec:S ) -> [T]
    where S.T == T
}


class TextContainsAndCategorySepecification<T,S1:Specification,S2:Specification> : Specification
where T == S1.T, S2.T == T
{
    let s1:S1
    let s2:S2
    init(s1:S1,s2:S2) {
        self.s1 = s1
        self.s2 = s2
    }
    func isSatisfied(_ item: T) -> Bool {
        return s1.isSatisfied(item) && s2.isSatisfied(item)
    }
}


class TextContaintsSpecification:Specification {
    let searchStringToken:String
    init(searchStringToken:String) {
        self.searchStringToken = searchStringToken
    }
    typealias T = MenuItemViewModel
    func isSatisfied(_ item:T) -> Bool {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchStringToken.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
        guard strippedString != "" else {
         return true
        }
        
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        var curTerm = searchItems[0]
        var idx = 0
        var searchFound = curTerm == "" ? true : false
        while curTerm != "" {
            searchFound = searchFound || (item.menuItem.name.lowercased().contains(searchStringToken) ||
                                            ((item.menuItem.descriptions?.description.lowercased().contains(searchStringToken)) ?? false) ||
                                            item.menuItem.ingredients?.description.lowercased().contains(searchStringToken) ?? false)
            idx += 1
            curTerm = (idx < searchItems.count) ? searchItems[idx] : ""
        }
        return searchFound
    }
}

class MinimumQtySpecification:Specification {
    let qty:Int
    init(quantity:Int) {
        self.qty = quantity
    }
    typealias T = MenuItemViewModel
    func isSatisfied(_ item:T) -> Bool {
        return item.quantities.value ?? 0 >= qty
    }
}

class CategorySpecification:Specification {
    let searchToken:Category
    init(searchToken:Category) {
        self.searchToken = searchToken
    }
    typealias T = MenuItemViewModel
    func isSatisfied(_ item:T) -> Bool {
        guard self.searchToken != .all else {
            return true
        }
        return item.menuItem.categories?.contains(searchToken) ?? false
    }
}

class MenuItemViewModelFilter: Filter {
    
    typealias T = MenuItemViewModel
    
    func filter<S:Specification>(_ items:[T], _ spec:S ) -> [T]
    where S.T == T {
        var menuItems = [MenuItemViewModel]()
        for item in items {
            if spec.isSatisfied(item) {
                menuItems.append(item)
            }
        }
        return menuItems
    }
}

class OrderItemViewModelFilter: Filter {
    
    typealias T = MenuItemViewModel
    
    func filter<S:Specification>(_ items:[T], _ spec:S ) -> [T]
    where S.T == T {
        var menuItems = [MenuItemViewModel]()
        for item in items {
            if spec.isSatisfied(item) {
                menuItems.append(item)
            }
        }
        return menuItems
    }
}
