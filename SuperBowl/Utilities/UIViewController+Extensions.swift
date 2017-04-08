//
//  UIViewController+Extensions.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func dismiss(sender: AnyObject!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pop(sender: AnyObject!) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topViewController = self.topViewController else {
            return .default
        }
        return topViewController.preferredStatusBarStyle
    }
}
