//
//  ViewController.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/16/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    diagram.elements.append(Scaled(scale: 0.3, subject: diagram))
    diagram.draw(TestRenderer())
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    drawContents()
  }
  
  func drawContents() {
//    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0)
//    let context = UIGraphicsGetCurrentContext()
////    let innerRect = CGRectInset(self.view.bounds, 20, 20)
//    CGContextSetRGBStrokeColor (context, 0.0, 0.0, 1.0, 1.0) // Blue
//    CGContextSetRGBFillColor (context, 0.0, 0.0, 1.0, 1.0) // White
//
//    CGContextSetLineWidth (context, 6.0)
//    print(context!)
//    diagram.draw(context!)
//    CGContextStrokePath(context)
//    view.setNeedsDisplay()
  }
}

