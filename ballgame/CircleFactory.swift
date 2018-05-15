//
//  CircleFactory.swift
//  ballgame
//
//  Created by IKE on 2018/5/10.
//  Copyright © 2018年 IKE. All rights reserved.
//

import UIKit

class CircleFactory: NSObject{
    
    // MARK: Properties
    static let MaxCircleCount = 20
    static let sharedCircleFactory = CircleFactory()
    let RadiusGap:Float = 10
    
    var circles = [Circle]()
    
    private override init() {
        self.circles.removeAll()
    }
    
    func addCircle() {
        while true {
            let aCircle = Circle.randomCircle()
            if isCircleAvailable(aCircle: aCircle) {
                self.circles.append(aCircle)
                break
            }
            continue
        }
    }
    
    func isCircleAvailable(aCircle: Circle) -> Bool {
        for circle in self.circles {
            let distance = hypotf(
                Float(aCircle.center.x - circle.center.x),
                Float(aCircle.center.y - circle.center.y))
            let radiusLength = Float(aCircle.radius + circle.radius)
            if distance <= radiusLength + RadiusGap {
                return false
            }
        }
        return true
    }
}
