//
//  TransitionViewController.swift
//  Contacts App
//
//  Created by Chris Barker on 17/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension TransitionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

