//
//  ChannelCell.swift
//  AstroChannels
//
//  Created by Candice H on 9/15/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import UIKit
protocol ChannelCellDelegate {
    func onFavoriteAction(_ index: Int, isFavorite: Bool)
}
class ChannelCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    var isFavorite: Bool?
    var delegate:ChannelCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomRightButton.setImage(#imageLiteral(resourceName: "FavoritesSelectedIcon").scaledToSize(CGSize(width: 30, height: 30)), for: .normal)
        bottomRightButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func onBottomRightAction(_ sender: UIButton) {
        if (self.isFavorite ?? false)! {
            bottomRightButton.tintColor = UIColor.electricViolet
            setFavorite(!self.isFavorite!)
            delegate.onFavoriteAction(sender.tag, isFavorite: self.isFavorite!)
        } else {
            bottomRightButton.tintColor = UIColor.lightGray
            setFavorite(!self.isFavorite!)
            delegate.onFavoriteAction(sender.tag, isFavorite: self.isFavorite!)
        }
    }
    
    func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
        
        if isFavorite {
            bottomRightButton.tintColor = UIColor.electricViolet
        } else {
            bottomRightButton.tintColor = UIColor.lightGray
        }
    }
}
extension UIImage {
    
    func scaledToSize(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
