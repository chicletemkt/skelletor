//
//  ProgressSuccessController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 01/08/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

open class ProgressSuccessController: ProgressMessageController {   
    @IBAction open func dismissAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
