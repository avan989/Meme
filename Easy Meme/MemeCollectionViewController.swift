//
//  MemeCollectionViewController.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/16/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var indexPath: Int! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        let Index = collectionView?.indexPathsForVisibleItems
        for indexPaths in Index!{
            let cell = collectionView?.cellForItem(at: indexPaths) as! MemeCollectionViewCell
             cell.isEditing = editing
             // cell.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let object = UIApplication.shared.delegate
        let meme = object as! AppDelegate
        let a = meme.meme.count
        return a
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemeCollectionViewCell
        cell.indexPath = indexPath.row
        cell.delegate = self
        return cell
    }
  
    
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath.row
        performSegue(withIdentifier: "detailView", sender: self)
    }

   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let nextViewController = segue.destination as? DetailViewController {
                nextViewController.indexpath = self.indexPath}
        }
    }
}

extension MemeCollectionViewController: MemeCustomCellDelegate{
    func delete (cell: MemeCollectionViewCell){
        let item = collectionView?.indexPath(for: cell)
        print("cell \(String(describing: item?.item))")
            let object = UIApplication.shared.delegate
            let meme = object as! AppDelegate
            meme.meme.remove(at: (item?.item)!)
            collectionView?.deleteItems(at: [item!])
    }
}
