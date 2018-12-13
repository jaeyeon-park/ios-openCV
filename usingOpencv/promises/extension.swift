//
//  extension.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

import Foundation

extension Double{
    func roundToPlaces(places : Int)->Double{
        let under = pow(10.0,Double(places));
        return (self * under).rounded()/under;
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
