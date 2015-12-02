//
//  NewPostcardViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 11/29/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit
import MobileCoreServices

class NewPostcardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    @IBAction func nextView(sender: UIButton) {
        savePostcard()
    }
    
    private func getNewImage() -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, false, scrollView.zoomScale)
//        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        return newImage
        
        let scale = 1 / scrollView.zoomScale
        print(scrollView.zoomScale)
        print(scrollView.contentOffset)
        print(scale)
        let visibleRect = CGRectMake(scrollView.contentOffset.x * scale, scrollView.contentOffset.y * scale, scrollView.bounds.size.width * scale, scrollView.bounds.size.height * scale)
        
        let ref: CGImageRef = CGImageCreateWithImageInRect(image!.CGImage, visibleRect)!
        return UIImage(CGImage: ref)
        
    }

    private func savePostcard() {
        let newImage = getNewImage()
        if image != nil {
            if let imageData = UIImageJPEGRepresentation(newImage, 1.0),
                let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                    let unique = "\(NSDate.timeIntervalSinceReferenceDate()).jpg"
                    let url = documentsDirectory.URLByAppendingPathComponent(unique)
                    if imageData.writeToURL(url, atomically: true) {
                        writePostcardToDb(unique)
                    }
            }
        }
    }
    
    private func writePostcardToDb(url: String) {
        
        func cb(p: Postcard) {
            performSegueWithIdentifier("postcardTextViewSegue", sender: self)
        }
        
        if let context = AppDelegate.managedObjectContext {
            context.performBlock {
                self.postcard = Postcard.createWithImageUrl(url, inManagedContext: context, callback: cb)
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }

        set {
            nextButton.hidden = false
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    private var postcard: Postcard?
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func selectPhoto() {
//        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = false
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
//        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // add image to scroll view for cropping and editing
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        
        // ensure image is scaled to fit in the initial scroll window
        imageView.frame = CGRect(origin: CGPointZero, size: scrollView.frame.size)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.hidden = true
        scrollView.addSubview(imageView)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let destination = segue.destinationViewController as? PostcardTextViewController {
            
//            destination.postcard = Postcard.last(inManagedContext: AppDelegate.managedObjectContext!)
        }
    }
}
