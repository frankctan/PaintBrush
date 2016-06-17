//
//  ViewController.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/16/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
  
  //we use an imageViewArray to keep track of all the objects we add.
  //TODO: seems we do a whole bunch of hard work to draw an image using value types only to convert to reference
  var images = [UIImageView]()
  var previousTouch = CGPointZero
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func drawCustomImage(center: CGPoint) -> UIImage {
    let square = Square(newCenter: CGPoint(x: 40, y: 40))
    UIGraphicsBeginImageContextWithOptions(square.frame.size, false, 0)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    CGContextSetLineWidth(context, 3.0)
    square.draw(context!)
    CGContextClosePath(context)
//    CGContextTranslateCTM(context, center.x - 40, center.y - 40)
//    print("current transformation matrix: \(CGContextGetCTM(context))")
    CGContextStrokePath(context)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //there should only be one touch as we do not enable multitouch
    guard let touch = touches.first where touches.count == 1 else {print("multiple touches"); fatalError()}
    let touchPosition = touch.locationInView(view)
    print("touchPosition: \(touchPosition)")
    
    for shape in images {
      print("shape frame: \(shape.frame)")
      if CGRectContainsPoint(shape.frame, touchPosition) {
        print("inside shape!")
        return
      }
    }
    
    print("not inside shape!")
    let image = drawCustomImage(touchPosition)
//    let imageView = UIImageView(frame: Square(newCenter: touchPosition).frame)
    let imageView = UIImageView(image: image)
    imageView.frame.origin = CGPoint(x: touchPosition.x - 40, y: touchPosition.y - 40)
//    imageView.image = image
    images.append(imageView)
    self.view.addSubview(imageView)
    images.append(imageView)
    view.setNeedsDisplay()
  }
}

