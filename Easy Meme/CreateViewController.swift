//
//  CreateViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit
import CoreData

class CreateViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var bottomLabel: UITextView!
    @IBOutlet weak var TopLabel: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var createImage: UIImageView!
    var Image: UIImage!
    var a=0
    
    var manageObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        createImage.image = Image
        
        //set delegate to itself to modify
        topText.delegate = self
        bottomText.delegate = self
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        //subscribe to keyboard to know if the keyboard is being used
        subscribeToKeyboardNotifications()
        subscribetoKeyboardHide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //unsubscribe to get rid of keyboard
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
        
        //know which textfield is being call by the tag number
        if textField.tag == 1 {
            TopLabel.text = textField.text
        }else{
            bottomLabel.text = textField.text
        }
        return true
    }
    
    //hide keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        //if top is being call do not move keyboard frame up. Reset "a" value to keep track
        if textField.tag == 1 {
            unsubscribeFromKeyboardWillHide()
            unsubscribeFromKeyboardNotifications()
            self.a = 1
        }else{
            //if the value "a" has been call once do not move it up again.
            if self.a == 1 {
            subscribeToKeyboardNotifications()
            subscribetoKeyboardHide()
            self.a += 1
                }
            }
        
    }
    
    //move keyboard fame back down to zero
    func keyboardWillHide(_ notification:Notification){
        self.view.frame.origin.y = 0
    }
    
    //when return key is press, get rid of keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //navigation bar
    @IBAction func saveButton(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        //save to coreData
        let imageSaveCoreData = ImageCoreData(context: manageObjectContext)
        let imageNSData: NSData = UIImagePNGRepresentation(memedImage)! as NSData
        imageSaveCoreData.image = imageNSData
        
        do {
            try self.manageObjectContext.save()
        }catch{
            print("error not saving")
        }
        
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
    
    //pull up the share button( allow user to asses the email, text .. etc)
    @IBAction func share(_ sender: Any){
        let meme = generateMemedImage() as UIImage!
        let shareView = UIActivityViewController(activityItems: [meme!], applicationActivities: nil)
        present(shareView, animated: true, completion: nil)
    }
}
