//
//  ShopController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/21/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import MaterialComponents
import SHSearchBar
import Kingfisher
class ShopController: UIViewController {
    
    private lazy var alertView: UIView = {
        let alert = UIView()
        alert.alpha = 0
        alert.backgroundColor = #colorLiteral(red: 1, green: 0.2064451283, blue: 0.2974684767, alpha: 1)
        alert.isHidden = true
        return alert
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.text = "عدم ارتباط با سرور"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [.red, UIColor.fromRgb(red: 68, green: 110, blue: 212)]
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var refreshButton: UIButton = { // Placed on center of screen
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        btn.isEnabled = false
        btn.alpha = 0
        btn.setImage(#imageLiteral(resourceName: "baseline_refresh_black_24pt_"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    let searchGlassIconTemplate = UIImage(named: "icon-search")!.withRenderingMode(.alwaysTemplate)
    
    private lazy var searchBar: SHSearchBar = {
        let rasterSize: CGFloat = 11.0
        let leftViewNoCancelButton = imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize)
        let searchBar = defaultSearchBar(withRasterSize: rasterSize, leftView: leftViewNoCancelButton, rightView: nil, delegate: self, useCancelButton: false)
        searchBar.delegate = self
        searchBar.textField.font = UIFont.systemFont(ofSize: 14)
        searchBar.textField.autocorrectionType = .no
        searchBar.textField.autocapitalizationType = .none
        return searchBar
    }()
    
    private var categories: [Category] = []
    private lazy var segmentedCategories: ScrollableSegmentedControl = {
        let segment = ScrollableSegmentedControl()
        segment.segmentStyle = .textOnly
        segment.underlineSelected = true
        segment.addTarget(self, action: #selector(segmentIndexChanged(_:)), for: .valueChanged)
        segment.selectedSegmentContentColor = UIColor.fromRgb(red: 68, green: 110, blue: 212)
        return segment
    }()
    
    private var summerizedProducts: [SummerizedProduct] = []
    private var filteredProducts: [SummerizedProduct] = []
    private let cellId = "summerizedCell"
    private var gridMode = true
    private lazy var productsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(SummerizedProductCell.self, forCellWithReuseIdentifier: cellId)
        collection.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collection.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        collection.delegate = self
        collection.dataSource = self
        collection.isHidden = true
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        //==========================================================//
        // TODO: Customize View and Navigation
        
        view.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        productsCollection.addGestureRecognizer(tap)
        navigationItem.title = "فروشگاه"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        //==========================================================//
        // TODO: Add Subviews
        
        view.addSubview(alertView)
        alertView.addSubview(alertLabel)
        view.addSubview(activityIndicator)
        view.addSubview(refreshButton)
        view.addSubview(searchBar)
        view.addSubview(segmentedCategories)
        view.addSubview(productsCollection)
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            alertView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
            alertLabel.anchorManual(top: alertView.topAnchor, left: alertView.leftAnchor, bottom: alertView.bottomAnchor, right: alertView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
            
            NSLayoutConstraint.activate([refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                         refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         refreshButton.widthAnchor.constraint(equalToConstant: 30),
                                         refreshButton.heightAnchor.constraint(equalToConstant: 30)])
            
            searchBar.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
            segmentedCategories.anchorManual(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
            productsCollection.anchorManual(top: segmentedCategories.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            
        } else {
            
        }
        
        updateCategories()
    }
    
    fileprivate func updateCategories() {
        
        // TODO: Update Categories From Server
        
        activityIndicator.startAnimating()
        APIService.request.receiveCategories { (success, message, categories) in
            if success {
                self.categories = categories
                self.categories.insert(Category(id: -1, subCategories: [], name: "همه"), at: 0) // Default Value
                self.reloadSegments()
            } else {
                self.showAlert(message: message)
            }
        }
    }
    
    fileprivate func updateProducts(category: String) {
        
        // TODO: Update Products From Server
        
        let categoryName = (category == "همه" ? "" : category)
        productsCollection.isHidden = true
        activityIndicator.startAnimating()
        APIService.request.receiveProducts(category: categoryName) { (success, message, summerizedProducts) in
            if success {
                self.activityIndicator.stopAnimating()
                self.summerizedProducts = summerizedProducts
                self.productsCollection.isHidden = false
                self.productsCollection.reloadData()
            } else {
                self.showAlert(message: message)
            }
        }
    }
    
    @objc fileprivate func refreshButtonPressed() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.alpha = 0
            self.refreshButton.alpha = 0
        }) { (didFinish) in
            if didFinish {
                self.refreshButton.isHidden = true
                self.refreshButton.isEnabled = false
                //self.self.itemsCollection.isHidden = false
                self.updateCategories()
            }
        }
    }
    
    fileprivate func reloadSegments() {
        
        // TODO: Reload Categories
        
        for category in categories {
            segmentedCategories.insertSegment(withTitle: category.name, at: segmentedCategories.numberOfSegments)
        }
        
        segmentedCategories.selectedSegmentIndex = 0
        segmentedCategories.autoresizesSubviews = true
    }
    
    fileprivate func showAlert(message: String) {
        activityIndicator.stopAnimating()
        searchBar.isHidden = true
        alertView.isHidden = false
        refreshButton.isHidden = false
        refreshButton.isEnabled = true
        alertLabel.text = message
        productsCollection.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 1
            self.refreshButton.alpha = 1
        })
    }
    
    @objc fileprivate func segmentIndexChanged(_ sender: ScrollableSegmentedControl) {
        
        // TODO: Handle Segment Value
        let categoryName = sender.titleForSegment(at: sender.selectedSegmentIndex)
        updateProducts(category: categoryName!)
        
    }
    
    // MARK: - Helper Functions
    
    func defaultSearchBar(withRasterSize rasterSize: CGFloat, leftView: UIView?, rightView: UIView?, delegate: SHSearchBarDelegate, useCancelButton: Bool = true) -> SHSearchBar {
        var config = defaultSearchBarConfig(rasterSize)
        config.leftView = leftView
        config.rightView = rightView
        config.useCancelButton = useCancelButton
        
        if leftView != nil {
            config.leftViewMode = .always
        }
        
        if rightView != nil {
            config.rightViewMode = .unlessEditing
        }
        
        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.placeholder = "Search ..."
        bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 3)
        bar.layer.shadowRadius = 5
        bar.layer.shadowOpacity = 0.25
        return bar
    }
    
    func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
        config.cancelButtonTextAttributes = [.foregroundColor : UIColor.darkGray]
        config.textAttributes = [.foregroundColor : UIColor.gray]
        return config
    }
    
    func imageViewWithIcon(_ icon: UIImage, rasterSize: CGFloat) -> UIImageView {
        let imgView = UIImageView(image: icon)
        imgView.frame = CGRect(x: 0, y: 0, width: icon.size.width + rasterSize * 2.0, height: icon.size.height)
        imgView.contentMode = .center
        imgView.tintColor = UIColor.fromRgb(red: 68, green: 110, blue: 212)//UIColor(red: 0.75, green: 0, blue: 0, alpha: 1)
        return imgView
    }
    
    @objc fileprivate func endEditing() {
        view.endEditing(true)
    }
}

 // Mark: - collectionView delegate and datasource

extension ShopController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HeaderCellDelegate, SummerizedProductCellDelegate {
    
    func didBtnMorePressed(id: Int) {
        let controller = ProductController()
        controller.productId = id
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didGridModeChanged(state: Bool) {
        gridMode = state
        productsCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! HeaderCell
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 16, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchBar.isActive && (searchBar.text?.count)! > 0 {
            return filteredProducts.count
        }
        
        return summerizedProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: SummerizedProductCell?
        if searchBar.isActive && (searchBar.text?.count)! > 0 {
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SummerizedProductCell)
            cell?.summerizedProduct = filteredProducts[indexPath.item]
        } else {
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SummerizedProductCell)
            cell?.summerizedProduct = summerizedProducts[indexPath.item]
        }

        cell?.delegate = self
        cell?.setupViews()
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Size for Cell
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        let sampleCell = CategoryCell(frame: frame)
//        sampleCell.name = categories[indexPath.item].name
//        sampleCell.layoutIfNeeded()
//
//        let targetSize = CGSize(width: view.frame.width, height: 1000)
//        let estimatedSize = sampleCell.systemLayoutSizeFitting(targetSize)
//
//        if #available(iOS 11.0, *) {
//            let width = estimatedSize.width
//            return CGSize(width: width + 20, height: 30)
//        } else {
//            let height = estimatedSize.height + view.frame.width/2 + 48
//            return CGSize(width: view.frame.width - 20, height: height)
//        }
        if gridMode {
            return CGSize(width: view.frame.width/2 - 20, height: 250)
        }
        
        return CGSize(width: view.frame.width - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            
        })
    }
}

// Mark: - searchBar delegate

extension ShopController: SHSearchBarDelegate {
    
    func searchBar(_ searchBar: SHSearchBar, textDidChange text: String) {
        guard let filteredString = searchBar.text else { return }
        if searchBar.isActive && filteredString.count > 0 {
            filteredProducts.removeAll()
            for product in summerizedProducts {
                if product.name.contains(filteredString) {
                    filteredProducts.append(product)
                }
            }
            
            productsCollection.reloadData()
        } else {
            productsCollection.reloadData()
        }
    }
}
