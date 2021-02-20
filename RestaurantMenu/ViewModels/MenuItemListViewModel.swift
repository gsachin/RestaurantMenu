//
//  MenuItemListViewModel.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation
struct MenuItemListViewModel {
    var Items = BindableViewModelProperty<[MenuItemViewModel]>([MenuItemViewModel]()) {
        didSet {
                filterItems = BindableViewModelProperty<[MenuItemViewModel]>(Items.value)
            }
    }
    var filterItems:BindableViewModelProperty<[MenuItemViewModel]>?
    
    var selectedCategory = BindableProperty<Category>(Category.all) {
        didSet {
            if let selectedValue = selectedCategory.value, selectedValue != Category.all {
                filterByCategories(selectedValue)
            } else {
                filterItems = BindableViewModelProperty<[MenuItemViewModel]>(Items.value)
            }
        }
    }
    
    static var categories = BindableProperty<[Category]>(Category.allCases)
    
    var searchToken = BindableProperty<String>("") {
        didSet {
            if let searchValue = searchToken.value , searchValue.trimmingCharacters(in: .whitespaces) != "" {
                filterByText(searchValue)
            }
        }
    }
    
    var showSuggestedSearch = BindableProperty<Bool>(false)
    
    mutating func filterByCategories(_ selectedCategory:Category)  {
        let categorySpecification = CategorySpecification(searchToken: selectedCategory)
        if let items = self.Items.value {
            let result = MenuItemViewModelFilter().filter(items, categorySpecification)
            self.filterItems?.value?.removeAll()
            self.filterItems?.value?.append(contentsOf:result)
        }
    }
    
    mutating func filterByText(_ searchToken:String) {
        let textSpecification = TextContaintsSpecification(searchStringToken: searchToken)
        if let items = self.Items.value {
            let result = MenuItemViewModelFilter().filter(items, textSpecification)
            self.filterItems?.value?.removeAll()
            self.filterItems?.value?.append(contentsOf:result)
        }
    }
    
    mutating func filterByCategoriesAndText(selectedCategory:Category, searchToken:String)  {
        let textSpecification = TextContaintsSpecification(searchStringToken: searchToken)
        let categorySpecification = CategorySpecification(searchToken: selectedCategory)
        let specification = TextContainsAndCategorySepecification(s1: textSpecification, s2: categorySpecification)
        if let items = self.Items.value {
            let result = MenuItemViewModelFilter().filter(items, specification)
            self.filterItems?.value?.removeAll()
            self.filterItems?.value?.append(contentsOf:result)
        }
    }
   
    func numberOfRows(_ section: Int) -> Int {
        return self.filterItems?.value?.count ?? 0
    }
    
    func modelAt(_ index: Int) -> MenuItemViewModel? {
        return self.filterItems?.value?[index]
    }
    
    mutating func reset() {
        filterItems = BindableViewModelProperty<[MenuItemViewModel]>(Items.value)
    }
}

