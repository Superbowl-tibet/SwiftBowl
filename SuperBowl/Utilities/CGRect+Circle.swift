//
//  CGRect+Circle.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    var radius: CGFloat {
        return (self.width / 2.0)
    }

    func cursorLocationFrom(degree: CGFloat) -> CGPoint {
        let radian = degree * (CGFloat.pi / 180.0)
        return self.cursorLocationFrom(radian: radian)
    }
    
    func cursorLocationFrom(radian: CGFloat) -> CGPoint {
        return CGPoint(x: cos(radian) * self.radius + self.midX,
                       y: sin(radian) * self.radius + self.midY)
    }
}
