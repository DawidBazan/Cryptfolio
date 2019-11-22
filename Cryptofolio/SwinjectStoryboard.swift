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
        defaultContainer.register(CryptoViewModel.self) { r in
            let viewModel = CryptoViewModel(reachability: r.resolve(ReachabilityChecker.self)!,
                                                    cryptoFetcher: r.resolve(CryptoFetcher.self)!)
            return viewModel
        }
    }

    // MARK: Storyboards
    class func registerStoryboards() {
        Container.loggingFunction = nil

        defaultContainer.storyboardInitCompleted(CryptoVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(CryptoViewModel.self)
        }
    }
}
