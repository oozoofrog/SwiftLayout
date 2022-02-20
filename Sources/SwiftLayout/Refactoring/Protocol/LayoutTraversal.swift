import Foundation
import UIKit

typealias TraverseHandler = (_ superview: UIView?, _ subview: UIView, _ identifier: String?, _ animationDisabled: Bool) -> Void

protocol LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler)
}

extension Array where Element == LayoutTraversal {
    mutating func appendLayout<L: Layout>(_ l: L) {
        guard let traversal = l as? LayoutTraversal else { return }
        append(traversal)
    }
}

extension LayoutTraversal {
    var viewInformations: [ViewInformation] {
        var informations: [ViewInformation] = []
        traverse(nil) { superview, subview, identifier, animationDisabled in
            informations.append(.init(superview: superview, view: subview, identifier: identifier, animationDisabled: animationDisabled))
        }
        return informations
    }
    var viewConstraints: [NSLayoutConstraint] { [] }
    func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] { [] }
    
    func cast<L: Layout>(_ layout: L, _ handler: (LayoutTraversal) -> Void) -> Void {
        guard let traversal = layout as? LayoutTraversal else { return }
        handler(traversal)
    }
}

extension AnchorsLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        cast(layout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
    }
}

extension AnyLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        box.traverse(superview, traverseHandler: handler)
    }
}

extension ArrayLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        for layout in layouts {
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        }
    }
}

extension ConditionalLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        switch layout {
        case let .trueLayout(layout):
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        case let .falseLayout(layout):
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        }
    }
}

extension OptionalLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        layout.flatMap { layout in
            cast(layout) { traversal in
                traversal.traverse(superview, traverseHandler: handler)
            }
        }
    }
}

extension SublayoutLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        cast(superlayout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
        cast(sublayout) { traversal in
            traversal.traverse(superview, traverseHandler: handler)
        }
    }
}

extension TupleLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        
    }
}

extension ViewLayout: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        handler(superview, view, identifier, animationDisabled)
        cast(sublayout) { traversal in
            traversal.traverse(view, traverseHandler: handler)
        }
    }
}

extension UIView: LayoutTraversal {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        handler(superview, self, nil, false)
    }
}
