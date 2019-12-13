//
//  CardViewController.swift
//  Cryptofolio
//
//  Created by BZN8 on 13/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet var handleArea: UIView!
    @IBOutlet var dragBar: UIView!
    
    var visualEffectView: UIVisualEffectView!
    let cardHeight: CGFloat = 650
    var parentFrame: CGRect = CGRect()
       
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnimations: [UIViewPropertyAnimator] = []
    var animationProgressWhenInterrupted: CGFloat = 0
       
    enum CardState {
        case expanded
        case collapsed
    }
    
    func setupCard(in vc: PortfolioVC) {
        visualEffectView = UIVisualEffectView()
        parentFrame = vc.view.frame
        visualEffectView.frame = parentFrame
        handleArea.addSubview(visualEffectView)
        dragBar.layer.cornerRadius = dragBar.frame.height / 2
        
        addShadow(to: handleArea)
        addTopCornerRadius(to: handleArea)
        addGestures(to: handleArea)
    }
    
    func addGestures(to view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        handleArea.addGestureRecognizer(tapGestureRecognizer)
        handleArea.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handleCardTap(recognzier: UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func addShadow(to view: UIView) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: view.frame, cornerRadius: 12).cgPath
        shadowLayer.fillColor = handleArea.backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: -5)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 5
        view.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addTopCornerRadius(to view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topRight, .topLeft],
                                cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    func animateTransitionIfNeeded (state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.frame.origin.y = 75
                case .collapsed:
                    self.frame.origin.y = self.parentFrame.height - self.cardHeight / 2
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
