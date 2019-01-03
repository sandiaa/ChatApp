//
//  ChatEngine.swift
//  ChatSuggestion
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol ChatEngineDelegate:class {
    func showSuggestions(suggestions:[Chat])
    func didAddNewChat()
}

enum ChatType {
    case bot
    case user
}

class ChatEngine {
    
    weak var delegate:ChatEngineDelegate?
    var chatHistory = [Chat]()
    
    func startOnboarding() {
        let firstMessage = Chat(index: getNextIndex(), chatMessage: "Hi", image: nil, chatType: .bot)
        chatHistory.append(firstMessage)
        
        delegate?.showSuggestions(suggestions: getResponsesForHi())
    }
    
    func getNextIndex()->Int {
        if let lastChat = chatHistory.last {
            return lastChat.index+1
        }
        else {
            return 0
        }
    }
    
    func getResponsesForHi()->[Chat] {
        let hiMsg = Chat(index: getNextIndex(), chatMessage: "Hi", image: nil, chatType: .user)
        let whoMsg = Chat(index: getNextIndex(), chatMessage: "Who are you?", image: nil, chatType: .user)
        let howMsg = Chat(index: getNextIndex(), chatMessage: "How are you?", image: nil, chatType: .user)
        
        return [hiMsg, whoMsg, howMsg]
    }
    
    func newSuggestionSelected(suggestion:Chat) {
        chatHistory.append(suggestion)
        
        
        
        
        delegate?.didAddNewChat()
    }
}


struct Chat {
    let index:Int
    let chatMessage:String?
    let image:UIImage?
    let chatType:ChatType
}
