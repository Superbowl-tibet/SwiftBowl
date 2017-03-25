//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

// CocoaPodsでインストールしたframeworkもimportできる
// もしimportエラーが起きたら、そのframeworkを選択して適当なsimulatorでビルドする

var str = "Hello, playground"

print(Spring.self)  // importできてる

// 参考：[Xcode 7のPlaygroundで出来ることまとめ](http://qiita.com/mono0926/items/9f8324637d1dca1e7075)

let redView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
redView.backgroundColor = UIColor.red

PlaygroundPage.current.liveView = redView
// Assistant EditorのTimelineでプレビューがでます
