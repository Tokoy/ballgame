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
    var circleViews = [CircleView]()
    var dynamicAnimator = UIDynamicAnimator()
    var topfram = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-5, width: UIScreen.main.bounds.width, height: 5))
    
    //申明一个播放器
    var bgMusicPlayer = AVAudioPlayer()
    //播放点击的动作音效
    let hitAct = SKAction.playSoundFileNamed("bgm.mp3", waitForCompletion: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        self.view.backgroundColor = UIColor.white
        playBackGround()
        for _ in 0 ..< 10{
            CircleFactory.sharedCircleFactory.addCircle()
        }
        
        for circle in CircleFactory.sharedCircleFactory.circles {
            let color = UIColor.RandomColor
            circle.color = color
            let cv = CircleView(circle: circle)
            
            if circle === CircleFactory.sharedCircleFactory.circles.last! {
                self.lastCircleView = cv
            }
            addAnimate(circleview: cv)
            self.view.addSubview(cv)
            circleViews.append(cv)
        }
        
        topfram.backgroundColor = CircleFactory.sharedCircleFactory.circles.first?.color
        self.view.addSubview(topfram)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        if touch.view.backgroundColor == CircleFactory.sharedCircleFactory.circles.first?.color{
            touch.view.removeFromSuperview()
            self.view.backgroundColor = CircleFactory.sharedCircleFactory.circles.first?.color
            CircleFactory.sharedCircleFactory.circles.remove(at: 0)
            topfram.backgroundColor = CircleFactory.sharedCircleFactory.circles.first?.color
            if isGameOver() == true{
                let alert = UIAlertView(title: "Congratulation", message: "You finished the game！", delegate: self, cancelButtonTitle: "Confirm")
                alert.alertViewStyle = UIAlertViewStyle.default
                alert.show()
            }
        }
        
    //物理引擎代码
     /*   let touch = ((touches as NSSet).anyObject() as AnyObject)
        //重力行为
        let gravite = UIGravityBehavior(items: [touch.view])
        //加速度
        gravite.magnitude = 5

        //碰撞行为
        let collisionBehavior = UICollisionBehavior(items: [touch.view])
        //用参考视图边界作为碰撞边界
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        
        //物体属性行为包括弹性、摩擦力、密度、阻力等等
        let litterBehavior = UIDynamicItemBehavior(items: [touch.view])
        //摩擦力
        litterBehavior.elasticity = 0.6
        //密度
        litterBehavior.density = 2.2
        
        
        let hugeBehavior = UIDynamicItemBehavior(items: [touch.view])
        //弹性
        hugeBehavior.elasticity = 0.8
        //阻力
        hugeBehavior.resistance = 0.3
        //密度
        hugeBehavior.density = 15
        //摩擦力
        hugeBehavior.friction=1;
        
        dynamicAnimator.addBehavior(gravite)
        dynamicAnimator.addBehavior(collisionBehavior)
        dynamicAnimator.addBehavior(litterBehavior)
        dynamicAnimator.addBehavior(hugeBehavior) */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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

    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
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


