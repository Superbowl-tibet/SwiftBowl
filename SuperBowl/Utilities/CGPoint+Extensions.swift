//
//  CGPoint+Extensions.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

extension CGPoint {
    static func + (point: CGPoint, another: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + another.x, y: point.y + another.y)
    }
    
    static func - (point: CGPoint, another: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - another.x, y: point.y - another.y)
    }
    
    var length: CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}
