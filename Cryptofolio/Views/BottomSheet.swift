//
//  BottomSheet.swift
//  Cryptofolio
//
//  Created by Dawid on 11/04/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    let contentView = PortfolioSheetView()
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 400
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: partialView, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        contentView.tableView.register(PortfolioCell.self, forCellReuseIdentifier: "cell")
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        let y = view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.contentView.tableView.isScrollEnabled = true
                }
            })
        }
    }
}

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PortfolioCell
        cell.setupCell(with: "Test", price: "", amount: "", value: "")
        return cell
    }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
    
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && contentView.tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            contentView.tableView.isScrollEnabled = false
        } else {
            contentView.tableView.isScrollEnabled = true
        }
        
        return false
    }
}
