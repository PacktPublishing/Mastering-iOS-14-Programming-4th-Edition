//
//  DetailsViewController.swift
//  Contacts App
//
//  Created by Chris Barker on 11/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit
import Contacts

class DetailsViewController: UIViewController {

    @IBOutlet var drawer: UIView!
    var isDrawerOpen = false
    var drawerPanStart: CGFloat = 0
    var animator: UIViewPropertyAnimator?
    
    @IBOutlet weak var contactImageView: UIImageView! {
        didSet {
            contactImageView.alpha = 0
        }
    }
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var contactPhoneNumber: UILabel!
    @IBOutlet weak var contactEmailAddress: UILabel!
    @IBOutlet weak var contactAddress: UILabel!
    
    var contact: ContactModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        contactImageView.image = contact?.contactImage
        contactName.text = contact?.fullName
        contactPhoneNumber.text = contact?.primaryPhoneNumber
        contactEmailAddress.text = contact?.primaryEmailAddress
        contactAddress.text = contact?.addressLine1
        
        UIView.animate(withDuration: 0.8) {
            self.contactImageView.alpha = 1
        }
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(didPanOnDrawer(recognizer:)))
        drawer.addGestureRecognizer(panRecognizer)
        
    }
    
    @objc func didPanOnDrawer(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            setUpAnimation()
            animator?.pauseAnimation()
            drawerPanStart = animator?.fractionComplete ?? 0
        case .changed:
            if self.isDrawerOpen {
                animator?.fractionComplete = (recognizer.translation(in: drawer).y / 305) + drawerPanStart
            } else {
                animator?.fractionComplete = (recognizer.translation(in: drawer).y / -305) + drawerPanStart
            }
        default:
//            drawerPanStart = 0
//            let timing = UICubicTimingParameters(animationCurve: .easeOut)
//            animator?.continueAnimation(withTimingParameters: timing, durationFactor: 0)
//
//            let isSwipingDown = recognizer.velocity(in: drawer).y > 0
//            if isSwipingDown == !isDrawerOpen {
//                animator?.isReversed = true
//            }
            
            drawerPanStart = 0
            let currentVelocity = recognizer.velocity(in: drawer)
            let spring = UISpringTimingParameters(dampingRatio: 0.8,
            initialVelocity: CGVector(dx: 0, dy: currentVelocity.y))
            
            animator?.continueAnimation(withTimingParameters: spring, durationFactor: 0)
            let isSwipingDown = currentVelocity.y > 0
            if isSwipingDown == !isDrawerOpen {
                animator?.isReversed = true
            }

        }
        
    }

}

extension DetailsViewController {

    @IBAction func toggleDrawerTapped() {
        setUpAnimation()
        animator?.startAnimation()
    }

    // Standard easeOut
//    private func setUpAnimation() {
//
//        guard animator == nil || animator?.isRunning == false else { return }
//
//        animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) { [unowned self] in
//            if self.isDrawerOpen {
//                self.drawer.transform = CGAffineTransform.identity
//            } else {
//                self.drawer.transform = CGAffineTransform(translationX: 0, y: -305)
//            }
//        }
//
//        animator?.addCompletion { [unowned self] _ in self.animator = nil
//            self.isDrawerOpen = !(self.drawer.transform == CGAffineTransform.identity)
//        }
//    }
    
    // Spring Animation
    private func setUpAnimation() {
        
        guard animator == nil || animator?.isRunning == false else {
            return
            
        }
        
        let spring: UISpringTimingParameters
        if self.isDrawerOpen {
            spring = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: 10))
        } else {
            spring = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: -10))
        }
        
        animator = UIViewPropertyAnimator(duration: 1, timingParameters: spring)
        
        animator?.addAnimations { [unowned self] in
            if self.isDrawerOpen {
                self.drawer.transform = CGAffineTransform.identity
            } else {
                self.drawer.transform = CGAffineTransform(translationX: 0, y: -305)
            }
        }
        
        animator?.addCompletion { [unowned self] _ in self.animator = nil
            self.isDrawerOpen = !(self.drawer.transform == CGAffineTransform.identity)
        }
        
    }
    
}
