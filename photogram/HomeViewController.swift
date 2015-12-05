//
//  ViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 11/28/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var postcardListContainer: UIView!
    private let reuseIdentifier = "PostcardCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0) // TODO, update
    @IBOutlet weak var postcardCollectionView: UICollectionView!
    
    var postcards = [Postcard]()
    
    func fetchPostcards() {
        func cb(pcards: [Postcard]) -> Void {
            postcards = pcards
            postcardCollectionView.reloadData()
        }
        
        postcards = Postcard.all(inManagedContext: AppDelegate.managedObjectContext!, callback: cb)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPostcards()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func photoForIndexPath(indexPath: NSIndexPath) {
        // TODO
        
    }
    
    // MARK: UICollectionViewDelegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postcards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // TODO
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PostcardViewCell
        let photo = photoForIndexPath(indexPath)
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
}
