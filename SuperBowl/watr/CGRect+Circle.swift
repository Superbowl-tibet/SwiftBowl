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
}
