//
//  ViewController.swift
//  AppChat
//
//  Created by Phincon on 20/06/22.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct Contact: ContactItem {
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
}

class ChatsViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "ios acdemy")
    let otherUser = Sender(senderId: "other", displayName: "Jhon Smith")
    
    var messages = [MessageType]()
    
    var chatMessage: MessageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchApi()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func fetchApi(){
        if let path = Bundle.main.path(forResource: "message_dataset", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let dictionary = jsonResult as? [String: AnyObject] {
                    let model = MessageModel(dictionary)
                    
                    for i in model.data {
                        if i.attachment == "image" {
                            messages.append(Message(sender: Sender(senderId: i.from ?? "", displayName: i.from ?? ""), messageId: "\(i.id ?? 0)", sentDate: Date(timeIntervalSince1970: Double(i.timestamp ?? "0") ?? 0.0), kind: .photo(Media(url: nil, image: UIImage(named: "image_gallery"), placeholderImage: UIImage(named: "image_gallery")!, size: CGSize(width: 512, height: 250)))))
                        } else if i.attachment == "contact" {
                            messages.append(Message(sender: Sender(senderId: i.from ?? "", displayName: i.from ?? ""), messageId: "\(i.id ?? 0)", sentDate: Date(timeIntervalSince1970: Double(i.timestamp ?? "0") ?? 0.0), kind: .contact(Contact(displayName: "user \(i.id ?? 0)", initials: "U \(i.id ?? 0)", phoneNumbers:["081318458375", "081318458374", "081318458373", "081318458372", "081318458371"], emails: []))))
                        } else if i.attachment == "document" {
                            messages.append(Message(sender: Sender(senderId: i.from ?? "", displayName: i.from ?? ""), messageId: "\(i.id ?? 0)", sentDate: Date(timeIntervalSince1970: Double(i.timestamp ?? "0") ?? 0.0), kind: .contact(Contact(displayName: "user \(i.id ?? 0)", initials: "U \(i.id ?? 0)", phoneNumbers:["081318458375", "081318458374", "081318458373", "081318458372", "081318458371"], emails: []))))
                        } else {
                            messages.append(Message(sender: Sender(senderId: i.from ?? "", displayName: i.from ?? ""), messageId: "\(i.id ?? 0)", sentDate: Date(timeIntervalSince1970: Double(i.timestamp ?? "0") ?? 0.0), kind: .text(i.body ?? "")))
                        }
                        
                    }
                    
                    self.messagesCollectionView.reloadData()
                }
            } catch {
                // handle error
            }
        }
    }

    func currentSender() -> SenderType {
        return messages[0].sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

}

