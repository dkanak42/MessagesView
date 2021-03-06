//
//  ViewController.swift
//  Demo
//
//  Created by Damian Kanak on 03/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import UIKit
import MessagesView

class ViewController: UIViewController {

    @IBOutlet weak var messagesView: MessagesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesView.delegate = self
        messagesView.dataSource = self

        //addCustomMessageBubbles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesView.scrollToLastMessage(animated: false)
    }
    
    func addCustomMessageBubbles() {
        
        let leftBubble = BubbleImage(image: UIImage(named: "bubble_left")!,
                                     resizeInsets: UIEdgeInsets(top: 4, left: 21, bottom: 14, right: 4),
                                     textInsets: UIEdgeInsets(top: 10, left: 22, bottom: 10, right: 6))
        
        messagesView.setBubbleImagesWith(left: leftBubble)
    }
}

extension ViewController: MessagesViewDelegate {
    func didTapLeftButton() {

    }
    
    func didTapRightButton() {
        
        let text = messagesView.inputText.trimmingCharacters(in: .whitespaces)
        
        guard !text.isEmpty else {
            return
        }
        
        TestData.exampleMessageText.append(text)
        messagesView.refresh(scrollToLastMessage: true, animateLastMessage: true)
    }
}

extension ViewController: MessagesViewDataSource {
    struct Peer: MessagesViewPeer {
        var id: String
    }
    
    struct Message: MessagesViewChatMessage {
        var text: String
        var sender: MessagesViewPeer
        var onRight: Bool
    }

    var peers: [MessagesViewPeer] {
        return TestData.peerNames.map{ Peer(id: $0) }
    }
    
    var messages: [MessagesViewChatMessage] {
        return TestData.exampleMessageText.enumerated().map { (index, element) in
            let peer = self.peers[index % peers.count]
            return Message(text: element, sender: peer, onRight: index != 0)
        }
    }
}

