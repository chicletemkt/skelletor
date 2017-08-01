//
//  ProgressErrorController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 01/08/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

open class ProgressErrorController: UIViewController {
    @IBInspectable public var message: String? {
        didSet {
            if messageLabel != nil {
                messageLabel.text = message
            }
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction open func retryAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction open func cancelAction(_ sender: Any) {
        if let nav = navigationController {
            let index = nav.viewControllers.endIndex - 3
            if index > 0 {
                let controller = nav.viewControllers[nav.viewControllers.endIndex - 3]
                nav.popToViewController(controller, animated: true)
            } else {
                nav.popToRootViewController(animated: true)
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if message != nil {
            messageLabel.text = message
        }
    }
}
