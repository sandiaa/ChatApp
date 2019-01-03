//
//  SuggestionCell.swift
//  ChatSuggestion
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMessage.layer.cornerRadius = 4.0
    }
    
    func populateWith(suggestion:Chat) {
        if let message = suggestion.chatMessage {
            lblMessage.text = message
        }
    }

}
