//
//  LeftCell.swift
//  ChatAppCollectionView
//
//  Created by Admin on 02/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class LeftCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 5.0
    }

    func populateWith(chat:Chat) {
        
        if let message = chat.chatMessage {
            textLabel.text = message
        }
        layoutIfNeeded()
    }
}
