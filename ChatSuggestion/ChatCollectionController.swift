//
//  ChatCollectionController.swift
//  ChatAppCollectionView
//
//  Created by Admin on 02/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ChatCollectionController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var lcChatBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    
    let chatEngine = ChatEngine()
    var userSuggestions = [Chat]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatEngine.delegate = self
        
        perform(#selector(loadChat), with: nil, afterDelay: 2.0)
    }
    
    @objc func loadChat() {
        chatEngine.startOnboarding()
        setupChatCollectionView()
    }
    
    func setupChatCollectionView() {
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        
        chatCollectionView.register(UINib(nibName: "RightCell", bundle: nil), forCellWithReuseIdentifier: "RightCell")
        
        chatCollectionView.register(UINib(nibName: "LeftCell", bundle: nil), forCellWithReuseIdentifier: "LeftCell")
        
        let springLayout = SpringyFlowLayout()//UICollectionViewFlowLayout()//
        springLayout.scrollDirection = .vertical
        springLayout.minimumLineSpacing = 10
        springLayout.minimumInteritemSpacing = 10
        springLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        chatCollectionView.setCollectionViewLayout(springLayout, animated: false)
        springLayout.invalidateLayout()
        
    }
    
    func setupSuggestionsCollectionView() {
        
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        
        suggestionsCollectionView.register(UINib(nibName: "SuggestionCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.zero
        suggestionsCollectionView.setCollectionViewLayout(layout, animated: false)
        layout.invalidateLayout()
        
        suggestionsCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == chatCollectionView {
            return chatEngine.chatHistory.count
        }
        else {
            return userSuggestions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == chatCollectionView {
            let chat = chatEngine.chatHistory[indexPath.row]
            if chat.chatType == .user {
                let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: "RightCell", for: indexPath) as! RightCell
                cell.populateWith(chat: chat)
                return cell
            }
            else {
                let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: "LeftCell", for: indexPath) as! LeftCell
                cell.populateWith(chat: chat)
                return cell
            }
        }
        else {
            let cell = suggestionsCollectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
            cell.populateWith(suggestion: userSuggestions[indexPath.row])
           return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == chatCollectionView {
            let chat = chatEngine.chatHistory[indexPath.row]
            let str = chat.chatMessage
            
            let lbl = UILabel()
            lbl.text = str
            lbl.numberOfLines = 0
            lbl.font = UIFont.systemFont(ofSize: 17)
            
            let size = lbl.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 90, height: CGFloat.infinity))
            return CGSize(width: UIScreen.main.bounds.width, height: max(size.height + 10, 50))
        }
        else {
            let message = userSuggestions[indexPath.row]
            
            let lbl = UILabel()
            lbl.text = message.chatMessage
            lbl.numberOfLines = 1
            lbl.font = UIFont.boldSystemFont(ofSize: 14)
            
            let size = lbl.sizeThatFits(CGSize(width: CGFloat.infinity, height: 40))
            
            return CGSize(width: max(size.width + 40, 80), height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggestionsCollectionView {
            DispatchQueue.main.async {
                let selectedSuggestion = self.userSuggestions[indexPath.row]
                self.chatEngine.newSuggestionSelected(suggestion: selectedSuggestion)
                
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.lcChatBottomSpace.constant = 0
                    self.view.layoutIfNeeded()
                }) { (finished) in
                }
            }
        }
    }
}

extension ChatCollectionController: ChatEngineDelegate {
    func showSuggestions(suggestions: [Chat]) {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.lcChatBottomSpace.constant = 100
            self.view.layoutIfNeeded()
        }) { (finished) in
            DispatchQueue.main.async {
                self.setupSuggestionsCollectionView()
                self.userSuggestions = suggestions
                self.suggestionsCollectionView.reloadData()
            }
        }
    }
    
    func didAddNewChat() {
        let newIndexPath = IndexPath(row: chatEngine.chatHistory.count-1, section: 0)
        (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
        chatCollectionView.performBatchUpdates({
            self.chatCollectionView.insertItems(at: [newIndexPath])
        }) { (finished) in
            self.chatCollectionView.scrollToItem(at: newIndexPath, at: .bottom, animated: true)
        }
    }
}

