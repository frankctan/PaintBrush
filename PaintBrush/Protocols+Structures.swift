//
//  Protocols+Structures.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/17/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import Foundation
import UIKit


typealias Vector = CGPoint

protocol Shape: Drawable {
  var center: CGPoint {get set}
  //frame defines the "hitbox" in which a user can interact with a shape
  var frame: CGRect {get set}
  mutating func updateFrame()
}

protocol Polygon: Shape {
  var corners: [CGPoint] {get set}
}

protocol Draggable: Shape {
  mutating func centerDidMove(newCenter: CGPoint)
}

protocol Drawable {
  func draw(renderer: Renderer)
}

//draw function will always be the same if the object also inherits from Polygon
extension Drawable where Self: Polygon {
  func draw(renderer: Renderer) {
    renderer.moveTo(corners.last!)
    for corner in corners {
      renderer.lineTo(corner)
    }
  }
}

protocol Renderer {
  /// Moves the pen to `position` without drawing anything.
  func moveTo(position: CGPoint)
  
  /// Draws a line from the pen's current position to `position`, updating
  /// the pen position.
  func lineTo(position: CGPoint)
  
  /// Draws the fragment of the circle centered at `c` having the given
  /// `radius`, that lies between `startAngle` and `endAngle`, measured in
  /// radians.
  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}

extension CGContext: Renderer {
  func moveTo(position: CGPoint) {
    CGContextMoveToPoint(self, position.x, position.y)
  }
  func lineTo(position: CGPoint) {
    CGContextAddLineToPoint(self, position.x, position.y)
  }
  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
    let arc = CGPathCreateMutable()
    CGPathAddArc(arc, nil, center.x, center.y, radius, startAngle, endAngle, true)
    CGContextAddPath(self, arc)
  }
}

struct AllShapes {
  var shapesArray = [Shape]()
  
  mutating func appendToShapesArray(shape: Shape) {
    shapesArray.append(shape)
  }
}

struct Square: Polygon, Draggable, Drawable {
  var cornerVectors = [
    Vector(x: -40, y: 40),
    Vector(x: -40, y: -40),
    Vector(x: 40, y: -40),
    Vector(x: 40, y: 40)]
  
  var corners = Array(count: 4, repeatedValue: CGPointZero)
  var frame = CGRect()
  var center = CGPointZero
  
  init(newCenter: CGPoint) {
    centerDidMove(newCenter)
  }
  
  mutating func updateCorners() {
    for index in 0..<corners.count {
      corners[index].x = cornerVectors[index].x + center.x
      corners[index].y = cornerVectors[index].y + center.y
    }
  }
  
  mutating func updateFrame() {
    let cornerX = corners.map {$0.x}
    let cornerY = corners.map {$0.y}
    
    let originX = cornerX.minElement()!
    let originY = cornerX.maxElement()!
    
    let width = cornerX.maxElement()! - cornerX.minElement()!
    let height = cornerY.maxElement()! - cornerY.minElement()!
    
    frame = CGRect(x: originX, y: originY, width: width, height: height)
  }
  
  mutating func centerDidMove(newCenter: CGPoint) {
    center = newCenter
    print("square.center: \(center)")
    updateCorners()
    updateFrame()
  }
}