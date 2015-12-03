//
//  PostcardTextViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 11/30/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import AudioToolbox

class PostcardTextViewController: UIViewController, UITextFieldDelegate {
    var postcard: Postcard?  {
        didSet {
            if let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString? {
                
                let fileManager = NSFileManager.defaultManager()
                let url = paths.stringByAppendingPathComponent(postcard!.photo_url!)
                if(fileManager.fileExistsAtPath(url)) {
                    self.image.image = UIImage(contentsOfFile: url)
                }
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func nextView(sender: UIButton) {
        updatePostcard()
    }
    
    private func getNewImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, false, 1)
        containerView.drawViewHierarchyInRect(containerView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updatePostcard() {
        
        let image = getNewImage()
        if let imageData = UIImageJPEGRepresentation(image, 1.0),
            let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                let unique = "\(NSDate.timeIntervalSinceReferenceDate()).jpg"
                let url = documentsDirectory.URLByAppendingPathComponent(unique)
                if imageData.writeToURL(url, atomically: true) {
                    updatePostcardInDb(unique)
                }
        }
    }
    
    private func updatePostcardInDb(str: String) {
        func cb() {
            performSegueWithIdentifier("postcardMessageViewSegue", sender: self)
        }
        let con = AppDelegate.managedObjectContext!
        
        postcard!.updateUrl(str, inManagedContext: con, callback: cb)

    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func makeTextBoxActive(sender: AnyObject) {
        textField.becomeFirstResponder()
    }

    @IBAction func outsideTap(sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        postcard = Postcard.last(inManagedContext: AppDelegate.managedObjectContext!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PostcardMessageViewController {
            destination.postcard_created_at = postcard?.created_at
        }
    }
}