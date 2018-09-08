//
//  HeaderCell.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/27/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit

protocol HeaderCellDelegate {
    func didGridModeChanged(state: Bool)
}

class HeaderCell: UICollectionViewCell {
    
    private var _tintColor: UIColor?
    var delegate: HeaderCellDelegate?
    
    private lazy var gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_apps_black_24pt_"), for: .normal)
        btn.addTarget(self, action: #selector(gridButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var arrayButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_view_array_black_24pt_"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(arrayButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.addArrangedSubview(gridButton)
        stackview.addArrangedSubview(arrayButton)
        return stackview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        _tintColor = gridButton.tintColor
        addSubview(stackView)
        if #available(iOS 11.0, *) {
            
            stackView.anchorManual(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func gridButtonPressed() {
        gridButton.tintColor = _tintColor
        arrayButton.tintColor = .darkGray
        delegate?.didGridModeChanged(state: true)
    }
    
    @objc fileprivate func arrayButtonPressed() {
        gridButton.tintColor = .darkGray
        arrayButton.tintColor = _tintColor
        delegate?.didGridModeChanged(state: false)
    }
}
