//
//  ViewController.swift
//  ballgame
//
//  Created by IKE on 2018/5/10.
//  Copyright © 2018年 IKE. All rights reserved.
//

import UIKit
import SpriteKit
//引入多媒体框架
import AVFoundation


class ViewController: UIViewController,UICollisionBehaviorDelegate {
    var lastCircleView = CircleView()
    var mainCircleView = CircleView()
    var circleViews = [CircleView]()
    var dynamicAnimator = UIDynamicAnimator()
    var topfram = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-5, width: UIScreen.main.bounds.width, height: 5))
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panview:")
    //记录触摸点
    var pts = [CGPoint]()
    //var pts = [CGPoint](repeating: CGPoint(), count: 5)
    var path = UIBezierPath()
    var ctr = 0
    var level = 2
    //申明一个播放器
    var bgMusicPlayer = AVAudioPlayer()
    //播放点击的动作音效
    let hitAct = SKAction.playSoundFileNamed("bgm.mp3", waitForCompletion: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleViews.removeAll()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        self.view.backgroundColor = UIColor.white
        //playBackGround()
        for _ in 1...level+1{
            CircleFactory.sharedCircleFactory.addCircle()
        }
        for circle in CircleFactory.sharedCircleFactory.circles {
            let color = UIColor.RandomColor
            circle.color = color
            let cv = CircleView(circle: circle)
            if circle === CircleFactory.sharedCircleFactory.circles.last! {
                self.mainCircleView = cv
            }
            addAnimate(circleview: cv)
            self.view.addSubview(cv)
            cv.layer.cornerRadius = CGFloat(circle.radius)
            cv.layer.masksToBounds = true
            circleViews.append(cv)
        }
        
       
        CircleFactory.sharedCircleFactory.circles.popLast()
        circleViews.popLast()
        self.lastCircleView = circleViews.last!
        mainCircleView.backgroundColor = CircleFactory.sharedCircleFactory.circles.first?.color
        
        //var collisionBehavior = UICollisionBehavior(items: [mainCircleView,circleViews[1]])
        //用参考视图边界作为碰撞边界
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        //collisionBehavior.collisionDelegate = self
         //dynamicAnimator.addBehavior(collisionBehavior)
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //判断是否结束游戏
    func isGameOver() -> Bool {
        if CircleFactory.sharedCircleFactory.circles.count == 0 {
            return true
        }
        return false
    }
    
    //播放背景音乐的音效
    func playBackGround(){
        //获取bgm.mp3文件地址
        let bgMusicURL =  Bundle.main.url(forResource: "bgm", withExtension: "mp3")!
        //根据背景音乐地址生成播放器
        try! bgMusicPlayer = AVAudioPlayer (contentsOf: bgMusicURL)
        //设置为循环播放(
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        //播放音乐
        bgMusicPlayer.play()
    }

    
    func collcheck(){
        for circleview in circleViews{
            if mainCircleView.frame.intersects(circleview.frame)
            {
                if mainCircleView.backgroundColor == circleview.backgroundColor{
                    circleview.removeFromSuperview()
                    self.view.backgroundColor = CircleFactory.sharedCircleFactory.circles.first?.color
                    CircleFactory.sharedCircleFactory.circles.remove(at: 0)
                    mainCircleView.backgroundColor = CircleFactory.sharedCircleFactory.circles.first?.color
                    if isGameOver() == true{
                        var alert = UIAlertView(title: "Congratulation", message: "You clear the color ball ！", delegate: self, cancelButtonTitle: "Confirm")
                        alert.alertViewStyle = UIAlertViewStyle.default
                        //alert.show()
                        if level <= 30 {
                            self.level += 1
                        }
                        viewDidLoad()
                    }
                }
            }
        }
    }
    
    func move(view:UIView,point:CGPoint){
            UIView.animate(withDuration: 0, animations: {
                view.layer.position.x=point.x
                view.layer.position.y=point.y
            },completion: { _ in
                self.collcheck()
            })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let firstTouch = touch.location(in : self.view)
        self.ctr = 0
        self.pts.append(firstTouch)
        //self.path.move(to: firstTouch)
    }
    
    func panview(pan:UIPanGestureRecognizer){
        let curentP = pan.location(in: self.view)
        if (pan.state == UIGestureRecognizerState.began){
            self.path.move(to: curentP)
        }else if(pan.state == UIGestureRecognizerState.changed) {
            self.path.move(to: curentP)
            self.view.setNeedsDisplay();
        }
    }
    
    func drowRect(rect:CGRect){
        self.path.stroke()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            let touchPoint = t.location(in: self.view)
            self.ctr += 1
            self.pts.append(touchPoint)
            move(view: mainCircleView, point: touchPoint)
            /*if (self.ctr == 4) {
                self.pts[3] = CGPoint(x: (self.pts[2].x + self.pts[4].x),
                                      y: (self.pts[2].y + self.pts[4].y))
                self.path.move(to: self.pts[0])
                self.path.addCurve(to: self.pts[3], controlPoint1:self.pts[1],
                                   controlPoint2:self.pts[2])
                self.pts[0] = self.pts[3]
                self.pts[1] = self.pts[4]
                self.ctr = 1
            }*/
        }
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* if self.ctr == 0{
            let touchPoint = self.pts[0]
            self.path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            self.path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
        } else {
            self.ctr = 0
        }
       path.removeAllPoints()*/
        pts.removeAll()
    }
    
    //添加开始动画
    private func addAnimate(circleview:CircleView){
        let delay = Double(arc4random()) / Double(UINT32_MAX) * 0.3
        circleview.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 6.0,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        circleview.alpha = 1
                        circleview.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem) {
        print("duang2!")
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        print("duang3!")
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        print("duang4!")
    }

    func collisioncheck(myview:UIView){
        //print(myview.frame.origin)
        //var p =
        //var i = circleViews[0]
        //print(i.convert(i.frame.origin, to: i),myview.frame.origin)
        
        //if(myview.point(inside: i.convert(i.frame.origin, to: i), with: nil))
        //{
          //  print("duang")
        //}
        /*for i in circleViews{
            //myview.point(inside: i.convert(i.frame.origin, to: i), with: nil)
         
        }*/
        
    }
}

extension UIColor {
    //返回随机颜色
    class var RandomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}


