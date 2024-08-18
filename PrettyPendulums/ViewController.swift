//
//  ViewController.swift
//  PrettyPendulums
//
//  Created by Dylan Elliott on 17/8/2024.
//

import UIKit
import SpriteKit
import DylKit

class ViewController: UIViewController {
    
    var scene: SKScene!
    var showSettings: Bool = false
    var toolbar: UIStackView!
    var settingsView: SettingsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = SKScene(size: view.bounds.size)
        scene.backgroundColor = .white
        
        let skView = SKView(frame: view.bounds)
        skView.presentScene(scene)
        skView.embedded(in: view)
        
        makeToolbar()
        
        settingsView = SettingsView()
            .embedded(in: view, top: nil, bottom: nil)
            .verticallyPinnedTo(viewAbove: toolbar)
        
        makePendulumView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadSettingsDisplay()
    }
    
    private func makeToolbar() {
        toolbar = UIStackView.horizontal([
            UIButton(title: "Reset") { [weak self] in
                guard let self else { return }
                clearScene()
                makePendulumView()
            },
            UISpacer(),
            UIButton(icon: "gear") { [weak self] in
                guard let self else { return }
                UIView.animate {
                    self.toggleSettings()
                }
            }
        ])
        .pinnedToTop(of: view, padding: 10)
    }
    
    private func toggleSettings() {
        showSettings.toggle()
        reloadSettingsDisplay()
    }
    
    private func reloadSettingsDisplay() {
        //        if showSettings {
        //            settingsView.bottomConstraint?.constant = view.safeAreaInsets.bottom
        //        } else {
        //            settingsView.bottomConstraint?.constant = -(settingsView.frame.height + view.safeAreaInsets.bottom)
        //        }
        
        settingsView.isHidden = !showSettings
        
        if settingsView.isHidden {
            settingsView.resignFirstResponder()
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func clearScene() {
        scene.removeAllChildren()
    }
    
    private func makePendulumView() {
        let count = settingsView.numPendulums
        let sections = settingsView.numSections
        let offset = settingsView.offsetDelta
        let lineThickness = settingsView.lineThickness
        
        (0 ..< count).forEach { index in
            let index = CGFloat(index)
            let count = CGFloat(count)
            let pendulum = SKShapeNode(
                pendulumWithSections: sections,
                length: scene.size.height / 2,
                color: .init(
                    hue: index / CGFloat(count - 1),
                    saturation: 1, brightness: 1, alpha: 0.5
                ),
                thickness: CGFloat(lineThickness),
                offset: (index - count / 2.0) * offset,
                in: scene
            )
        }
    }
}

class MinimalExample: UIViewController {
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






