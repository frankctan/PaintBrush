//
//  ViewController.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/16/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
  
  //UI trackers
  var previousTouch = CGPointZero
  var selectedShape: Shape?
  var selectedShapeIndex: Int?
  
  //allShapes keeps a ledger of active shapes while imageViewArray holds the corresponding UIImageViews.
  var allShapes = AllShapes()
  var imageViewArray = [UIImageView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  ///uses the input shape to calculate the frame (in case of rotation) then aligns the shape's origin
  ///with that of the graphics context to create the UIImage
  func translateShapeToImage(shape: Shape) -> UIImage {
    var tempShape = shape
    UIGraphicsBeginImageContextWithOptions(tempShape.frame.size, false, 0)
    tempShape.centerDidMove(CGPoint(x: shape.frame.size.width/2, y: shape.frame.size.height/2))
    
    let context = UIGraphicsGetCurrentContext()
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    CGContextSetRGBFillColor(context, 0, 0, 1, 1)
    CGContextSetLineWidth(context, 3.0)
    tempShape.draw(context!)
    CGContextClosePath(context)
    CGContextStrokePath(context)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //there should only be one touch as we do not enable multitouch yet
    guard let touch = touches.first where touches.count == 1 else {print("multiple touches"); fatalError()}
    let touchPosition = touch.locationInView(view)
    previousTouch = touchPosition
    
    if isShapeSelected(previousTouch) {return}
    
    addNewShape(touchPosition)
  }
  
  func addNewShape(center: CGPoint) {
    //declare new shape at the touched position
    let shape = Square(newCenter: center)
    
    //translate the shape into a UIImage
    let shapeImage = translateShapeToImage(shape)
    
    //assign an imageView to the new shape at the touch coordinates
    let imageView = UIImageView(frame: shape.frame)
    imageView.image = shapeImage
    
    //assign new shapes and views to their corresponding arrays for future reference
    allShapes.appendShape(shape)
    imageViewArray.append(imageView)
    self.view.addSubview(imageView)
    
    updateSelectedShape(shape, allShapes.array.count - 1)
  }
  
  /// Checks if user touch is within allShapes and updates selectedImage accordingly
  func isShapeSelected(touch: CGPoint) -> Bool {
    for (index, shape) in allShapes.array.enumerate() {
      if CGRectContainsPoint(shape.frame, touch) {
        updateSelectedShape(shape, index)
        return true
      }
    }
    
    updateSelectedShape(nil, nil)
    return false
  }
  
  func updateSelectedShape(shape: Shape?, _ index: Int?) {
    selectedShape = shape
    selectedShapeIndex = index
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first where touches.count == 1 else {print("multiple touches"); fatalError()}
    let touchPosition = touch.locationInView(view)
    
    if selectedShape != nil {
      allShapes.array[selectedShapeIndex!].centerDidMove(previousTouch, newTouch: touchPosition)
      imageViewArray[selectedShapeIndex!].frame.origin = allShapes.array[selectedShapeIndex!].frame.origin
    }
    
    previousTouch = touchPosition
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    updateSelectedShape(nil, nil)
  }
}

