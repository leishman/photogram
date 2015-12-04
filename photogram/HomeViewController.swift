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
    
    var postcards = [Postcard]()
    
    func fetchPostcards() {
        postcards = Postcard.all(inManagedContext: AppDelegate.managedObjectContext!)
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
    }
}
