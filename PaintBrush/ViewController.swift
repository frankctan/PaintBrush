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
  var pinchDistance: CGFloat?
  
  //for organization
  enum AvailableShapes {
    case Square
    case Circle
  }
  //for fun
  let colors = [UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(),
                UIColor.cyanColor(), UIColor.orangeColor()]

  
  //allShapes keeps a ledger of active shapes while imageViewArray hold the corresponding UIImageViews.
  var allShapes = AllShapes()
  var imageViewArray = [UIImageView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //two finger touch for cicles
    self.view.multipleTouchEnabled = true
  }
  
  ///uses the input shape to calculate the frame (in case of rotation) then aligns the shape's origin
  ///with that of the graphics context to create the UIImage
  func translateShapeToImage(shape: Shape) -> UIImage {
    var tempShape = shape
    UIGraphicsBeginImageContextWithOptions(tempShape.frame.size, false, 0)
    tempShape.centerDidMove(CGPoint(x: shape.frame.size.width/2, y: shape.frame.size.height/2))
    
    let context = UIGraphicsGetCurrentContext()
    CGContextSetStrokeColorWithColor(context, colors[random(colors.count)].CGColor)
    CGContextSetLineWidth(context, 3.0)
    tempShape.draw(context!)
    CGContextClosePath(context)
    CGContextStrokePath(context)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = touches.first!
    let touchPosition = touch.locationInView(view)
    previousTouch = touchPosition
    
    //if shape is selected, return to prevent creation of new shape
    if isShapeSelected(previousTouch) {return}
    
    //if 1 finger, add new square; if 2 fingers, add new circle
    switch touches.count {
    case 1:
      addNewShape(touchPosition, newShape: .Square)
    case 2:
      print("two finger touch")
      addNewShape(touchPosition, newShape: .Circle)
      let touchArray = Array(touches)
      pinchDistance = calculatePinchDistance(touchArray[0], touch2: touchArray[1])
    default: print("tapped too many times!")
    }
  }
  
  ///calculates the distance between two UITouches
  func calculatePinchDistance(touch1: UITouch, touch2: UITouch) -> CGFloat {
    let p1 = touch1.locationInView(view)
    let p2 = touch2.locationInView(view)
    
    return hypot(p1.x - p2.x, p1.y - p2.y)
  }
  
  ///updates selectedShape, allShapes and imageViewArray
  func addNewShape(center: CGPoint, newShape: AvailableShapes) {
    //declare new shape at the touched position
    var shape: Shape
    switch newShape {
    case .Square: shape = Square(newCenter: center)
    case .Circle: shape = Circle(newCenter: center)
    }
    
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
  
  ///checks if user touch is within allShapes and updates selectedImage accordingly
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
  
  ///update ViewController's instance variables
  func updateSelectedShape(shape: Shape?, _ index: Int?) {
    selectedShape = shape
    selectedShapeIndex = index
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = touches.first!
    let touchPosition = touch.locationInView(view)
    
    //return if no shape is selected and no shape was selected
    guard isShapeSelected(touchPosition) || selectedShape != nil else {return}
    
    //if 1 finger move the shape; if 2 finger resize if circle
    switch touches.count {
    case 1:
      allShapes.array[selectedShapeIndex!].centerDidMove(previousTouch, newTouch: touchPosition)
      imageViewArray[selectedShapeIndex!].frame.origin = allShapes.array[selectedShapeIndex!].frame.origin
    
    case 2:
      guard selectedShape is Circle else {
        break
      }
      //Assign pinch distance based on 2 finger touch
      var touchArray = Array(touches)
      let newPinchDistance = calculatePinchDistance(touchArray[0], touch2: touchArray[1])
      if pinchDistance == nil {pinchDistance = newPinchDistance}
      
      //update the relevant variables
      var circle = allShapes.array[selectedShapeIndex!] as! Circle
      circle.shapeDidResize(newPinchDistance - pinchDistance!)
      allShapes.array[selectedShapeIndex!] = circle
      imageViewArray[selectedShapeIndex!].frame = circle.frame
      pinchDistance = newPinchDistance
      
    default: break
    }
    previousTouch = touchPosition
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    updateSelectedShape(nil, nil)
    pinchDistance = nil
  }
  
  func random(n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
  }
}