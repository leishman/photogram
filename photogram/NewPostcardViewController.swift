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

    @IBAction func nextButton(sender: UIButton) {
        
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        imageView.frame = CGRect(origin: CGPointZero, size: scrollView.frame.size)
//        let ih = image.size.height
        let iw = image.size.width
//        let sh = self.scrollView.bounds.height
        let sw = scrollView.bounds.width
//        let scale =
        
//        scrollView.zoomScale = sw / iw
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
}
