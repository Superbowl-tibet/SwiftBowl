//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

extension CGPoint {
  static func + (point: CGPoint, another: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + another.x, y: point.y + another.y)
  }

  static func - (point: CGPoint, another: CGPoint) -> CGPoint {
    return CGPoint(x: point.x - another.x, y: point.y - another.y)
  }

  var length: CGFloat {
    return sqrt(self.x * self.x + self.y * self.y)
  }
}

class DetectionView: UIView {
  
  struct TouchPoint {
    let location: CGPoint
    let tappedAt: Date
    let velocity: CGFloat
    //    let circleCenterPoint: CGPoint? // TODO: 実装する
  }
  
  // MARK: - Accessor
  private var touchPoints: [TouchPoint] = []
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  override var isMultipleTouchEnabled: Bool {
    set {}
    get {
      return false
    }
  }
  
  // MARK: - Initializers
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  private func setup() {
    super.isMultipleTouchEnabled = false
  }
  
  // MARK: -
  private func addTouch(touch: UITouch) {
    // TODO: 古いtouchPointを削除する
    
    let touchPointInView = touch.location(in: self)
    let now = Date()
    
    let currentPoint: TouchPoint
    
    if let previousPoint = self.touchPoints.last {
      
      let interval = now.timeIntervalSince(previousPoint.tappedAt)
      let distance = (touchPointInView - previousPoint.location).length
      let velocity = distance / CGFloat(interval)
      
      currentPoint = TouchPoint(location: touchPointInView, tappedAt: now, velocity: velocity)
      
    } else {
      
      currentPoint = TouchPoint(location: touchPointInView, tappedAt: now, velocity: 0.0)
    }
    
    self.touchPoints.append(currentPoint)
    print(currentPoint)
  }
  
  // MARK: - UIResponder
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    self.addTouch(touch: touch) // TODO: velocityが途切れる処理を実装する
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    self.addTouch(touch: touch)
  }
}

let redView = DetectionView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
redView.backgroundColor = UIColor.red

PlaygroundPage.current.liveView = redView
print(redView.becomeFirstResponder())


//: [Next](@next)
