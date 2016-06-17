//
//  ViewController.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/16/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import UIKit
var allShapes = AllShapes()
class ViewController: UIViewController {
  var previousTouch = CGPointZero
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
//    drawContents()
  }
  
//  func drawContents() {
//        let context = UIGraphicsGetCurrentContext()
//        diagram.draw(context!)
//        CGContextClosePath(context)
//        CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
//        CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
//        CGContextFillPath(context)
//    
//        CGContextSetLineWidth (context, 6.0)
//        CGContextStrokePath(context)
//  }
  
//  func isTouchInsideShape(touch: CGPoint, shape: CGRect) -> Bool{
//    if touch.x >= shape.origin.x &&
//      touch.x <= shape.origin.x + shape.size.width &&
//      touch.y >= shape.origin.y &&
//      touch.y <= shape.origin.y + shape.size.height {
//      return true
//    }
//    return false
//  }
  
//  func drawShape(shape: Shape) {
//    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0)
//    let context = UIGraphicsGetCurrentContext()
//    
//    //TODO: color can be customizable by the struct
//    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
//    CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
//
//    shape.draw(context!)
//    CGContextStrokePath(context)
//    view.setNeedsDisplay()
//  }
  
  func drawCustomImage(center: CGPoint) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    CGContextSetLineWidth(context, 3.0)
    Square(newCenter: center).draw(context!)
    CGContextClosePath(context)
    CGContextStrokePath(context)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //there should only be one touch as we do not enable multitouch
    guard let touch = touches.first where touches.count == 1 else {print("multiple touches"); fatalError()}
    let touchPosition = touch.locationInView(view)
    for shape in allShapes.shapesArray {
      if CGRectContainsPoint(shape.frame, touchPosition) {
        print("inside shape!")
        return
      }
    }
    print("not inside shape!")
    let image = drawCustomImage(touchPosition)
    let imageView = UIImageView(image: image)
    self.view.addSubview(imageView)
    
//    allShapes.appendToShapesArray(Square(newCenter: touchPosition))
    view.setNeedsDisplay()
  }
}

