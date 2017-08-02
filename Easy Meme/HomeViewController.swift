//
//  HomeViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate {
    
   weak var imageView: UIImage!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var allMemeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change corner radius of button
        createButton.layer.cornerRadius = 10
        allMemeButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func allmeme(_ sender: Any) {
        performSegue(withIdentifier: "allMeme", sender: self)
    }
    //Create Button - create alert and send segue
    @IBAction func createButton(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image Source", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //alert action
        let alertPhoto = UIAlertAction(title: "Photo", style: UIAlertActionStyle.default) { UIAlertAction in
            self.imagePhoto()
        }
        
        let alertCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { UIAlertAction in self.imageCamera()
        }
        
        let alertCancle = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.default, handler: {UIAlertAction in
        })
        
        //check to see if the camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true
        {
            alert.addAction(alertCamera)
            alert.addAction(alertPhoto)
            alert.addAction(alertCancle)
        }else {
            alert.addAction(alertPhoto)
            alert.addAction(alertCancle)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Camera function
    func imageCamera(){
        let imagePicked = UIImagePickerController()
        imagePicked.delegate = self
        imagePicked.sourceType = .camera
        present(imagePicked, animated: true, completion: nil)
    }
    
    //Photo function
    func imagePhoto(){
        let imagePicked = UIImagePickerController()
        imagePicked.delegate = self
        imagePicked.sourceType = .photoLibrary
        present(imagePicked, animated: true, completion: nil)
    }
    
    //imagepicker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
       if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView = pickImage
            dismiss(animated: true, completion: nil)
       }else{
        }
         dismiss(animated: true, completion: nil)
         performSegue(withIdentifier: "ToCreate", sender: self)
    }
    
    //Cancle image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //perpare for sending file in segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ToCreate" {
           if let nextViewController = segue.destination as? CreateViewController {
              nextViewController.Image = imageView
          }
      }
    
    }

}

