//
//  BowlsViewController.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import UIKit

class BowlsViewController: UIViewController, InteractiveCircleViewDelegate {
    let cursor: UIView = {
        let cursor: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0,
                                                  width: 40.0, height: 40.0))
        cursor.layer.cornerRadius = (cursor.bounds.width / 2.0)
        cursor.backgroundColor = UIColor.blue
        return cursor
    }()
    
    internal func circleSpeedDidUpdate(circleView: CircleView,
                                       didUpdate speed: Double,
                                       currentLocation: CGPoint)
    {
        if self.cursor.superview != circleView {
            self.cursor.removeFromSuperview()
            circleView.addSubview(self.cursor)
        }
        self.cursor.center = circleView.cursorLocationWith(tapped: currentLocation)
    }
    
    @IBOutlet var centerCircleView: JustCircleView!
    @IBOutlet var backgroundCircleView: JustCircleView!
    @IBOutlet var circleView: InteractiveCircleView!
    
    override func loadView() {
        if let view = UINib(nibName: "BowlsViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    var centerCircleColor: UIColor = UIColor.cyan
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundCircleView.isOpaque = false
        self.backgroundCircleView.color = UIColor.white
        
        self.centerCircleView.isOpaque = false
        self.centerCircleView.color = centerCircleColor
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "XXX Group")!)

        self.circleView.delegate = self
    }
}
