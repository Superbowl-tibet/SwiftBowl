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

func calculateCircleCenter(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint? {
  
  let m0 = p2.y * p1.x
      - p1.y * p2.x
      + p3.y * p2.x
      - p2.y * p3.x
      + p1.y * p3.x
      - p3.y * p1.x
  
  let x = ((pow(p1.x, 2) + pow(p1.y, 2)) * (p2.y - p3.y)
    + (pow(p2.x, 2) + pow(p2.y, 2)) * (p3.y - p1.y)
    + (pow(p3.x, 2) + pow(p3.y, 2)) * (p1.y - p2.y))
    / (m0 * 2.0)
  
  let y = 0
    - ((pow(p1.x, 2) + pow(p1.y, 2)) * (p2.x - p3.x)
    + (pow(p2.x, 2) + pow(p2.y, 2)) * (p3.x - p1.x)
    + (pow(p3.x, 2) + pow(p3.y, 2)) * (p1.x - p2.x))
    / (m0 * 2.0)
  
  if (x.isNaN == false) && (y.isNaN == false) {
    return CGPoint(x: x, y: y)
  }
  return nil
}

class DetectionView: UIView {
  
  struct TouchPoint {
    let location: CGPoint
    let tappedAt: Date
    let velocity: CGFloat
    let circleCenterPoint: CGPoint?
    let radius: CGFloat?
  }
  
  // MARK: - Public API
  var isDebugging = false
  
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
    // TODO: 古いtouchPointを削除する処理を入れたい
    
    let touchPointInView = touch.location(in: self)
    let now = Date()
    
    let p3: TouchPoint
    
    let interval = 10
    let p2Index = self.touchPoints.count - interval
    let p1Index = self.touchPoints.count - (interval * 2)
    
    if p2Index >= 0 {
      
      let p2 = self.touchPoints[p2Index]
      let interval = now.timeIntervalSince(p2.tappedAt)
      let distance = (touchPointInView - p2.location).length
      let velocity = distance / CGFloat(interval)
      var centerPoint: CGPoint? = nil
      var radius: CGFloat? = nil
      
      if p1Index >= 0 {
        let p1 = self.touchPoints[p1Index]
        
        if let c = calculateCircleCenter(p1: p1.location, p2: p2.location, p3: touchPointInView) {
          
          radius = sqrt(pow(c.x-p1.location.x,2)+pow(c.y-p1.location.y,2))
          centerPoint = c
        }
      }
      
      p3 = TouchPoint(location: touchPointInView, tappedAt: now, velocity: velocity, circleCenterPoint: centerPoint, radius: radius)
      
    } else {
      p3 = TouchPoint(location: touchPointInView, tappedAt: now, velocity: 0.0, circleCenterPoint: nil, radius: nil)
    }
    
    self.touchPoints.append(p3)
  }
  
  // MARK: - Drawing
  override func draw(_ rect: CGRect) {
    
    self.backgroundColor?.setFill()
    UIBezierPath(rect: self.bounds).fill()
    
    
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

let a = calculateCircleCenter(p1: CGPoint(x: 1, y: 1), p2: CGPoint(x: 2, y: 1), p3: CGPoint(x: 1, y: 2))
print(a)

class Hoge {
  var hogeArray: [Int] = [] {
    didSet {
      print("array changed: \(hogeArray)")
    }
  }
}

let hoge = Hoge()
hoge.hogeArray.append(1)
hoge.hogeArray = []
hoge.hogeArray.append(3244)


struct Fuga {
  private let fuga = "fugastr"
  
  func some() {
    print(#function)
    print(fuga)
  }
}

extension Fuga {
  private var fuga: Int {
    return 2
  }
  
  func someExt() {
    print(#function)
    print(fuga)
  }
}

print(Fuga().some())
print(Fuga().someExt())



//: [Next](@next)
