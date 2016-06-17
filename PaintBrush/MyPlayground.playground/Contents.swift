//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


struct Shape {
  var importantCounter = 1
  mutating func changeCounter(new: Int) {
    importantCounter = new
  }
}

var shape = Shape()

var shapesArray = [Shape]()

shapesArray.append(shape)

shape.changeCounter(5)

shape.importantCounter

shapesArray[0].importantCounter

//the array is not automatically updated when the original object was modified!







