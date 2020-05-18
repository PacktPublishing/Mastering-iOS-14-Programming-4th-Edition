//
//  ViewController.swift
//  Chapter 5 - Dynamics
//
//  Created by Chris Barker on 16/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ball1: UIView! {
        didSet {
            
            // Make a ball
            ball1.layer.cornerRadius = ball1.frame.size.width/2
            ball1.clipsToBounds = true
            
            // Cool gradient effect!
            let gradient = CAGradientLayer()
            gradient.frame = ball1.bounds
            gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]

            ball1.layer.insertSublayer(gradient, at: 0)
        
        }
    }
    
    @IBOutlet weak var ball2: UIView! {
        didSet {
            
            // Make a ball
            ball2.layer.cornerRadius = ball2.frame.size.width/2
            ball2.clipsToBounds = true
            
            // Cool gradient effect!
            let gradient = CAGradientLayer()
            gradient.frame = ball2.bounds
            gradient.colors = [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor]

            ball2.layer.insertSublayer(gradient, at: 0)
        
        }
    }
    @IBOutlet weak var ball3: UIView! {
        didSet {
            
            // Make a ball
            ball3.layer.cornerRadius = ball3.frame.size.width/2
            ball3.clipsToBounds = true
            
            // Cool gradient effect!
            let gradient = CAGradientLayer()
            gradient.frame = ball3.bounds
            gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor]

            ball3.layer.insertSublayer(gradient, at: 0)
        
        }
    }
    
    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let balls: [UIDynamicItem] = [ball1, ball2, ball3]
        animator = UIDynamicAnimator(referenceView: view)
        
        let gravity = UIGravityBehavior(items: balls)
        animator?.addBehavior(gravity)
        
        var nextAnchorX = 250
        
        for ball in balls {
            let anchorPoint = CGPoint(x: nextAnchorX, y: 0)
            nextAnchorX -= 30
            let attachment = UIAttachmentBehavior(item: ball, attachedToAnchor: anchorPoint)
            attachment.damping = 0.7
            animator?.addBehavior(attachment)
            
            let dynamicBehavior = UIDynamicItemBehavior()
            dynamicBehavior.addItem(ball)
            dynamicBehavior.density = CGFloat(arc4random_uniform(3) + 1)
            dynamicBehavior.elasticity = 0.8
            animator?.addBehavior(dynamicBehavior)

        }
        
        let collisions = UICollisionBehavior(items: balls)
        animator?.addBehavior(collisions)
        
    }
    
}

