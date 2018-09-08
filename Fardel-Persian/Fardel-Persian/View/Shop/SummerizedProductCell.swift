//
//  SummerizedProductCell.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/26/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit

protocol SummerizedProductCellDelegate {
    func didBtnMorePressed(id: Int)
}

class SummerizedProductCell: UICollectionViewCell {
    
    var delegate: SummerizedProductCellDelegate?
    
    private lazy var imageProduct: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "photo_not_found").withRenderingMode(.alwaysOriginal))
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_more_horiz_black_24pt_"), for: .normal)
        btn.addTarget(self, action: #selector(btnMorePressed), for: .touchUpInside)
        return btn
    }()
    
    var summerizedProduct: SummerizedProduct? {
        didSet {
            self.setImage(url: (summerizedProduct?.image)!)
            self.priceLabel.text = "\(summerizedProduct?.price ?? 0) ریال"
            self.titleLabel.text = summerizedProduct?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageProduct)
        addSubview(priceLabel)
        addSubview(titleLabel)
        addSubview(moreButton)
        
        if #available(iOS 11.0, *) {
            
            imageProduct.anchorManual(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 150)
            priceLabel.anchorManual(top: imageProduct.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            titleLabel.anchorManual(top: priceLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
            moreButton.anchorManual(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 24, height: 24)
        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 5
        dropShadow()
    }
    
    fileprivate func setImage(url: String) {

        // TODO: Download Image
        if !url.isEmpty {
            let imageUrl = URL(string: "\(BASE_URL)\(url)")
            imageProduct.kf.setImage(with: imageUrl)
        } else {
            imageProduct.contentMode = .scaleAspectFit
        }
    }
    
    @objc fileprivate func btnMorePressed() {
        delegate?.didBtnMorePressed(id: (summerizedProduct?.id)!)
    }
}
