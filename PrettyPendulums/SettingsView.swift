//
//  SettingsView.swift
//  PrettyPendulums
//
//  Created by Dylan Elliott on 18/8/2024.
//

import UIKit
import DylKit

enum SettingsDefaults: String, DefaultsKey {
    case numPendulums
    case numSections
    case offset
    case offsetDelta
    case lineThickness
    case alpha
}

class SettingsView: UIView, UITextFieldDelegate {
    @UserDefaultable(key: SettingsDefaults.numPendulums) private(set) var numPendulums: Int = 100
    @UserDefaultable(key: SettingsDefaults.numSections) private(set) var numSections: Int = 2
    @UserDefaultable(key: SettingsDefaults.offset) private(set) var offset: Double = 0
    @UserDefaultable(key: SettingsDefaults.offsetDelta) private(set) var offsetDelta: Double = 0.0001
    @UserDefaultable(key: SettingsDefaults.lineThickness) private(set) var lineThickness: Int = 5
    @UserDefaultable(key: SettingsDefaults.alpha) private(set) var lineAlpha: Double = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        UIStackView.vertical([
            row(title: "Pendulums", value: numPendulums, formatter: Int.init) { [weak self] in
                self?.numPendulums = $0
            },
            row(title: "Sections", value: numSections, formatter: Int.init) { [weak self] in
                self?.numSections = $0
            },
            row(title: "Offset", value: offset, formatter: Double.init, onUpdate: { [weak self] in
                self?.offset = $0
            }),
            row(title: "Offset Delta", value: offsetDelta, formatter: Double.init, onUpdate: { [weak self] in
                self?.offsetDelta = $0
            }),
            row(title: "Line Thickness", value: lineThickness, formatter: Int.init, onUpdate: { [weak self] in
                self?.lineThickness = $0
            }),
            row(title: "Alpha", value: lineAlpha, formatter: {
                Double($0).map { $0.clamped(to: (0 ... 1)) }
            }, onUpdate: { [weak self] in
                self?.lineAlpha = $0
            }),
            
        ])
        .embedded(in: self, top: 14, leading: 14, trailing: 14, bottomPriority: .defaultHigh)
    }
    
    func row<T: Equatable>(title: String, value: T, formatter: @escaping (String) -> T?, onUpdate: @escaping (T) -> Void) -> UIView {
        return UIStackView.horizontal([
            UILabel(title),
            FormattedTextField(value: value, formatter: formatter, onUpdate: onUpdate)
                ^ (\.textAlignment, .right)
                ^ (\.delegate, self)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

infix operator ^: AdditionPrecedence

protocol Funcable { }

extension Funcable {
    func set<T>(_ keypath: ReferenceWritableKeyPath<Self, T>, _ value: T) -> Self {
        self[keyPath: keypath] = value
        return self
    }
    
    static func ^<T>(lhs: Self, rhs: (keypath: ReferenceWritableKeyPath<Self, T>, value: T)) -> Self {
        lhs.set(rhs.keypath, rhs.value)
    }
}

extension UIView: Funcable { }

