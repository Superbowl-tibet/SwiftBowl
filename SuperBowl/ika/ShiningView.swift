//
//  ShiningImageView.swift
//  SuperBowl
//
//  Created by 岡本洋明 on 2017/03/04.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

class ShiningView: UIView {

    let radius : CGFloat = 20.0
    let opacity : Float = 1.0
    
    var glowImageView : UIImageView?

    var shiningLevel : CGFloat = 0.0 {
        didSet {
            
            if shiningLevel > 1.0 {
                shiningLevel = 1.0
            }
            else if shiningLevel < 0 {
                shiningLevel = 0
            }
            
            let color = UIColor.white.cgColor
            let offset = CGSize.zero

            self.layer.shadowColor = color
            self.layer.shadowRadius = radius * shiningLevel
            self.layer.shadowOpacity = opacity * Float(shiningLevel)
            self.layer.shadowOffset = offset
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

    }

    
}
