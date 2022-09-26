//
//  ViewController.swift
//  CombineDemo
//
//  Created by Theik Chan on 26/09/2022.
//

import UIKit
import Combine

extension Notification.Name {
    static let newMessage = Notification.Name("newMessage")
}

struct Message {
    let content: String
    let author: String
}

class ViewController: UIViewController {

    @IBOutlet weak var allowMessageSwitch: UISwitch!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @Published var canSendMessage: Bool = false
    
    private var switchSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProcessingChain()
    }
    
    func setupProcessingChain() {
        switchSubscriber = $canSendMessage.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: btnSendMessage)
        let messagePublisher = NotificationCenter.Publisher(center: .default, name: .newMessage)
            .map { notification -> String? in
                return (notification.object as? Message)?.content ?? ""
            }
        let messageSubscriber = Subscribers.Assign(object: messageLabel, keyPath: \.text)
        
        messagePublisher.subscribe(messageSubscriber)
    }

    @IBAction func didSwitch(_ sender: UISwitch) {
        canSendMessage = sender.isOn
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let message = Message(content: "The current time is \(Date())", author: "Me")
        NotificationCenter.default.post(name: .newMessage, object: message)
    }
    
}

