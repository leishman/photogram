//
//  PostcardBackUIView.swift
//  photogram
//
//  Created by Alexander Leishman on 12/6/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit

class PostcardBackUIView: UIView {
    var address: Address?
    var message: String?
    var postcard: Postcard? {
        didSet {
            self.address = postcard!.address
            self.message = postcard!.message
            updateView()
        }
    }
    
    func updateView() {
        addMessage()
        if(address != nil) {
            addAddress()
        }
    }
    
    func addMessage() {
        let cardWidth = self.bounds.width
        let cardHeight = self.bounds.height
        let messageRect = CGRect(x: 10, y: 10, width: cardWidth / 2.2, height: cardHeight - 20)
        let messageField = UILabel(frame: messageRect)
        messageField.text = self.message
        self.addSubview(messageField)
        
    }
    
    func addAddress() {
        let cardWidth = self.bounds.width
        let cardHeight = self.bounds.height
        let addrRect = CGRect(x: cardWidth / 2 + 10, y: cardHeight / 2, width: cardWidth / 2.2, height: cardHeight / 2)
        let addrString = "\(address!.street)\n\(address!.city), \(address!.state) \(address!.postal_code)\n\(address!.country)"
        let addrField = UILabel(frame: addrRect)
        addrField.text = addrString
        self.addSubview(addrField)

    }
    
    
}
