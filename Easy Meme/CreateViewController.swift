//
//  CreateViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var bottomLabel: UITextView!
    @IBOutlet weak var TopLabel: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var createImage: UIImageView!
    var Image: UIImage!
    var a=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        createImage.image = Image
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        subscribetoKeyboardHide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardWillHide()
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Avenir-Book", size: 30)!,
        NSStrokeWidthAttributeName: 10,]
    
    ///Keyboard
    //subscribe keyboard
    func subscribetoKeyboardHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }

    //unsubscribe
    func unsubscribeFromKeyboardWillHide(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            TopLabel.text = textField.text
        }else{
        bottomLabel.text = textField.text
        }
        return true
    }
    
    //hide keyboard
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            unsubscribeFromKeyboardWillHide()
            unsubscribeFromKeyboardNotifications()
            self.a = 1
        }else{
            if self.a == 1 {
            subscribeToKeyboardNotifications()
            subscribetoKeyboardHide()
            self.a += 1
                }
            }
        
    }

    func keyboardWillHide(_ notification:Notification){
        self.view.frame.origin.y = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //navigation bar
    @IBAction func saveButton(_ sender: Any) {
        let memedImage = generateMemedImage()
        // Create the meme
        let meme = Meme(Text1: TopLabel.text!, Text2: bottomLabel.text!, orginalImage: createImage.image!, memedImage: memedImage)
        //call share appdelegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.meme.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.navigationBar.isHidden = true
        self.topText.isHidden = true
        self.bottomText.isHidden = true
        self.shareButton.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.navigationController?.navigationBar.isHidden = false
        shareButton.isHidden = false
        shareButton.isEnabled = true
        self.topText.isHidden = false
        self.bottomText.isHidden = false
        return memedImage
    }
    
    @IBAction func share(_ sender: Any){
        let meme = generateMemedImage() as UIImage!
        let shareView = UIActivityViewController(activityItems: [meme!], applicationActivities: nil)
        present(shareView, animated: true, completion: nil)
    }
}
