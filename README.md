# Paintbrush 

## Overview

In consideration of the project parameters, I felt that I needed to better understand Swift's type system. Coming into this project, I felt very comfortable with OOP and reference type manipulation. I was not very well acquainted with protocol oriented programming or value type manipulation. [WWDC 2015 - Protocol Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2015/408/) by Dave Abrahams and [Controlling Complexity in Swift](https://realm.io/news/andy-matuschak-controlling-complexity/) by Andy Matuschak were both extremely helpful in providing more clarity. Not only were they in-line with the project advice, both talks used graphics manipulation as the recurring example. Here are a few thoughts on development.

Previous projects have enabled me to get experience in tableViews, rest API's, networking and persistence. I had little experience within the Quartz framework, so I wanted to pick a project that dealt more with drawing and image manipulation.

## Description
Place a square with a single, one-finger tap. Place a circle with a single, two-finger tap (option+click on iOS simulator; option+shift+click to keep touch distance constant). Move any shape with a one-finger drag. Resize circles by two-finger pinching.

Square and Circle are both Structs with mutating functions to update relevant parameters. They inherit from a number of protocols that define their functionality.

##Thoughts
In accordance with Andy Matuschak's talk, I tried to use structs for implementation logic and the view controller for framework interactions such as touch events and graphics rendering. I tried to save as little state as possible in the view controller, but ran into questions when I wanted to access previously drawn shapes. 

For example - A user one-finger taps on the screen to make a square. The program instantiates a new Square value-type and saves the data into a shapes array. The program also renders the shape into an image and sticks the image in a UIImageView. Now there's a square on the screen. Let's say the user makes a couple more squares and circles and decides that some of the squares are in the wrong position. The user taps a square and moves the square into the right position. The program, in order to modify a previously saved shape, has stored an array of UIImageViews whose indices correspond to the shapes array. In this way, the program knows which image the user tapped on and which image to re-orient. This is only possible because the program can modify and redraw a previously existing UIImageView because views are reference types. This seems like a very round-about way to define shapes using value types. I'd really like to know how to simplify this process. 

### Protocol Oriented
Protocol oriented programming seems really useful. Assuming protocols are named appropriately, a user can generally understand what a specific object's capabilities are. Protocol functions can be defined in protocol extensions; protocol functions can even have different definitions based on what other protocols the base object inherits from. 

### Next Steps
The first implementation with squares took a very long time because I wasn't familiar with the Quartz drawing API, protocols, or using value types effectively. However, once the base functionality was laid out, adding circles, even with the extra resizing functionality, took a comparatively short amount of time. Based on this, I think extending this project to include more objects and more varying functionality (image filters, gravity / collision animations, etc) would be more straightforward. 