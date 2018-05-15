//
//  Circle.swift
//  ballgame
//
//  Created by IKE on 2018/5/10.
//  Copyright © 2018年 IKE. All rights reserved.
//

import UIKit

class Circle {
    
    // MARK: Properties
    static var minRadius: Int {
        switch UIScreen.main.bounds.size.width {
        case 320,375,414:
            return 20
        case 768:
            return 40
        case 1024:
            return 60
        default:
            return 40
        }
    }
    static var maxRadius: Int {
        switch UIScreen.main.bounds.size.width{
        case 320, 375, 414:
            return 50
        case 768:
            return 100
        case 1024:
            return 150
        default:
            return 100
        }
    }
    var color: UIColor
    let radius: Int
    let center: CGPoint

    init(color:UIColor, radius:Int, center:CGPoint){
        self.color = color
        self.radius = radius
        self.center = center
    }
    

    
    class func randomCircle() -> Circle {
        let screenRect = UIScreen.main.bounds
        let screenWidth:CGFloat = screenRect.width
        let screenHeight:CGFloat = screenRect.height
        let randomRadius = minRadius + Int(arc4random_uniform(UInt32(maxRadius - minRadius + 1)))
        
        let areaWidth = Int(screenWidth) - (randomRadius << 1);
        let areaHeight = Int(screenHeight) - (randomRadius << 1) - 20;
        
        let x = randomRadius + Int(arc4random_uniform(100000)) % areaWidth
        let y = 20 + randomRadius + Int(arc4random_uniform(100000)) % areaHeight // below the status bar
        let randomPoint = CGPoint(x: x, y: y)
        
        let randomColor = UIColor.RandomColor
        let circle = Circle(color: randomColor, radius: randomRadius, center: randomPoint)
        return circle
    }
    
}

