//
//  Optional+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

extension Optional: Layout where Wrapped: Layout {
    public func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        self?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    
    public func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        self?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
}

