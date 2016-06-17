//
//  Protocols+Structures.swift
//  PaintBrush
//
//  Created by Frank Tan on 6/17/16.
//  Copyright © 2016 PaintBrush. All rights reserved.
//

import Foundation
import UIKit

///polygon corners can be calculated by adding the center coordinate to a series of corner vectors
typealias Vector = CGPoint

//All Shapes are both drawable and draggable
protocol Shape: Drawable, Draggable {
  var center: CGPoint {get set}
  //frame defines the "hitbox" in which a user can interact with a shape and will always be a rectangle
  var frame: CGRect {get set}
  mutating func updateFrame()
}

//Polygons are shapes and have corners, circles don't
protocol Polygon: Shape {
  var corners: [CGPoint] {get set}
}

//Only circles are currently resizable
protocol Resizable: Shape {
  mutating func shapeDidResize(vector: CGFloat)
}

//By moving the center of a shape, the frame coordinates can be calcuated
protocol Draggable {
  mutating func centerDidMove(newCenter: CGPoint)
  mutating func centerDidMove(previousTouch: CGPoint, newTouch: CGPoint)
}

//adapted from WWDC 2015 - Protocol Oriented Programming Talk
//Polygons are rendered by moving to a base position and then drawing lines between corners
//Circles are rendered by drawing an arc from 0 to 2pi
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

//adapted from WWDC 2015
protocol Drawable {
  func draw(renderer: Renderer)
}

//draw function will always be the same if the object also inherits from Polygon
//extensible protocols and selective inheritance pave the way for all sorts of optimizations
extension Drawable where Self: Polygon {
  func draw(renderer: Renderer) {
    renderer.moveTo(corners.last!)
    for corner in corners {
      renderer.lineTo(corner)
    }
  }
}

//also from WWDC 2015 - CGContext can be extended by a protocol, and functions can be defined
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

//MARK: Shape Structs

//tracks active shapes using an array
struct AllShapes: Drawable {
  var array = [Shape]()
  
  mutating func appendShape(shape: Shape) {
    array.append(shape)
  }
  
  //draws all shapes in the array by rendering
  func draw(renderer: Renderer) {
    for shape in array {
      shape.draw(renderer)
    }
  }
}

struct Square: Polygon, Drawable {
  
  //corner coordinates can be calculated by adding the corner vector to the center
  //for future versions, corner vectors can be multiplied by a rotation matrix to rotate
  //the shape in place
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
  
  //updates the "hitbox" of the square by storing a frame around a square
  //updateFrame() should also support rotated squares but has not yet been tested
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

//Circle is very similar to Square
struct Circle: Shape, Drawable, Resizable {
  var center = CGPointZero
  var radius = CGFloat()
  var frame = CGRect()
  
  init(newCenter: CGPoint) {
    center = newCenter
    radius = 60.0
    updateFrame()
  }
  
  mutating func updateFrame() {
    //circle drawing is cut off without padding
    let padding: CGFloat = 5
    let originX = center.x - radius - padding
    let originY = center.y - radius - padding
    let origin = CGPoint(x: originX, y: originY)
    let size = CGSize(width: 2 * radius + 2 * padding, height: 2 * radius + 2 * padding)
    
    frame = CGRect(origin: origin, size: size)
  }
  
  mutating func centerDidMove(newCenter: CGPoint) {
    center = newCenter
    updateFrame()
  }
  
  mutating func shapeDidResize(vector: CGFloat) {
    radius += vector
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