//
//  DetailViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var indexpath: Int!
    var coreDataImage = [ImageCoreData]()
    let manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    override func viewDidLoad() {
        super.viewDidLoad()
        let imageRequest: NSFetchRequest<ImageCoreData> = ImageCoreData.fetchRequest()
            do {
                coreDataImage = try manageObjectContext.fetch(imageRequest)
            }catch{
                print("error with fetch request")
            }
        
        let imageForCell = UIImage(data:coreDataImage[indexpath].image! as Data)
    
        imageView.image = imageForCell
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: Any)
    {
        let shareView = UIActivityViewController(activityItems: [imageView.image], applicationActivities: nil)
        present(shareView, animated: true, completion: nil)
    }
    

}
