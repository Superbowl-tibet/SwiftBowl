//
//  ViewController.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InteractiveCircleViewDelegate{
    
    @IBOutlet var anotherCircleView: CircleView!
    @IBOutlet var circleView: InteractiveCircleView!
    
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
    
    let cursor: UIView = {
        let cursor: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0,
                                             width: 40.0, height: 40.0))
        cursor.layer.cornerRadius = (cursor.bounds.width / 2.0)
        cursor.backgroundColor = UIColor.blue
        return cursor
    }()
    
    let anotherCursor: UIView = {
        let cursor: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0,
                                                  width: 40.0, height: 40.0))
        cursor.layer.cornerRadius = (cursor.bounds.width / 2.0)
        cursor.backgroundColor = UIColor.red
        return cursor
    }()

    func anotherCircleDidUpdate() {
        if self.anotherCursor.superview == nil {
            self.anotherCircleView.addSubview(self.anotherCursor)
        }
        let loc = self.anotherCircleView.circleFrame.cursorLocationFrom(degree: 120.0)
        self.anotherCursor.center = loc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.circleView.delegate = self
        self.view.isUserInteractionEnabled = true
        
        self.anotherCircleView.good = 1.0
        
        self.anotherCircleDidUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

