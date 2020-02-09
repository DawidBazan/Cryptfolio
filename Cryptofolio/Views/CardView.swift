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

	private var visualEffectView: UIVisualEffectView!
	private let cardHeight: CGFloat = 700
	private var parentFrame: CGRect = CGRect()

	var cardExpanded = false
	private var nextState: CardState {
		return cardExpanded ? .collapsed : .expanded
	}

	private var runningAnimations: [UIViewPropertyAnimator] = []
	private var animationProgressWhenInterrupted: CGFloat = 0

	private enum CardState {
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

	private func addGestures(to view: UIView) {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))

		handleArea.addGestureRecognizer(tapGestureRecognizer)
		handleArea.addGestureRecognizer(panGestureRecognizer)
	}

	func expandCard() {
		animateTransitionIfNeeded(state: nextState, duration: 0.9)
	}

	@objc private func handleCardTap(recognzier: UITapGestureRecognizer) {
		switch recognzier.state {
		case .ended:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default:
			break
		}
	}

	@objc private func handleCardPan(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			startInteractiveTransition(state: nextState, duration: 0.9)
		case .changed:
			let translation = recognizer.translation(in: handleArea)
			var fractionComplete = translation.y / cardHeight
			fractionComplete = cardExpanded ? fractionComplete : -fractionComplete
			updateInteractiveTransition(fractionCompleted: fractionComplete)
		case .ended:
			continueInteractiveTransition()
		default:
			break
		}
	}

	private func addShadow(to view: UIView) {
		if traitCollection.userInterfaceStyle == .dark { return }
		let shadowLayer = CAShapeLayer()
		shadowLayer.path = UIBezierPath(roundedRect: view.frame, cornerRadius: 12).cgPath
		shadowLayer.fillColor = view.backgroundColor?.cgColor
		shadowLayer.shadowColor = UIColor.darkGray.cgColor
		shadowLayer.shadowPath = shadowLayer.path
		shadowLayer.shadowOffset = CGSize(width: 0, height: -5)
		shadowLayer.shadowOpacity = 0.1
		shadowLayer.shadowRadius = 5
		view.layer.insertSublayer(shadowLayer, at: 0)
	}

	private func addTopCornerRadius(to view: UIView) {
		let path = UIBezierPath(roundedRect: view.bounds,
		                        byRoundingCorners: [.topRight, .topLeft],
		                        cornerRadii: CGSize(width: 12, height: 12))
		let maskLayer = CAShapeLayer()
		maskLayer.path = path.cgPath
		view.layer.mask = maskLayer
	}

	private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
		if runningAnimations.isEmpty {
			let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
				switch state {
				case .expanded:
					self.frame.origin.y = 80
				case .collapsed:
					self.frame.origin.y = self.parentFrame.height - self.cardHeight / 1.62
				}
			}
			frameAnimator.addCompletion { _ in
				self.cardExpanded = !self.cardExpanded
				self.runningAnimations.removeAll()
			}
			frameAnimator.startAnimation()
			runningAnimations.append(frameAnimator)
		}
	}

	private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
		if runningAnimations.isEmpty {
			animateTransitionIfNeeded(state: state, duration: duration)
		}
		for animator in runningAnimations {
			animator.pauseAnimation()
			animationProgressWhenInterrupted = animator.fractionComplete
		}
	}

	private func updateInteractiveTransition(fractionCompleted: CGFloat) {
		for animator in runningAnimations {
			animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
		}
	}

	private func continueInteractiveTransition() {
		for animator in runningAnimations {
			animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		}
	}
}
