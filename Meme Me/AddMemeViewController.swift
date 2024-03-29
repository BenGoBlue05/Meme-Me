//
//  ViewController.swift
//  Meme Me
//
//  Created by Ben Lewis on 10/2/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit

class AddMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITextFieldDelegate {

    
    @IBOutlet weak var topToolbar: UIToolbar!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTf: UITextField!
    
    @IBOutlet weak var bottomTf: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private var isTopTextDefault = true

    private var isBottomTextDefault = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated:false)
        tabBarController?.tabBar.isHidden = true
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  Float(-2),
        ]
        configureTextfield(bottomTf, memeTextAttributes)
        configureTextfield(topTf, memeTextAttributes)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imageView.image != nil
    }
    
    func configureTextfield(_ textfield: UITextField, _ attrs: [NSAttributedString.Key: Any]) {
        textfield.defaultTextAttributes = attrs
        textfield.textAlignment = NSTextAlignment.center
        textfield.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated:false)
        tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        getImage(.photoLibrary)
    }
    
    @IBAction func getImageFromCamera(_ sender: Any) {
        getImage(.camera)
    }
    
    func getImage(_ sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let iv = imageView {
                iv.image = image
                shareButton.isEnabled = true
            }
        }
        dismiss(animated: true)
    }
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTf.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
       
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
       
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if topTf.tag  == textField.tag{
            if isTopTextDefault {
                isTopTextDefault = false
                textField.text = ""
            }
        } else if bottomTf.tag == textField.tag {
            if isBottomTextDefault {
                isBottomTextDefault = false
                textField.text = ""
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let image = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
                if success {
                    self.save(image)
                }
        }
    }
    
    func save(_ memeImage: UIImage) {
        let meme = Meme(topText: topTf.text ?? "", bottomText: bottomTf.text ?? "", originalImage: imageView.image!, memeImage: memeImage)
        MmSession.sharedInstance.memes.append(meme)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resetMeme(_ sender: Any) {
        imageView.image = nil
        topTf.text = "TOP"
        bottomTf.text = "BOTTOM"
        isTopTextDefault = true
        isBottomTextDefault = true
        shareButton.isEnabled = false
        navigationController?.popViewController(animated: true)
    }
}

