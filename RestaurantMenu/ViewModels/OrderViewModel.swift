//
//  OrderViewModel.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/21/21.
//

import Foundation
struct OrderViewModel {
    var order = Order(restaurantId: UUID(), orderItems: [MenuItem]())
    var restaurantId:BindableProperty<UUID>? {
        didSet {
            if let restaurantid = restaurantId?.value {
                order.restaurantId = restaurantid
            }
        }
    }
    mutating func calculateAmount() {
        //order.orderItems = orderItems
        var t = 0.0
        if let itemVMs = orderItemViewModelList?.value {
            for item in itemVMs {
                if let price = item.price.value, let qty = item.quantities.value {
                    t += price * Double(qty)
                }
                order.orderItems.append(item.menuItem)
            }
            guard self.total != nil else {
                self.total = BindableProperty(t)
               validate()
                return
            }
            self.total?.value = t
           validate()
        }
    }
    
    var orderItemViewModelList : BindableViewModelProperty<[MenuItemViewModel]>?
    {
        didSet {
            calculateAmount()
        }
    }
    var mobileNumber:BindableProperty<String>? = BindableProperty<String>("")  {
        didSet {
           validate()
        }
    }
    var tableNumber:BindableProperty<String>?  = BindableProperty<String>("") {
        didSet {
          validate()
        }
        }
    var emailId:BindableProperty<String>?
    //{
//    didSet {
//        isVailid.value = mobileNumber?.value != nil && !(mobileNumber?.value!.isEmpty ?? false) && emailId?.value != nil && !(emailId?.value!.isEmpty ?? false)  && (total?.value ?? 0) > 0
//    }
///    }
    var isVailid = BindableProperty<Bool>(false)
    var total:BindableProperty<Double>? {
        didSet {
            if let value = total?.value {
                order.total = value
            }
        }
    }
    func validate()  {
        isVailid.value = mobileNumber?.value != nil && !(mobileNumber?.value!.isEmpty ?? false) && tableNumber?.value != nil && !(tableNumber?.value!.isEmpty ?? false)  && (total?.value ?? 0) > 0
    }
    init(orderItemViewModelList:[MenuItemViewModel]) {
        self.orderItemViewModelList = BindableViewModelProperty(orderItemViewModelList)
        calculateAmount()
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return self.orderItemViewModelList?.value?.count ?? 0
    }
    
    func modelAt(_ index: Int) -> MenuItemViewModel? {
        return self.orderItemViewModelList?.value?[index]
    }
}
