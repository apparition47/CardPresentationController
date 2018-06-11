//
//  ModalViewController.swift
//  CardModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, CardModalPresentable {
    @IBAction func cancelButtonTap(_ sender: Any) {
        if let delegate = navigationController?.transitioningDelegate as? CardModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }
}
