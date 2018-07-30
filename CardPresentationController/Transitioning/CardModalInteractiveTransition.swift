//
//  CardModalInteractiveTransition.swift
//  CardModalPresentationController
//
//  Created by Martin Normark on 28/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class CardModalInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController
    var presentingViewController: UIViewController?
    
    var shouldComplete: Bool = false
    
    init(viewController: UIViewController, withView view: UIView, presentingViewController: UIViewController?) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        
        super.init()
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        finish()
    }
    
    override var completionSpeed: CGFloat {
        get {
            return 1.0 - self.percentComplete
        }
        set {}
    }
}
