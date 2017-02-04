//
//  BundleVersion.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 04/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

public struct BundleVersion {
    let bundle: Bundle
    public let version: String!
    public var versionComponents: [String] {
        return version.components(separatedBy: ".")
    }
    
    public init(with bundle: Bundle = Bundle.main) {
        self.bundle = bundle
        if let dict = bundle.infoDictionary {
            version = "\(dict["CFBundleShortVersionString"]!).\(dict["CFBundleVersion"]!)"
        } else {
            version = nil
        }
    }
}
