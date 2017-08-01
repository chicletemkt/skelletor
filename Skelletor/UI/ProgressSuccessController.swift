//
//  ProgressSuccessController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 01/08/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

open class ProgressSuccessController: UIViewController {
    @IBInspectable public var message: String? {
        didSet {
            if messageLabel != nil, message != nil {
                messageLabel.text = message
            }
        }
    }
    @IBOutlet public weak var messageLabel: UILabel!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if message != nil {
            messageLabel.text = message
        }
    }
    
    @IBAction open func dismissAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
