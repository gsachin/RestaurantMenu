//
//  BindableTextField.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/6/21.
//

import Foundation
import UIKit
class BindableTextField: UITextField {
    var notify:((String?)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(didEditingChanged), for: .editingChanged)
    }
    
    func Binding(callback:@escaping (String?)->Void) {
        notify = callback
        notify?(text)
    }
    
    @objc func didEditingChanged()  {
        notify?(text)
    }
}

