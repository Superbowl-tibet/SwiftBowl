//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

class DetectionView: UIView {
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
  }
}

let redView = DetectionView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
redView.backgroundColor = UIColor.red

PlaygroundPage.current.liveView = redView
print(redView.becomeFirstResponder())


//: [Next](@next)
