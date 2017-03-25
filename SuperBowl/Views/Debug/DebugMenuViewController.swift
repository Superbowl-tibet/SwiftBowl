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
