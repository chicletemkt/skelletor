//
//  EnvironmentFriendly.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 03/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

public protocol EnvironmentFriendly {
    weak var env : Environment! {get set}
}
