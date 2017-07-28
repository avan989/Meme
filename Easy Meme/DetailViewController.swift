//
//  DetailViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var indexpath: Int! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let object = UIApplication.shared.delegate
        let meme = object as! AppDelegate
        imageView.image = meme.meme[indexpath].memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: Any)
    {
        let object = UIApplication.shared.delegate
        let meme = object as! AppDelegate
        let shareView = UIActivityViewController(activityItems: [meme.meme[indexpath].memedImage], applicationActivities: nil)
        present(shareView, animated: true, completion: nil)
    }
    

}
