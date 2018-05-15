//
//  CircleView.swift
//  ballgame
//
//  Created by IKE on 2018/5/10.
//  Copyright © 2018年 IKE. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    var ScreenCenter : CGPoint{
        return convert(center, from: superview)
    }
    
    private func startButtonAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut,.autoreverse],
                       animations: { () -> Void in
                        self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion:nil)
    }
    
    @objc func tapHandler(sender:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut,.autoreverse],
                       animations: { () -> Void in
                        self.transform = CGAffineTransform(scaleX: 2, y: 2)
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion:nil)
    }
    
    init(circle: Circle) {
        let frame = CGRect(x: 0, y: 0, width: CGFloat(circle.radius*2), height: CGFloat(circle.radius*2))
        super.init(frame: frame)
        self.backgroundColor = circle.color
        self.center = circle.center
        self.layer.cornerRadius = CGFloat(circle.radius)

        self.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapGR.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGR)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
