//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

class DetectionView: UIView {
  
  struct TouchPoint {
    let origin: CGPoint
    let time: Date
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
    print(touchPointInView)
  }
  
  // MARK: - UIResponder
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    self.addTouch(touch: touch)
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
