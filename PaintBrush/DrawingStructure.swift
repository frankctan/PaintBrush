////
////  DrawingStructure.swift
////  PaintBrush
////
////  Created by Frank Tan on 6/16/16.
////  Copyright © 2016 PaintBrush. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreGraphics
//
//
////struct Drawing {
////  var actions: [DrawingAction]
////}
////
////struct DrawingAction {
////  var samples: [TouchSample]
////  var resolution: Resolution
////  
////  mutating func appendSample(sample: TouchSample) {
////    samples.append(sample)
////  }
////  
////  enum Resolution {    case Marker
////    case Pencil
////
////    case PaintBrush
////    
////    var lineThickness: CGFloat {
////      switch self {
////      case .Pencil: return 5.0
////      case .Marker: return 10.0
////      case .PaintBrush: return 20.0
////      }
////    }
////  }
////}
////
////struct TouchSample {
////  var location: CGPoint
////}
//
//protocol Renderer {
//  /// Moves the pen to `position` without drawing anything.
//  func moveTo(position: CGPoint)
//  
//  /// Draws a line from the pen's current position to `position`, updating
//  /// the pen position.
//  func lineTo(position: CGPoint)
//  
//  /// Draws the fragment of the circle centered at `c` having the given
//  /// `radius`, that lies between `startAngle` and `endAngle`, measured in
//  /// radians.
//  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
//}
//
//struct TestRenderer : Renderer {
//  func moveTo(p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
//  
//  func lineTo(p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
//  
//  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
//    print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
//  }
//}
//
//protocol Drawable {
//  /// Issues drawing commands to `renderer` to represent `self`.
//  func draw(renderer: Renderer)
//}
//
////: Basic `Drawable`s
//struct Polygon : Drawable {
//  func draw(renderer: Renderer) {
//    renderer.moveTo(corners.last!)
//    for p in corners { renderer.lineTo(p) }
//  }
//  var corners: [CGPoint] = []
//}
//
//struct Circle : Drawable {
//  func draw(renderer: Renderer) {
////    renderer.arcAt(center, radius: radius, startAngle: 0.0, endAngle: twoPi)
//  }
//  var center: CGPoint
//  var radius: CGFloat
//}
//
//struct Diagram : Drawable {
//  func draw(renderer: Renderer) {
//    for f in elements {
//      f.draw(renderer)
//    }
//  }
//  mutating func add(other: Drawable) {
//    elements.append(other)
//  }
//  var elements: [Drawable] = []
//}
//
////: ## Retroactive Modeling
////:
////: Here we extend `CGContext` to make it a `Renderer`.  This would
////: not be possible if `Renderer` were a base class rather than a
////: protocol.
//extension CGContext : Renderer {
//  func moveTo(position: CGPoint) {
//    CGContextMoveToPoint(self, position.x, position.y)
//  }
//  func lineTo(position: CGPoint) {
//    CGContextAddLineToPoint(self, position.x, position.y)
//  }
//  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
//    let arc = CGPathCreateMutable()
//    CGPathAddArc(arc, nil, center.x, center.y, radius, startAngle, endAngle, true)
//    CGContextAddPath(self, arc)
//  }
//}
//
//var circle = Circle(center: CGPoint(x: 187.5, y: 333.5), radius: 93.75)
//
//var triangle = Polygon(corners: [
//  CGPoint(x: 187.5, y: 427.25),
//  CGPoint(x: 268.69, y: 286.625),
//  CGPoint(x: 106.31, y: 286.625)])
//
//var diagram = Diagram(elements: [circle, triangle])
//
//struct ScaledRenderer : Renderer {
//  let base: Renderer
//  let scale: CGFloat
//  
//  func moveTo(p: CGPoint) {
//    base.moveTo(CGPoint(x: p.x * scale, y: p.y * scale))
//  }
//  
//  func lineTo(p: CGPoint) {
//    base.lineTo(CGPoint(x: p.x * scale, y: p.y * scale))
//  }
//  
//  func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
//    let scaledCenter = CGPoint(x: center.x * scale, y: center.y * scale)
//    base.arcAt(scaledCenter, radius: radius * scale, startAngle: startAngle, endAngle: endAngle)
//  }
//}
//
///// A `Drawable` that scales an instance of `Base`
////struct Scaled<Base: Drawable> : Drawable {
////    var scale: CGFloat
////    var subject: Base
////
////    func draw(renderer: Renderer) {
////        subject.draw(ScaledRenderer(base: renderer, scale: scale))
////    }
////}
//
//struct Scaled: Drawable {
//  var scale: CGFloat
//  var subject: Drawable
//  
//  func draw(renderer: Renderer) {
//    subject.draw(ScaledRenderer(base: renderer, scale: scale))
//  }
//}
//
//// Now insert it.
////diagram.elements.append(Scaled(scale: 0.3, subject: diagram))
//
//// Dump the diagram to the console. Use View>Debug Area>Show Debug
//// Area (shift-cmd-Y) to observe the output.
////diagram.draw(TestRenderer())
//
//// Also show it in the view. To see the result, View>Assistant
//// Editor>Show Assistant Editor (opt-cmd-Return).
////showCoreGraphicsDiagram("Diagram") { diagram.draw($0) }
//
//
//
//struct Triangle {
//  
//}
