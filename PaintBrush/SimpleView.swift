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
  var triangle = [
    CGPoint(x: 187.5, y: 427.25),
    CGPoint(x: 268.69, y: 286.625),
    CGPoint(x: 106.31, y: 286.625)
  ]
  
  override func drawRect(rect: CGRect) {
//    self.backgroundColor = UIColor.yellowColor()
//    drawContents()
    let context = UIGraphicsGetCurrentContext()
    diagram.draw(context!)
//    CGContextClosePath(context)
    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
    CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
    CGContextFillPath(context)
    
    CGContextSetLineWidth (context, 6.0)
    CGContextStrokePath(context)
    
  }
  
  override func awakeFromNib() {
    self.backgroundColor = UIColor.yellowColor()
    setNeedsDisplay()
  }
}

