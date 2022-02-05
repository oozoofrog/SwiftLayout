//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout {
    @discardableResult
    func active() -> AnyDeactivatable
    func reactive()
    func deactive()
    func deactiveRoot()
    
    var isActivating: Bool { get }
    
    var hashable: AnyHashable { get }
    
    var tagDescription: String { get }
}

extension Layout {
    public var isActivating: Bool { false }
    public var tagDescription: String { "" }
}

extension Layout {
    public func reactive() {}
    public func deactiveRoot() {
        deactive()
    }
}

public extension Layout where Self: LayoutContainable {
    
    func active() -> AnyDeactivatable {
        layouts.forEach({ layout in _ = layout.active() })
        return AnyDeactivatable()
    }
    
    func deactive() {
        layouts.forEach({ layout in layout.deactive() })
    }
    
    var hashable: AnyHashable {
        AnyHashable([typeString(of: self)] + layouts.map(\.hashable))
    }
    
    func constraints(with view: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for layout in layouts {
            constraints.append(contentsOf: layout.constraints(with: view))
        }
        return constraints
    }
    
}

public extension LayoutAttachable where Self: LayoutContainable, Self: UIViewContainable {
    
    func active() -> AnyDeactivatable {
        if let superSubLayout = self as? SuperSubLayoutable {
            if let deactivatable = superSubLayout.deactivatable  {
                deactivatable.active(self)
                return deactivatable
            } else {
                let deactivatable = AnyDeactivatable(self)
                superSubLayout.deactivatable = deactivatable
                reactive()
                return deactivatable
            }
        } else {
            let deactivatable = AnyDeactivatable(self)
            reactive()
            return deactivatable
        }
        
    }
    
    func reactive() {
        for layout in layouts {
            layout.attachLayout(self)
        }
    }
    
    func attachLayout(_ layout: LayoutAttachable) {
        layout.addSubview(view)
        for layout in layouts {
            layout.attachLayout(self)
        }
    }
    
    func deactive() {
        view.deactive()
        deactiveRoot()
    }
    
    func deactiveRoot() {
        for constraint in constraints {
            constraint.isActive = false
        }
        setConstraint([])
        for layout in layouts {
            layout.deactive()
        }
    }
    
    var hashable: AnyHashable {
        AnyHashable([typeString(of: self)] + [view] + layouts.map(\.hashable))
    }
}