//
//  PostcardMessageViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 12/2/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class PostcardMessageViewController: DismissKeyboardController, KeyboardToolbarDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    var postcard_created_at: NSDate?
    private var showErrorMessage = false

    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var addressOutlet: UILabel!
    
    var postcard: Postcard? {
        didSet {
            if let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString? {
                
                let fileManager = NSFileManager.defaultManager()
                let url = paths.stringByAppendingPathComponent(postcard!.photo_url!)
                if(fileManager.fileExistsAtPath(url)) {
//                    self.image.image = UIImage(contentsOfFile: url)
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Show no address error message if flag set
        // Then unset flag
        if showErrorMessage {
            AppDelegate.getAppDelegate().showMessage("No address available for contact")
            showErrorMessage = false
        }
    }
    
    override func viewDidLoad() {
        messageField.layer.cornerRadius = 5
        messageField.layer.borderColor = UIColor.blackColor().CGColor
        messageField.layer.borderWidth = 1
        messageField.inputAccessoryView = createToolbar()
        self.automaticallyAdjustsScrollViewInsets = false
        postcard = Postcard.last(inManagedContext: AppDelegate.managedObjectContext!)
        requestAccess()
    }
    

    @IBAction func previewAction(sender: UIButton) {
        func cb() {
            performSegueWithIdentifier("previewPostcard", sender: sender)
        }
        let context = AppDelegate.managedObjectContext
        postcard!.updateMessage(messageField.text, inManagedObjectContext: context!, callback: cb)
    }
    
    
    // adapted from http://www.appcoda.com/ios-contacts-framework/
    private func showContacts(sender: AnyObject) {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func addAddress(sender: UIButton) {
        showContacts(sender)
    }
    
    private func saveAddressForPostcard(address: CNPostalAddress) {
        postcard!.createOrUpdateAddress(address, inManagedContext: AppDelegate.managedObjectContext!)
    }
    
    private func displayAddress(addr: CNPostalAddress) {
        let formatter = CNPostalAddressFormatter()
        let str = formatter.stringFromPostalAddress(addr)
        addressOutlet.text = str
    }
    
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        if(contact.postalAddresses.isEmpty) {
            showErrorMessage = true
            return
        } else {
            let addr = contact.postalAddresses.first?.value as! CNPostalAddress
            saveAddressForPostcard(addr)
            displayAddress(addr)
        }
    }
    
    func doneKeyboard() {
        messageField.resignFirstResponder()
    }
        
    func cancelKeyboard() {
        messageField.resignFirstResponder()
    }
    
    func requestAccess() -> Bool {
        
        AppDelegate.getAppDelegate().requestContactAccess { (accessGranted) -> Void in
            if(accessGranted) {
                var contacts = [CNContact]()
                let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPostalAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: toFetch)
                let contactsStore = AppDelegate.getAppDelegate().contactStore
                do {
                    try contactsStore.enumerateContactsWithFetchRequest(request) { contact, stop in
                        if(!contact.postalAddresses.isEmpty){
                            contacts.append(contact)
                        }
                    }
                } catch {
                    
                }
            }
            
        }
        return true
    }
    
    
}