//
//  DismissKeyboardController.swift
//  photogram
//
//  Created by Alexander Leishman on 12/5/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

class DismissKeyboardController: UIViewController {
    
    // create toolbar to act as accessory view for UIPickerView
    // it will contain "Done" and "Cancel" buttons for resigning first-responder status
    // Used http://stackoverflow.com/a/31728914/2302781 as a guideline
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = true
        toolbar.sizeToFit()
        
        // add done and cancel buttons to toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneKeyboard")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelKeyboard")
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        return toolbar
    }
}