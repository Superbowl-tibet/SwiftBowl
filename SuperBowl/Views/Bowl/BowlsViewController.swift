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
        cursor.backgroundColor = #colorLiteral(red: 0.7411764706, green: 0.05882352941, blue: 0.8823529412, alpha: 1)
        return cursor
    }()
    
    let anotherCursor: UIView = {
        let cursor: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0,
                                                  width: 40.0, height: 40.0))
        cursor.layer.cornerRadius = (cursor.bounds.width / 2.0)
        cursor.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)

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
            
            circleView.upGood()
            self.updateAudioParameter(with: circleView)
        }
        
        do {
            if self.anotherCursor.superview != self.anotherCircleView {
                self.anotherCursor.removeFromSuperview()
                self.anotherCircleView.addSubview(self.anotherCursor)
            }
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
            self.audio = SuperBowlAudioEngine()
            self.audio?.play()
            
            Timer.scheduledTimer(withTimeInterval: 0.1,
                                 repeats: true
                , block: { (timer) in
                    if !self.circleView.hasTouch {
                        self.circleView.downGood()
                        self.updateAudioParameter(with: self.circleView)
                    }
            })
        }
        
        self.animateCursor()
    }
    
    var dummyPlanetTimer: Timer?
    
    func animateCursor() {
        
        var i: CGFloat = 0.0
        let interval: TimeInterval = 0.05
        let duration = interval * 0.95
        
        self.dummyPlanetTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (_) in
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                self.anotherCursor.center = self.anotherCircleView.circleFrame.cursorLocationFrom(degree: i)
                i += 1.0
            }, completion: { (_) in
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.dummyPlanetTimer?.invalidate()
        self.dummyPlanetTimer = nil
        
        super.viewDidDisappear(animated)
    }
    
    var centerCircleColor: UIColor = #colorLiteral(red: 0.2862745098, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundCircleView.isOpaque = false
        self.backgroundCircleView.color = UIColor.white
        
        self.centerCircleView.isOpaque = false
        self.centerCircleView.color = centerCircleColor
        
        self.circleView.delegate = self        
    }
    
    @IBAction func openResultView(sender: AnyObject!) {
        
        let resultViewController = ResultViewController(nibName: nil, bundle: nil)
        resultViewController.modalTransitionStyle = .flipHorizontal
        
        self.present(resultViewController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
