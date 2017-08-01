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
open class ProgressController: UIViewController, EnvironmentFriendly {
    // MARK: - Properties
    @IBOutlet open weak var activityView: UIActivityIndicatorView!
    @IBOutlet open weak var messageLabel: UILabel!
    
    open var webServiceId: String {
        return "WebService"
    }
    open var contextId: String {
        return "ContextId"
    }
    
    public var webService: WebService {
        return env[webServiceId] as! WebService
    }
    public var context: NSManagedObjectContext {
        return (env[contextId] as! NSPersistentContainer).viewContext
    }
    
    public weak var env: Environment!
    
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
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        activityView.startAnimating()
        execute()
    }

    open func execute() {
        fatalError("You must override this method")
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EnvironmentFriendly {
            EnvironmentInjector(with: env).inject(into: segue.destination)
        }
    }
}
