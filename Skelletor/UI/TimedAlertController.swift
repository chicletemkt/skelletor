//
//  TimedAlertController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 26/10/2017.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

/// This class implements an alert controller which dismissal depends on a time out. It has exactly the same
/// visuals of a system alert controller, but adds the possibility to have it dismissed after a given time out.
///
/// - important: If you want to subclass this controller make sure to call `super.viewDidAppear` and
/// `super.viewWillDisappear` if you want to override it. They control the internal timer. Overriding such methods
/// without calling `super` will override the functionality completely.
open class TimedAlertController: UIAlertController {
    fileprivate var timer: Timer?
    
    /// Timeout given in ms. Defaults to 125ms
    public var timeOut: TimeInterval = 0.125
    
    /// Tells if automatic dismissal is animated or not. Defaults to true.
    public var animatedDismissal: Bool = true

    open override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: timeOut, repeats: false, block: { [unowned self](timer) in
            timer.invalidate()
            self.dismiss(animated: self.animatedDismissal, completion: nil)
        })
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
}
