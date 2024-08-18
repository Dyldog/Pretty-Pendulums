//
//  PendulumDrawer.swift
//  PrettyPendulums
//
//  Created by Dylan Elliott on 18/8/2024.
//

import UIKit

protocol PendulumDrawer {
    func makePendulumView(_ settings: PendulumSettings) -> UIView
    func resetForRedraw()
    func drawPendulum(_ settings: PendulumSettings)
}

extension PendulumDrawer {
    func redrawPendulum(_ settings: PendulumSettings) {
        resetForRedraw()
        drawPendulum(settings)
    }
}
