//
//  CustomMKPinAnnotationView.swift
//  YogaFit
//
//  Created by EUGENE on 04.07.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import MapKit
class CustomMKPinAnnotationView: MKPinAnnotationView {

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //nil
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point)
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }

}


