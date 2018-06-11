//
//  AppNavController.swift
//  CardModalPresentationController
//
//  Created by Martin Normark on 28/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class AppNavController: UINavigationController, CardModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isHalfModalMaximized ? .default : .lightContent
    }
}
