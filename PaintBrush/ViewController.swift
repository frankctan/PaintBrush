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
  var selectedImage: UIImageView?
  
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
    CGContextStrokePath(context)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //there should only be one touch as we do not enable multitouch
    guard let touch = touches.first where touches.count == 1 else {print("multiple touches"); fatalError()}
    let touchPosition = touch.locationInView(view)
    previousTouch = touchPosition
    print("touchPosition: \(touchPosition)")
    
    let flag = isImageSelected(previousTouch)
    if flag {return}
    
    print("not inside shape!")
    let image = drawCustomImage(touchPosition)
    let imageView = UIImageView(image: image)
    imageView.frame.origin = CGPoint(x: touchPosition.x - 40, y: touchPosition.y - 40)
    images.append(imageView)
    self.view.addSubview(imageView)
  }
  
  /// Checks if user touch is within a shape's imageView and updates selectedImage accordingly
  func isImageSelected(touch: CGPoint) -> Bool {
    for shape in images {
      print("shape frame: \(shape.frame)")
      if CGRectContainsPoint(shape.frame, touch) {
        selectedImage = shape
        print("inside shape!")
        return true
      }
    }
    selectedImage = nil
    return false
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first where touches.count == 1 else {print("multiple touches"); fatalError()}
    let touchPosition = touch.locationInView(view)
    
    if selectedImage != nil {
      selectedImage!.frame.origin.x += touchPosition.x - previousTouch.x
      selectedImage!.frame.origin.y += touchPosition.y - previousTouch.y
    }
    
    previousTouch = touchPosition
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    selectedImage = nil
  }
}

