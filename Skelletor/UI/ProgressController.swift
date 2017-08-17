//
//  ProgressController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 31/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit
import CoreData

/// Callback return type
public typealias ProgressCallbackReturn = (result: Bool, message: String?)

/// Callback used by the progress controller
public typealias ProgressCallback = ()->ProgressCallbackReturn

/// Implements a general-purpose progress controller that executes something and let the user wait
/// for the result.
open class ProgressController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet open weak var activityView: UIActivityIndicatorView!
    @IBOutlet open weak var messageLabel: UILabel!
    @IBOutlet open weak var buttonPanel: UIStackView!
    @IBOutlet open weak var okButton: UIButton!
    @IBOutlet open weak var retryButton: UIButton!
    @IBOutlet open weak var cancelButton: UIButton!
    
    /// Message to display to the user
    public var message: String? {
        didSet {
            if messageLabel != nil {
                messageLabel.text = message
            }
        }
    }
    
    // MARK: - View Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        if message != nil {
            messageLabel.text = message
        }
        buttonPanel?.isHidden = true
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        activityView.startAnimating()
        execute()
    }

    open func execute() {
        fatalError("You must override this method")
    }

    // MARK: - UI Related Methods
    open func hideButtonPanel(_ hidden: Bool, animated: Bool) {
        if animated {
            if buttonPanel.isHidden && hidden {
                // nothing to do. It is already hidden
                return
            }
            let newAlpha = buttonPanel.isHidden ? 1.0 : 0.0
            buttonPanel.alpha = buttonPanel.isHidden ? 0.0 : 1.0
            buttonPanel.isHidden = !buttonPanel.isHidden
            UIView.animate(withDuration: 1.5, animations: { [weak self] in
                self!.buttonPanel.alpha = CGFloat(newAlpha)
                }, completion: { [weak self](finished) in
                    if finished {
                        self!.buttonPanel.isHidden = hidden
                    }
            })
            return
        }
        buttonPanel.isHidden = hidden
    }
    
    open func successButtonSet() {
        retryButton?.isHidden = true
        cancelButton?.isHidden = true
        okButton?.isHidden = false
    }
    
    open func failureButtonSet(_ showRetry: Bool = false) {
        okButton?.isHidden = true
        retryButton?.isHidden = !showRetry
        cancelButton?.isHidden = false
    }
    
    @IBAction open func okButtonAction(_ sender: UIButton) {
        hideButtonPanel(true, animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction open func retryAction(_ sender: UIButton) {
        hideButtonPanel(true, animated: false)
        execute()
    }
    
    @IBAction open func cancelAction(_ sender: UIButton) {
        hideButtonPanel(true, animated: false)
        navigationController?.popViewController(animated: true)
    }
}
