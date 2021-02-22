//
//  BindableStepper.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/21/21.
//

import Foundation
import UIKit

class BindableStepper: UIStepper {
    var notify:((Int?)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        minimumValue = 0
        maximumValue = 1000
        stepValue = 1
        //UIControlEventValueChanged
        self.addTarget(self, action: #selector(didEditingChanged), for: .valueChanged)
    }
    
    func Binding(callback:@escaping (Int?)->Void) {
        notify = callback
        notify?(Int(value))
    }
    
    @objc func didEditingChanged()  {
        notify?(Int(value))
    }
}
