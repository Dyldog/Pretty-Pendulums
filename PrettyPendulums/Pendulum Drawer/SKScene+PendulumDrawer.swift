//
//  SKShapeNode+Pendulum.swift
//  PrettyPendulums
//
//  Created by Dylan Elliott on 18/8/2024.
//

import SpriteKit
import DylKit

extension SKScene: PendulumDrawer {
    func makePendulumView(_ settings: PendulumSettings) -> UIView {
        backgroundColor = .white
        blendMode = .multiply
        
        drawPendulum(settings)
        
        let skView = SKView(frame: .init(origin: .zero, size: size))
        skView.presentScene(scene)
        return skView
    }
    
    func resetForRedraw() {
        removeAllChildren()
    }
    
    func drawPendulum(_ settings: PendulumSettings) {
        let count = settings.numPendulums
        let sections = settings.numSections
        let offset = settings.offset
        let offsetDelta = settings.offsetDelta
        let lineThickness = settings.lineThickness
        let lineAlpha = settings.lineAlpha
        let gravity = settings.gravity
        
        physicsWorld.gravity = .init(dx: 0, dy: gravity)
        
        (0 ..< count).forEach { index in
            let index = CGFloat(index)
            let count = CGFloat(count)
            let pendulum = SKShapeNode(
                pendulumWithSections: sections,
                length: self.size.height / 2,
                color: .init(
                    hue: index / CGFloat(count - 1),
                    saturation: 1, brightness: 1, alpha: lineAlpha
                ),
                thickness: CGFloat(lineThickness),
                offset: offset,
                offsetDelta: (index - count / 2.0) * offsetDelta,
                in: self
            )
        }
    }
}

extension SKScene: Funcable { }

extension SKShapeNode {
    convenience init(circleOfRadius radius: CGFloat, backgroundColor: UIColor, in scene: SKScene? = nil) {
        self.init(circleOfRadius: radius)
        position = .init(x: 0, y: 400)
        fillColor = backgroundColor
        strokeColor = .clear
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        scene?.addChild(self)
    }
    
    convenience init(
        armOfLength length: CGFloat,
        connectedTo anchor: SKNode,
        radius: CGFloat,
        armColor: UIColor = .black,
        thickness: CGFloat,
        ballColor: UIColor = .blue
    ) {
        self.init(circleOfRadius: radius, backgroundColor: ballColor)
        physicsBody!.friction = 0
        physicsBody!.angularDamping = 0
        physicsBody!.restitution = 1
        position = .init(x: length, y: 0)
        anchor.addChild(self)
        
        let jointPath = CGMutablePath()
        jointPath.move(to: .zero)
        jointPath.addLine(to: .init(x: length, y: 0))
        
        let joint = SKShapeNode(path: jointPath)
        joint.strokeColor = armColor
        joint.lineWidth = thickness
        joint.lineCap = .round
        joint.position = anchor.convert(.zero, to: self)
        self.addChild(joint)
        
        let pin = SKPhysicsJointPin.joint(
            withBodyA: anchor.physicsBody!,
            bodyB: self.physicsBody!,
            anchor: anchor.scene!.convert(.zero, from: anchor)
        )
        pin.frictionTorque = 0
        pin.bodyA.angularDamping = 0
        pin.bodyB.angularDamping = 0

        anchor.scene!.physicsWorld.add(pin)
    }
    
    convenience init(pendulumWithSections sections: Int, length: CGFloat, color: UIColor, thickness: CGFloat, offset: CGFloat, offsetDelta: CGFloat, in scene: SKScene) {
        let ballRadius: CGFloat = thickness / 2.0
        let lineThickness: CGFloat = thickness
        
        self.init(circleOfRadius: ballRadius, backgroundColor: .clear, in: scene)
        self.position.x = scene.size.width / 2
        self.position.y = scene.size.height * (1.0 / 2.0)
        self.zRotation = .pi / 2.0 + offset
        self.physicsBody?.isDynamic = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.mass = 1000
        
        var lastWeight: SKNode = self
        let weightCount = sections
        let armLength = length / CGFloat(weightCount)
        
        (0 ..< weightCount).forEach { index in
            let weight = SKShapeNode(
                armOfLength: armLength + CGFloat(index + 1),
                connectedTo: lastWeight,
                radius: ballRadius,
                armColor: color,
                thickness: lineThickness,
                ballColor: color
            )
            
            weight.physicsBody!.collisionBitMask = 0;
            
            weight.zRotation += offsetDelta
            
            lastWeight = weight
        }
    }
}
