//
//  DebugMenuViewController.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

final class DebugMenuViewController: UITableViewController, IBInstantiatable {

    @IBOutlet private weak var versionInfoCell: UITableViewCell! {
        didSet {
            let mainBundle = Bundle.main
            self.versionInfoCell.textLabel!.text = "Version \(mainBundle.appVersion) (\(mainBundle.buildNumber))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

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
//        print(touch)
        
        var message = String(format: "速度\n%.1f", touch.velocity)
        if let center = touch.circleCenterPoint,
            let radius = touch.radius {
            message += String(format: "\n\n中心点\n(%.1f, %.1f)\n\n半径\n%.1f", center.x, center.y, radius)
        }        
        self.statusLabel.text = message
    }
}
