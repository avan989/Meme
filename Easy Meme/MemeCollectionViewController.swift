//
//  MemeCollectionViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit
import CoreData

class MemeCollectionViewController: UICollectionViewController {
    
    var indexPath: Int!
    var manageContextObject: NSManagedObjectContext!
    var coreDataImage = [ImageCoreData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageContextObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        let Index = collectionView?.indexPathsForVisibleItems
        for indexPaths in Index!{
            let cell = collectionView?.cellForItem(at: indexPaths) as! MemeCollectionViewCell
            cell.isEditing = editing
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //return the number of cell to be created
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageRequest: NSFetchRequest<ImageCoreData> = ImageCoreData.fetchRequest()
        do {
            coreDataImage = try manageContextObject.fetch(imageRequest)
        }catch{}
 
        return coreDataImage.count
    }
    
    //return the custom cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fetch request to get all file in coreData
        let imageRequest: NSFetchRequest<ImageCoreData> = ImageCoreData.fetchRequest()
        do {
        coreDataImage = try manageContextObject.fetch(imageRequest)
        }catch{
            print("error with fetch request")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemeCollectionViewCell
        
        let imageForCell = UIImage(data:coreDataImage[indexPath.row].image! as Data)
        cell.image.image = imageForCell
        cell.deleteButtonBackground.isHidden = true
        
        //tell the custom cell to delegate itself
        cell.delegate = self
        return cell
    }
  
    
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //record the indexpath
        self.indexPath = indexPath.row
        performSegue(withIdentifier: "detailView", sender: self)
    }

   //prepare to send information
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let nextViewController = segue.destination as? DetailViewController {
                nextViewController.indexpath = self.indexPath}
        }
    }
}

//do the code in the custom cell through delegateion
extension MemeCollectionViewController: MemeCustomCellDelegate{
    
//function in the protocle for cell delegation
    func delete (cell: MemeCollectionViewCell){
        //"item" is the index point for the cell being used in the collection view
        let item = collectionView?.indexPath(for: cell)
        print("cell \(String(describing: item?.item))")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let imageDelete = coreDataImage[(item?.row)!]
        context.delete(imageDelete)
        
        do {
            try self.manageContextObject.save()
            self.collectionView?.reloadData()
        }catch{
            print("delete fail")
        }
        
    }
    
}
