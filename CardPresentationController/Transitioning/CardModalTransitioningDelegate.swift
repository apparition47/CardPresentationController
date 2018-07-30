//
//  CardModalTransitioningDelegate.swift
//  CardModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class CardModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var viewController: UIViewController
    var presentingViewController: UIViewController
    var interactionController: CardModalInteractiveTransition
    
    var interactiveDismiss = true
    
    init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        self.interactionController = CardModalInteractiveTransition(
            viewController: self.viewController,
            withView: self.presentingViewController.view,
            presentingViewController: self.presentingViewController
        )
        
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardModalTransitionAnimator(type: .dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?, source: UIViewController
        ) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
        return interactiveDismiss ? interactionController : nil
    }
}

extension UIViewController { }
