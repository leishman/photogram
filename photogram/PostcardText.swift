//
//  PostcardText.swift
//  photogram
//
//  Created by Alexander Leishman on 12/2/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

class PostcardText: UITextField, UITextFieldDelegate {
    
    var lastLocation = CGPointZero
    
    func detectPan(recognizer: UIPanGestureRecognizer) {
        print("pan detected")
        let translation = recognizer.translationInView(self.superview)
        self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
        self.resignFirstResponder()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
        self.gestureRecognizers = [panRecognizer]
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastLocation = self.center
    }

}