//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


struct Shape {
  var importantCounter = 1
  mutating func changeCounter(new: Int) {
    importantCounter = new
  }
  
  func count(new:Int) {
  }
}

var shape = Shape()

var shapesArray = [Shape]()

shapesArray.append(shape)

shape.changeCounter(5)

shape.importantCounter

shapesArray[0].importantCounter = 5


//the array is not automatically updated when the original object was modified!


let a = shapesArray[0]

//a == shapesArray[0]


var b = a
b

print(CGRect(x: 0, y: 0, width: 80, height: 80))


