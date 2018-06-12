//
//  CardModalTransitionAnimator.swift
//  CardModalPresentationController
//
//  Created by Martin Normark on 29/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class CardModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var type: CardModalTransitionAnimatorType
    
    init(type: CardModalTransitionAnimatorType) {
        self.type = type
    }
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            from!.view.frame.origin.y = 800
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
}

internal enum CardModalTransitionAnimatorType {
    case present
    case dismiss
}
