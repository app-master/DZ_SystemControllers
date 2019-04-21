//
//  ViewController.swift
//  DZ_SystemControllers
//
//  Created by user on 21/04/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - IBActions
    @IBAction func actionShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        showActivityViewController(for: [image])
    }
    
    @IBAction func actionSafariButton(_ sender: UIButton) {
        guard let url = URL(string: "https://vk.com/nevlezat") else { return }
        showSafariViewController(for: url)
    }
    
    @IBAction func actionCameraButton(_ sender: UIButton) {
        showAlertForImagePickerController()
    }
    
    @IBAction func actionEmailButton(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlertWithMessage("You can't send an Email")
            return
        }
        showMailComposeViewController()
    }
    
    @IBAction func actionMessageButton(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else {
            showAlertWithMessage("You can't send the Message")
            return
        }
        showMessageComposeViewController()
    }
    
    // MARK: - Methods
    private func showActivityViewController(for items: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    private func showSafariViewController(for url: URL) {
      let safariViewController = SFSafariViewController(url: url)
      safariViewController.dismissButtonStyle = .close
      present(safariViewController, animated: true)
    }
    
    private func showAlertForImagePickerController() {
        let alert = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            }
            alert.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            }
            alert.addAction(photoLibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert,animated: true)
    }
    
    private func showMailComposeViewController() {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject("Hi")
        mailComposer.setToRecipients(["appmaster@me.com"])
        mailComposer.setMessageBody("How are you?", isHTML: false)
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.2) {
            mailComposer.addAttachmentData(imageData, mimeType: "video/JPEG", fileName: "image.jpeg")
        }
        
        present(mailComposer, animated: true)
    }
    
    private func showMessageComposeViewController() {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.recipients = ["appmaster@me.com"]
        messageComposer.body = "How are you?"
        
        if MFMessageComposeViewController.canSendSubject() {
            messageComposer.subject = "Hi"
        }
        
        if MFMessageComposeViewController.canSendAttachments() {
            if let imageData = imageView.image?.jpegData(compressionQuality: 0.2) {
                messageComposer.addAttachmentData(imageData, typeIdentifier: "video/JPEG", filename: "image.jpeg")
            }
        }
        
        present(messageComposer, animated: true)
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let dataImage = info[.originalImage]
        let image = dataImage as? UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MFMessageComposeViewControllerDelegate
extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
