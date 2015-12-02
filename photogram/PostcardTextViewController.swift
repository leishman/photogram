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

class PostcardTextViewController: UIViewController {
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

    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        postcard = Postcard.last(inManagedContext: AppDelegate.managedObjectContext!)
    }
}