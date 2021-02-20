//
//  BindableProperty.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation
public class BindableProperty<T> : Codable where T:Codable {
    var notify:((T?)->Void)?
    var value : T?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.notify?(self?.value)
            }
        }
    }
    public func Binding(callback:@escaping (T?)->Void) {
        notify = callback
        notify?(value)
    }
    enum CodingKeys:String, CodingKey {
        case value
    }
    public init(_ value:T?) {
        self.value = value
    }
}

public class BindableViewModelProperty<T> {
    var notify:((T?)->Void)?
    var value : T?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.notify?(self?.value)
            }
            
        }
    }
    public func Binding(callback:@escaping (T?)->Void) {
       
        notify = callback
        notify?(value)
    }
    public init(_ value:T?) {
        self.value = value
    }
}
