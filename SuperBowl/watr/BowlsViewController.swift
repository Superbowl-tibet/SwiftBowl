//
//  BowlsViewController.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import UIKit

class BowlsViewController: UIViewController {
    @IBOutlet var centerCircleView: CircleView!

    override func loadView() {
        if let view = UINib(nibName: "BowlsViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    var centerCircleColor: UIColor = UIColor.cyan
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerCircleView.filledBackgroundColor = centerCircleColor
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "XXX Group")!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
