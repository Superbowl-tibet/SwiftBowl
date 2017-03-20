//
//  Foundation+Extensions.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import Foundation

extension Bundle {
    var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
}
