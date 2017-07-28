//
//  MemeCollectionViewCell.swift
//  Easy Meme
//
//  Created by Anh Duc Van on 7/23/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit

protocol MemeCustomCellDelegate: class {
    func delete (cell: MemeCollectionViewCell)
}


class MemeCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MemeCustomCellDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var deleteButtonBackground: UIVisualEffectView!
    
    var indexPath: Int! {
        didSet{
            deleteButtonBackground.isHidden = !isEditing
            let object = UIApplication.shared.delegate
            let meme = object as! AppDelegate
            image.image = meme.meme[indexPath].memedImage
        }
    }
    var isEditing: Bool = false {
        didSet{
            deleteButtonBackground.isHidden = !isEditing
        }
    }

    @IBAction func deleteButton(_ sender: UIButton) {
        delegate?.delete(cell: self)
    }

}
