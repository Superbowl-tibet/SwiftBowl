//
//  BowlsViewController.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import UIKit

class BowlsViewController: UIViewController, InteractiveCircleViewDelegate {
    private var audio: AudioEngine?
    
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
        cursor.backgroundColor = UIColor.green
        return cursor
    }()
    
    func updateAudioParameter(with circleView: CircleView) {
        let parameter: Double =  circleView.parameter
        print(parameter)//ここ
        self.audio?.speed = Float(parameter)
    }
    
    internal func circleSpeedDidUpdate(circleView: CircleView,
                                       didUpdate speed: Double,
                                       currentLocation: CGPoint)
    {
        do {
            if self.cursor.superview != circleView {
                self.cursor.removeFromSuperview()
                circleView.addSubview(self.cursor)
            }
            self.cursor.center = circleView.cursorLocationWith(tapped: currentLocation)
            
            self.updateAudioParameter(with: circleView)
        }
        
        do {
            if self.anotherCursor.superview != self.anotherCircleView {
                self.anotherCursor.removeFromSuperview()
                self.anotherCircleView.addSubview(self.anotherCursor)
            }
            self.anotherCursor.center = self.anotherCircleView.circleFrame.cursorLocationFrom(degree: 120)
            
        }
    }
    
    
    @IBOutlet var backgroundCircleView: JustCircleView!
    @IBOutlet var centerCircleView: JustCircleView!
    
    @IBOutlet var circleView: InteractiveCircleView!
    @IBOutlet var anotherCircleView: CircleView!
    
    
    override func loadView() {
        if let view = UINib(nibName: "BowlsViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.audio == nil {
            self.audio = {
                let engine = SuperBowlAudioEngine()
                engine.speed = 0.0
                engine.sound = .part1
                return engine
            } ()
            self.audio?.play()
            
            Timer.scheduledTimer(withTimeInterval: 0.1,
                                 repeats: true
                , block: { (timer) in
                    self.circleView.downGood()
                    self.updateAudioParameter(with: self.circleView)
            })
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
