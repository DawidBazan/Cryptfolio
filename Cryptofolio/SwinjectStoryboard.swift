//
//  SwinjectStoryboard.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        registerServices()
        registerViewModels()
        registerStoryboards()
    }

    // MARK: Services
    class func registerServices() {
        defaultContainer.register(ReachabilityService.self) { _ in Reachability() }
        defaultContainer.register(ReachabilityChecker.self) { r in
            ReachabilityChecker(reachability: r.resolve(ReachabilityService.self)!)
        }
        defaultContainer.register(NetworkService.self) { _ in Network() }
        defaultContainer.register(CryptoFetcher.self) { r in
            CryptoFetcher(network: r.resolve(NetworkService.self)!)
        }
    }

    // MARK: ViewModels
    class func registerViewModels() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            defaultContainer.register(IntroViewModel.self) { r in
                let viewModel = IntroViewModel(reachability: r.resolve(ReachabilityChecker.self)!,
                                               cryptoFetcher: r.resolve(CryptoFetcher.self)!)
                return viewModel
            }
        }
        
        defaultContainer.register(PortfolioViewModel.self) { r in
            let viewModel = PortfolioViewModel(reachability: r.resolve(ReachabilityChecker.self)!,
                                               cryptoFetcher: r.resolve(CryptoFetcher.self)!)
            return viewModel
        }
    }

    // MARK: Storyboards
    class func registerStoryboards() {
        Container.loggingFunction = nil
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            defaultContainer.storyboardInitCompleted(IntroVC.self) { resolver, controller in
                controller.viewModel = resolver.resolve(IntroViewModel.self)
            }
        }

        defaultContainer.storyboardInitCompleted(PortfolioVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(PortfolioViewModel.self)
        }
    }
}
