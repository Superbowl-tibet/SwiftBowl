//
//  SwipeDetectionDemoViewController.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/25.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

class SwipeDetectionDemoViewController: UIViewController {
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    
    private var contentViewController: SwipeDetectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "SwipeDetectionView":
            self.contentViewController = segue.destination as! SwipeDetectionViewController
            self.contentViewController.delegate = self
            
        default:
            fatalError("segue.identifierが設定されていません")
        }
    }
}

extension SwipeDetectionDemoViewController: SwipeDetectionViewControllerDelegate {
    func swipeDetectionViewController(controller: SwipeDetectionViewController, didUpdateTouch touch: SwipeDetectionViewController.TouchPoint) {
        
        let pressureValue: String
        if let force = touch.force {
            pressureValue = String(format: "%.1f", force)
        } else {
            pressureValue = "利用不可"
        }
        
        var message = String(format: "速度\n%.1f\n\n圧力\n", touch.velocity) + pressureValue
        if let center = touch.circleCenterPoint,
            let radius = touch.radius {
            message += String(format: "\n\n中心点\n(%.1f, %.1f)\n\n半径\n%.1f", center.x, center.y, radius)
        }
        self.statusLabel.text = message
    }
}
