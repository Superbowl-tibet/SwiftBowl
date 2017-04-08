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

extension CGPoint {
    static func calculateCircleCenter(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint? {
        
        let m0 = p2.y * p1.x
            - p1.y * p2.x
            + p3.y * p2.x
            - p2.y * p3.x
            + p1.y * p3.x
            - p3.y * p1.x
        
        let x = ((pow(p1.x, 2) + pow(p1.y, 2)) * (p2.y - p3.y)
            + (pow(p2.x, 2) + pow(p2.y, 2)) * (p3.y - p1.y)
            + (pow(p3.x, 2) + pow(p3.y, 2)) * (p1.y - p2.y))
            / (m0 * 2.0)
        
        let y = 0
            - ((pow(p1.x, 2) + pow(p1.y, 2)) * (p2.x - p3.x)
                + (pow(p2.x, 2) + pow(p2.y, 2)) * (p3.x - p1.x)
                + (pow(p3.x, 2) + pow(p3.y, 2)) * (p1.x - p2.x))
            / (m0 * 2.0)
        
        guard x.isNaN == false,
            y.isNaN == false,
            x.isInfinite == false,
            y.isInfinite == false
            else {
                return nil
        }
        return CGPoint(x: x, y: y)
    }
}
