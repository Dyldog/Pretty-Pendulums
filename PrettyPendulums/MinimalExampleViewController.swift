//
//  MinimalExampleViewController.swift
//  PrettyPendulums
//
//  Created by Dylan Elliott on 18/8/2024.
//

import UIKit
import SpriteKit

class MinimalExampleViewController: UIViewController {
    var scene: SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = SKScene(size: view.bounds.size)
        scene.backgroundColor = .white
        
        let anchor = SKShapeNode(circleOfRadius: 10)
        anchor.physicsBody = .init(circleOfRadius: 10)
        anchor.position = .init(x: scene.size.width / 2, y: scene.size.height / 2)
        anchor.physicsBody!.isDynamic = false
        anchor.physicsBody!.angularDamping = 0
        scene.addChild(anchor)
        
        let length: CGFloat = 100
        
        let ball = SKShapeNode(circleOfRadius: 5)
        ball.physicsBody = .init(circleOfRadius: 5)
        ball.physicsBody!.angularDamping = 0
        ball.position = .init(x: length, y: 0)
        anchor.addChild(ball)
        
        let jointPath = CGMutablePath()
        jointPath.move(to: .zero)
        jointPath.addLine(to: .init(x: length, y: 0))
        
        let joint = SKShapeNode(path: jointPath)
        joint.strokeColor = .black
        joint.lineWidth = 5
        joint.position = anchor.convert(.zero, to: ball)
        ball.addChild(joint)
        
        let pin = SKPhysicsJointPin.joint(
            withBodyA: anchor.physicsBody!,
            bodyB: ball.physicsBody!,
            anchor: scene.convert(.zero, from: anchor)
        )
        pin.frictionTorque = 0
        scene.physicsWorld.add(pin)
        
        let skView = SKView(frame: view.bounds)
        skView.presentScene(scene)
        view.addSubview(skView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scene.size = view.bounds.size
        scene.view?.frame = view.bounds
    }
}






