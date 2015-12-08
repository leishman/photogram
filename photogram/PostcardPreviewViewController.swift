//
//  PostcardPreviewViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 12/5/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

class PostcardPreviewViewController: UIViewController {
    var frontView: UIImageView?
    var backView: PostcardBackUIView?
    var showingBack = false

    @IBOutlet weak var postcardView: UIView!
    
    var postcard: Postcard? {
        didSet {
            if let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString? {
                let fileManager = NSFileManager.defaultManager()
                let url = paths.stringByAppendingPathComponent(postcard!.photo_url!)
                if(fileManager.fileExistsAtPath(url)) {
                    self.frontView!.contentMode = .ScaleAspectFit
                    self.frontView!.image = UIImage(contentsOfFile: url)
                    self.backView!.postcard = postcard
                    setupTapGesture()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        frontView = UIImageView(frame: CGRect(x: 0, y: 0, width: postcardView.frame.width, height: postcardView.bounds.height))
        backView = PostcardBackUIView(frame: CGRect(x: 0, y: 0, width: postcardView.bounds.width, height: postcardView.bounds.height))
        postcard = Postcard.last(inManagedContext: AppDelegate.managedObjectContext!)
    }
    
    func setupTapGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tappedCallback"))
        singleTap.numberOfTapsRequired = 1
        postcardView.addGestureRecognizer(singleTap)
        postcardView.userInteractionEnabled = true
        postcardView.addSubview(frontView!)
    }
    
    // Inspired By: http://www.codingricky.com/flipping-cards-with-swift-and-uikit/
    func tappedCallback() {
        if (showingBack) {
            UIView.transitionFromView(backView!, toView: frontView!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            
            showingBack = false
        } else {
            UIView.transitionFromView(frontView!, toView: backView!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            showingBack = true
        }
        
    }
}
