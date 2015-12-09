//
//  stripImageInfo.swift
//  photogram
//
//  Created by Alexander Leishman on 12/7/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

// extension to prevent incorrect image rotations from displaying
extension UIImage {
    
    // inspired by: http://stackoverflow.com/a/29753437/2302781
    public func stripImageRotation() -> UIImage {
        let newFrame = UIView(frame: CGRect(origin: CGPointZero, size: self.size))

        // calculate the size of the new view's containing box for our drawing space
        let newSize = newFrame.frame.size
        
        // Create the image context
        UIGraphicsBeginImageContext(newSize)
        
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move origin back to middle of image.
        CGContextTranslateCTM(bitmap, newSize.width / 2.0, newSize.height / 2.0);
        
        // prevent mirroring
        CGContextScaleCTM(bitmap, 1.0, -1.0)
        
        // draw new image
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        // capture new image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
        
        return newImage

    }
}

