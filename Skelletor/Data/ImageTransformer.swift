//
//  ImageTransformer.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 18/05/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation
import CoreData
import UIKit


@objc(ImageTransformer)
/// Image transformer, used to save/retrieve images from Core Data storages.
class ImageTransformer : ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    override class func transformedValueClass() -> AnyClass {
        return NSData.classForCoder()
    }
    override func transformedValue(_ value: Any?) -> Any? {
        if let image = value as? UIImage {
            return UIImagePNGRepresentation(image)
        }
        return nil
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let data = value as? Data {
            return UIImage(data: data)
        }
        return nil
    }
}
