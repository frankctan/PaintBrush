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

protocol Polygon {
  var corners: [CGPoint] {get set}
  var center: CGPoint {get}
}

protocol Selectable {
  //frame defines the "hitbox" in which a user can interact with a Selectable shape
  var frame: CGRect {get set}
  mutating func updateFrame()
}

//extension Polygon  {
//  //for simplicity, we weight all corners equally for our center calculation
//  var center: CGPoint {
//    get {
//      let total = corners.reduce(CGPoint(), combine: {CGPoint(x: $0.x + $1.x, y: $0.y + $1.y)})
//      return CGPoint(x: total.x / CGFloat(corners.count), y: total.y / CGFloat(corners.count))
//    }
//  }
//}

protocol Draggable: Selectable {
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


struct Square: Polygon, Draggable, Drawable {
  var cornerVectors = [
    Vector(x: -40, y: 40),
    Vector(x: -40, y: -40),
    Vector(x: 40, y: -40),
    Vector(x: 40, y: 40)]
  
  var corners = Array(count: 4, repeatedValue: CGPointZero)
  
  var center = CGPointZero
  
  mutating func updateCorners() {
    for index in 0..<corners.count {
      corners[index].x = cornerVectors[index].x + center.x
      corners[index].y = cornerVectors[index].y + center.y
    }
  }
  
  //Selectable
  var frame = CGRect()
  
  mutating func updateFrame() {
    let cornerX = corners.map {$0.x}
    let cornerY = corners.map {$0.y}
    
    let originX = cornerX.minElement()!
    let originY = cornerX.maxElement()!
    
    let width = cornerX.maxElement()! - cornerX.minElement()!
    let height = cornerY.maxElement()! - cornerY.minElement()!
    
    frame = CGRect(x: originX, y: originY, width: width, height: height)
  }
  
  //Draggable
  mutating func centerDidMove(newCenter: CGPoint) {
    center = newCenter
    updateCorners()
    updateFrame()
  }
}