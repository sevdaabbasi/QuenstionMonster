//
//  MessageViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 5.06.2024.
//
import UIKit
import MobileCoreServices

enum MessageType {
    case text(String)
    case image(UIImage)
}

struct Message {
    let id: UUID
    let type: MessageType
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tableView: UITableView!
    var messageTextField: UITextField!
    var sendButton: UIButton!
    var photoButton: UIButton!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }
    
    func setupViews() {
        // Setup tableView
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Setup messageTextField
        messageTextField = UITextField()
        messageTextField.placeholder = "Enter message..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)
        
        // Setup sendButton
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        // Setup photoButton
        photoButton = UIButton(type: .system)
        photoButton.setTitle("Photo", for: .normal)
        photoButton.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -8),
            
            // MessageTextField constraints
            messageTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            messageTextField.rightAnchor.constraint(equalTo: photoButton.leftAnchor, constant: -8),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // SendButton constraints
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            
            // PhotoButton constraints
            photoButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8),
            photoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            photoButton.widthAnchor.constraint(equalToConstant: 60),
            photoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func sendMessage() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        let newMessage = Message(id: UUID(), type: .text(text))
        messages.append(newMessage)
        messageTextField.text = ""
        tableView.reloadData()
    }
    
    @objc func sendPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = messages[indexPath.row]
        
        switch message.type {
        case .text(let text):
            cell.textLabel?.text = text
            cell.imageView?.image = nil
        case .image(let image):
            cell.imageView?.image = image
            cell.textLabel?.text = nil
        }
        
        return cell
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            let newMessage = Message(id: UUID(), type: .image(image))
            messages.append(newMessage)
            tableView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
