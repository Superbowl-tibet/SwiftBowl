//
//  File.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import UIKit

class JustCircleView: UIView {
    var color: UIColor?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        do {
            context.saveGState()
            let backgroundColor: UIColor = UIColor.clear
            
            context.setFillColor(backgroundColor.cgColor)
            context.fill(rect)
            context.restoreGState()
        }
        
        if let fillColor = self.color {
            context.saveGState()
            context.addEllipse(in: self.bounds)
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
            
            context.restoreGState()
        }
        
        UIGraphicsEndImageContext()
    }
}
