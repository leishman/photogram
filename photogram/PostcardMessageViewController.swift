//
//  PostcardMessageViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 12/2/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

class PostcardMessageViewController: UIViewController {
    var postcard_created_at: NSDate?

    @IBOutlet weak var image: UIImageView!
    
    var postcard: Postcard? {
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
    
    override func viewDidLoad() {
        postcard = Postcard.last(inManagedContext: AppDelegate.managedObjectContext!)
    }
}