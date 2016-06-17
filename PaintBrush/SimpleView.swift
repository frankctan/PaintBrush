//
//  SimpleView.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/16/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SimpleView: UIView {
  
  var context: CGContext!
  var triangle = [
    CGPoint(x: 187.5, y: 427.25),
    CGPoint(x: 268.69, y: 286.625),
    CGPoint(x: 106.31, y: 286.625)
  ]
  
  override func drawRect(rect: CGRect) {
//    self.backgroundColor = UIColor.yellowColor()
    context = UIGraphicsGetCurrentContext()
//    Square(newCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)).draw(context!)
//    CGContextClosePath(context)
//    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
//    CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
//    CGContextFillPath(context)
//    
//    CGContextSetLineWidth (context, 6.0)
//    CGContextStrokePath(context)
//    drawShape(Square(newCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)))
//    drawShape()
//    super.drawRect(rect)
  }
  
//  func drawShape(shape: Shape) {
////    UIGraphicsBeginImageContext(self.frame.size)
////    let context = UIGraphicsGetCurrentContext()
////    Square(newCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)).draw(context!)
//    shape.draw(context)
//    CGContextClosePath(context)
//    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
//    CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
//    CGContextFillPath(context)
//    
//    CGContextSetLineWidth (context, 6.0)
//    CGContextStrokePath(context)
//  }
//  
//  func drawShape() {
//    for shape in allShapes.shapesArray {
//      shape.draw(context)
//    }
//    
//    CGContextClosePath(context)
//    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
//    CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
//    CGContextFillPath(context)
//
//    CGContextStrokePath(context)
//  }
//  
  override func awakeFromNib() {
//    self.backgroundColor = UIColor.yellowColor()
    setNeedsDisplay()
    
  }
}

