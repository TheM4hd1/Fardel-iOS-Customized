//
//  ImageCell.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/31/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class ImageCell: UICollectionViewCell {
    
    private lazy var imageProduct: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "photo_not_found").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        layer.cornerRadius = 8
        addSubview(imageProduct)
        if #available(iOS 11.0, *) {
            
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            imageProduct.anchorManual(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imageProduct.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: String) {
        
        let imageUrl = "\(BASE_URL)\(url)"

        // TODO: Download Image
        if !url.isEmpty {
            let imageUrl = URL(string: imageUrl)
            imageProduct.kf.setImage(with: imageUrl)
        } else {
            imageProduct.contentMode = .scaleAspectFit
        }
    }
}
