//
//  DesignableView.swift
//  YogaFit
//
//  Created by EUGENE on 1/25/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

class DesignableView: UIView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
