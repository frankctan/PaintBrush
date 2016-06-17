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

protocol Shape: Drawable, Draggable {
  var center: CGPoint {get set}
  //frame defines the "hitbox" in which a user can interact with a shape
  var frame: CGRect {get set}
  mutating func updateFrame()
}

protocol Polygon: Shape {
  var corners: [CGPoint] {get set}
}

protocol Draggable {
  mutating func centerDidMove(newCenter: CGPoint)
  mutating func centerDidMove(previousTouch: CGPoint, newTouch: CGPoint)
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

struct AllShapes: Drawable {
  var array = [Shape]()
  
  mutating func appendShape(shape: Shape) {
    array.append(shape)
  }
  
  func draw(renderer: Renderer) {
    for shape in array {
      shape.draw(renderer)
    }
  }
}

struct Square: Polygon, Drawable {
  var cornerVectors = [
    Vector(x: -40, y: 40),
    Vector(x: -40, y: -40),
    Vector(x: 40, y: -40),
    Vector(x: 40, y: 40)]
  
  let edgeLength: CGFloat = 80
  
  var corners = Array(count: 4, repeatedValue: CGPointZero)
  var frame = CGRect()
  var center = CGPointZero
  
  init(newCenter: CGPoint) {
    centerDidMove(newCenter)
  }
  
  init() {
    centerDidMove(CGPoint(x: edgeLength/2, y: edgeLength/2))
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
    let originY = cornerY.minElement()!
    
    let width = cornerX.maxElement()! - cornerX.minElement()!
    let height = cornerY.maxElement()! - cornerY.minElement()!
    
    frame = CGRect(x: originX, y: originY, width: width, height: height)
  }
  
  mutating func centerDidMove(newCenter: CGPoint) {
    center = newCenter
    updateCorners()
    updateFrame()
  }
  
  mutating func centerDidMove(previousTouch: CGPoint, newTouch: CGPoint) {
    center.x += newTouch.x - previousTouch.x
    center.y += newTouch.y - previousTouch.y
    updateCorners()
    updateFrame()
  }
}

struct Circle: Shape, Drawable {
  var center = CGPointZero
  var radius = CGFloat()
  var frame = CGRect()
  
  init(newCenter: CGPoint) {
    center = newCenter
    radius = 60.0
    updateFrame()
  }
  
  mutating func updateFrame() {
    let originX = center.x - radius
    let originY = center.y - radius
    let origin = CGPoint(x: originX, y: originY)
    let size = CGSize(width: 2 * radius, height: 2 * radius)
    
    frame = CGRect(origin: origin, size: size)
  }
  
  mutating func centerDidMove(newCenter: CGPoint) {
    center = newCenter
    updateFrame()
  }
  
  mutating func centerDidMove(previousTouch: CGPoint, newTouch: CGPoint) {
    center.x += newTouch.x - previousTouch.x
    center.y += newTouch.y - previousTouch.y
    updateFrame()
  }
  
  func draw(renderer: Renderer) {
    renderer.arcAt(center, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2))
  }
}







