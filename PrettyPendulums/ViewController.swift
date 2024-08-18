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
    
    var drawer: PendulumDrawer!
    var showSettings: Bool = false
    var toolbar: UIStackView!
    var settingsView: SettingsView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawer = SKScene(size: view.bounds.size)
            ^ (\.backgroundColor, .white)
        
        drawer.makePendulumView(settingsView.settings).embedded(in: view)
        
        makeToolbar()
        
        settingsView
            .embedded(in: view, top: nil, bottom: nil)
            .verticallyPinnedTo(viewAbove: toolbar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadSettingsDisplay()
    }
    
    private func makeToolbar() {
        toolbar = UIStackView.horizontal([
            UIButton(title: "Reset") { [weak self] in
                guard let self else { return }
                drawer.redrawPendulum(settingsView.settings)
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
        settingsView.isHidden = !showSettings
        
        if settingsView.isHidden {
            settingsView.resignFirstResponder()
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
