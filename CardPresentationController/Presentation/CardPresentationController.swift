//
//  CardPresentationController.swift
//  CardPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

enum CardModalScaleState {
    case adjustedOnce
    case normal
}

class CardPresentationController: UIPresentationController {
    var isMaximized: Bool = false
    var panGestureRecognizer: UIPanGestureRecognizer
    var direction: CGFloat = 0
    var state: CardModalScaleState = .normal
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.panGestureRecognizer = UIPanGestureRecognizer()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        presentedViewController.view.layer.cornerRadius = 12
        presentedViewController.view.layer.masksToBounds = true
        
        let panIndicatorBar = UIButton()
        panIndicatorBar.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        panIndicatorBar.layer.cornerRadius = 3
        presentedViewController.view.addSubview(panIndicatorBar)
        panIndicatorBar.translatesAutoresizingMaskIntoConstraints = false
        panIndicatorBar.widthAnchor.constraint(equalToConstant: 37).isActive = true
        panIndicatorBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        panIndicatorBar.centerXAnchor.constraint(equalTo: presentedViewController.view.centerXAnchor).isActive = true
        panIndicatorBar.topAnchor.constraint(
            equalTo: presentedViewController.view.topAnchor,
            constant: 5
            ).isActive = true
    }
    
    @objc func close() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) {
        let endPoint = pan.translation(in: pan.view?.superview)
        switch pan.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            switch state {
            case .normal:
                presentedView!.frame.origin.y = endPoint.y + containerView!.frame.height * 0.06
            case .adjustedOnce:
                if #available(iOS 11.0, *) {
                    if endPoint.y <= (UIApplication.shared.keyWindow?.safeAreaInsets.top)! {
                        presentedView!.frame.origin.y = (UIApplication.shared.keyWindow?.safeAreaInsets.top)!
                    } else {
                        presentedView!.frame.origin.y = endPoint.y
                    }
                } else {
                    presentedView!.frame.origin.y = endPoint.y
                }
            }
            direction = velocity.y
            
            // animate bg
            let scaleFactor = 0.9 + 1/(UIScreen.main.bounds.height/endPoint.y) * 0.1
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        case .ended:
            if direction < 0 {
                changeScale(to: .adjustedOnce)
            } else {
                if state == .adjustedOnce {
                    changeScale(to: .normal)
                } else {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
        default: break
        }
    }
    
    func changeScale(to state: CardModalScaleState) {
        self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(
                withDuration: 0.8, delay: 0,
                usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    let containerFrame = containerView.frame
                    let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height * 0.06),
                                           size: CGSize(
                                            width: containerFrame.width,
                                            height: containerFrame.height * 0.94))
                    presentedView.frame = halfFrame
            }, completion: { [unowned self] _ in
                self.state = state
            })
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height * 0.06,
                      width: containerView!.bounds.width, height: containerView!.bounds.height * 0.94
        )
    }
    
    override func presentationTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            self.presentingViewController.view.layer.masksToBounds = true
            coordinator.animate(alongsideTransition: { [unowned self] _ in
                self.presentingViewController.view.alpha = 0.9
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.presentingViewController.view.layer.cornerRadius = 12
                }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            
            self.presentingViewController.view.layer.masksToBounds = false
            coordinator.animate(alongsideTransition: { [unowned self] _ in
                self.presentingViewController.view.alpha = 1
                self.presentingViewController.view.transform = CGAffineTransform.identity
                self.presentingViewController.view.layer.cornerRadius = 0
                }, completion: { _ in
            })
            
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            isMaximized = false
        }
    }
}

protocol CardModalPresentable { }

extension CardModalPresentable where Self: UINavigationController {
    var isHalfModalMaximized: Bool {
        if let presentationController = presentationController as? CardPresentationController {
            return presentationController.isMaximized
        }
        
        return false
    }
}
