//
//  EnvironmentInjector.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 03/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation
import UIKit

/// Environment dependency injector
public struct EnvironmentInjector {
    weak var env : Environment!
    
    /// Initializes the injector with an environment instance.
    public init(with environment: Environment) {
        env = environment
    }
    
    /// Injects the environment into a controller hierarchy
    ///
    /// - parameters:
    ///     - controller: Controller to inject the environment into
    public func inject(into controller: UIViewController) {
        if var dest = controller as? EnvironmentFriendly {
            dest.env = env
        }
        for child in controller.childViewControllers {
            inject(into: child)
        }
    }
}
