//
//  ProductController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/31/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class ProductController: UIViewController {
    
    var productId: Int?
    
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView(frame: view.bounds)
        scrollview.autoresizingMask = .flexibleHeight
        scrollview.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 5)
        scrollview.isUserInteractionEnabled = true
        return scrollview
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
        btn.alpha = 0
        btn.setImage(#imageLiteral(resourceName: "baseline_refresh_black_24pt_"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var viewImages: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.dropShadow()
        return view
    }()
    
    private var images: [String] = []
    private let cellId = "imageCellId"
    private lazy var imageCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.layer.cornerRadius = 8
        collection.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        collection.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private lazy var pageControllerForImageCollection: UIPageControl = {
        let controller = UIPageControl()
        controller.currentPageIndicatorTintColor = .orange
        controller.layer.cornerRadius = 8
        controller.backgroundColor = .darkGray//#colorLiteral(red: 0.06158493332, green: 0.4964506365, blue: 1, alpha: 1)
        return controller
    }()
    
    private lazy var viewInformation: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.dropShadow()
        return view
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var productStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var viewDetails: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.dropShadow()
        return view
    }()
    
    private lazy var viewTextNumericTextField: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private lazy var itemsCountTextField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = UIFont.systemFont(ofSize: 14)
        field.textColor = .darkGray
        field.textAlignment = .center
        field.text = "0"
        return field
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_add_black_24pt_"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var removeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_remove_black_24pt_"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackviewAttributes: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 5
        return stackview
    }()
    
    var tempView: UIView?
    
    private lazy var addToBasketButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("به سبد خرید اضافه کن", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.06158493332, green: 0.4964506365, blue: 1, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        //==========================================================//
        // TODO: Customize View and Navigation
        
        view.backgroundColor =  UIColor.fromRgb(red: 247, green: 247, blue: 247)
        title = "مشخصات محصول"
        
        //==========================================================//
        // TODO: Add SubViews
        
        view.addSubview(scrollView)
        scrollView.addSubview(alertView)
        alertView.addSubview(alertLabel)
        scrollView.addSubview(refreshButton)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(viewImages)
        viewImages.addSubview(imageCollection)
        viewImages.addSubview(pageControllerForImageCollection)
        scrollView.addSubview(viewInformation)
        viewInformation.addSubview(productNameLabel)
        viewInformation.addSubview(productPriceLabel)
        viewInformation.addSubview(productStatusLabel)
        scrollView.addSubview(viewDetails)
        viewDetails.addSubview(stackviewAttributes)

        viewDetails.addSubview(viewTextNumericTextField)
        viewTextNumericTextField.addSubview(addButton)
        viewTextNumericTextField.addSubview(removeButton)
        viewTextNumericTextField.addSubview(itemsCountTextField)
        viewDetails.addSubview(addToBasketButton)
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            scrollView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            alertView.anchorManual(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
            alertLabel.anchorManual(top: alertView.topAnchor, left: alertView.leftAnchor, bottom: alertView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                                         activityIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])
            
            NSLayoutConstraint.activate([refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                         refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         refreshButton.widthAnchor.constraint(equalToConstant: 30),
                                         refreshButton.heightAnchor.constraint(equalToConstant: 30)])
            
            viewImages.anchorManual(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            viewImages.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
            pageControllerForImageCollection.anchorManual(top: nil, left: viewImages.leftAnchor, bottom: viewImages.bottomAnchor, right: viewImages.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
            pageControllerForImageCollection.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            imageCollection.anchorManual(top: viewImages.topAnchor, left: viewImages.leftAnchor, bottom: pageControllerForImageCollection.topAnchor, right: viewImages.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imageCollection.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            viewInformation.anchorManual(top: viewImages.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 100)
            viewInformation.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            productNameLabel.anchorManual(top: viewInformation.topAnchor, left: viewInformation.leftAnchor, bottom: nil, right: viewInformation.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            productPriceLabel.anchorManual(top: productNameLabel.bottomAnchor, left: viewInformation.leftAnchor, bottom: nil, right: viewInformation.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            productStatusLabel.anchorManual(top: productPriceLabel.bottomAnchor, left: viewInformation.leftAnchor, bottom: nil, right: viewInformation.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
            
            viewDetails.anchorManual(top: viewInformation.bottomAnchor, left: scrollView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
            viewDetails.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            stackviewAttributes.anchorManual(top: viewDetails.topAnchor, left: viewDetails.leftAnchor, bottom: nil, right: viewDetails.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
           // stackviewVariantAttributes.anchorManual(top: stackviewAttributes.bottomAnchor, left: viewDetails.leftAnchor, bottom: nil, right: viewDetails.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
//            viewTextNumericTextField.anchorManual(top: viewDetails.topAnchor, left: nil, bottom: nil, right: viewDetails.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 90, height: 30)
//            addButton.anchorManual(top: nil, left: nil, bottom: nil, right: viewTextNumericTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 18, height: 18)
//            addButton.centerYAnchor.constraint(equalTo: viewTextNumericTextField.centerYAnchor).isActive = true
//            removeButton.anchorManual(top: nil, left: viewTextNumericTextField.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
//            removeButton.centerYAnchor.constraint(equalTo: viewTextNumericTextField.centerYAnchor).isActive = true
//            itemsCountTextField.anchorManual(top: nil, left: removeButton.rightAnchor, bottom: nil, right: addButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
//            itemsCountTextField.centerYAnchor.constraint(equalTo: viewTextNumericTextField.centerYAnchor).isActive = true
            
            addToBasketButton.anchorManual(top: nil, left: viewDetails.leftAnchor, bottom: viewDetails.bottomAnchor, right: viewDetails.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: -8, paddingRight: 16, width: 0, height: 30)
        } else {
            
        }
        
        //==========================================================//
        // TODO: Update Product
        
        updateProduct()
        
    }
    
    fileprivate func updateViewsAndData(product: Product) {
        
        //=====================================================
        // FIXME: Update imageCollection and pageController
        
        self.images = product.images
        self.imageCollection.reloadData()
        self.pageControllerForImageCollection.numberOfPages = self.images.count
        
        //=====================================================
        // FIXME: Update viewInformation
        
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = "قیمت: \(product.price) ریال"
        if product.status == "available" {
            self.productStatusLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.productStatusLabel.text = "وضعیت: موجود"
        } else {
            self.productStatusLabel.textColor = #colorLiteral(red: 1, green: 0.2064451283, blue: 0.2974684767, alpha: 1)
            self.addToBasketButton.backgroundColor = #colorLiteral(red: 1, green: 0.2064451283, blue: 0.2974684767, alpha: 1)
            self.addToBasketButton.setTitle("ناموجود", for: .normal)
            self.addToBasketButton.isEnabled = false
            self.productStatusLabel.text = "وضعیت: ناموجود"
        }
        
        //=====================================================
        // FIXME: Update viewDetails and stackviewAttributes Constraint
        
        // Update stackviewAttributes heightAnchor
        
        let height = CGFloat(product.attributes.count * 30)
        self.stackviewAttributes.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.tempView = self.stackviewAttributes
        for attribute in product.attributes {
            let label = UILabel()
            label.textColor = .darkGray
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "\(attribute.name): \(attribute.value)"
            self.stackviewAttributes.addArrangedSubview(label)
        }
        
        // If VariantAttributes exists, create a label and a stackview for each variantAttribute
        
        if product.variantAttributes.count > 0 {

            for variantAttribute in product.variantAttributes {

                let stackview = UIStackView()
                stackview.distribution = .fillEqually
                stackview.axis = .horizontal
                stackview.spacing = 5

                let label = UILabel()
                label.textAlignment = .right
                label.font = UIFont.systemFont(ofSize: 14)
                label.text = variantAttribute.name

                for item in variantAttribute.choices {
                    let btn = UIButton(type: .system)
                    btn.addTarget(self, action: #selector(variantAttributeButtonPressed(_:)), for: .touchUpInside)
                    btn.layer.cornerRadius = 8
                    btn.setTitle(item, for: .normal)
                    btn.layer.borderColor = UIColor.lightGray.cgColor
                    btn.layer.borderWidth = 0.5
                    btn.setTitleColor(.darkGray, for: .normal)
                    stackview.addArrangedSubview(btn)
                }

                stackview.addArrangedSubview(label)
                self.viewDetails.addSubview(stackview)
                stackview.anchorManual(top: self.tempView?.bottomAnchor, left: viewDetails.leftAnchor, bottom: nil, right: viewDetails.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
                self.tempView = stackview
            }

        }
        
        // If user needs to upload image file
        
        if product.productType.isFileRequired {
            
            let selectFileLabel = UILabel()
            selectFileLabel.text = "عکس انتخابی: "
            selectFileLabel.textAlignment = .right
            selectFileLabel.font = UIFont.systemFont(ofSize: 14)
            viewDetails.addSubview(selectFileLabel)
            selectFileLabel.anchorManual(top: self.tempView?.bottomAnchor, left: nil, bottom: nil, right: viewDetails.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 90, height: 30)
            
            let selectFileButton = UIButton(type: .system)
            selectFileButton.setTitle("انتخاب عکس", for: .normal)
            selectFileButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            selectFileButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            selectFileButton.layer.cornerRadius = 8
            viewDetails.addSubview(selectFileButton)
            selectFileButton.anchorManual(top: self.tempView?.bottomAnchor, left: viewDetails.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 90, height: 30)
            
            self.tempView = selectFileLabel
        }
        
        // Create label with caption("تعداد") for viewTextNumericField
        
        let countLabel = UILabel()
        countLabel.text = "تعداد: "
        countLabel.textAlignment = .right
        countLabel.font = UIFont.systemFont(ofSize: 14)
        viewDetails.addSubview(countLabel)
        
        // Fix Constraints
        countLabel.anchorManual(top: self.tempView?.bottomAnchor, left: nil, bottom: nil, right: viewDetails.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 70, height: 30)
        viewTextNumericTextField.anchorManual(top: self.tempView?.bottomAnchor, left: viewDetails.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 90, height: 30)
        addButton.anchorManual(top: nil, left: nil, bottom: nil, right: viewTextNumericTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 18, height: 18)
        addButton.centerYAnchor.constraint(equalTo: viewTextNumericTextField.centerYAnchor).isActive = true
        removeButton.anchorManual(top: nil, left: viewTextNumericTextField.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
        removeButton.centerYAnchor.constraint(equalTo: viewTextNumericTextField.centerYAnchor).isActive = true
        itemsCountTextField.anchorManual(top: nil, left: removeButton.rightAnchor, bottom: nil, right: addButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 24)
        itemsCountTextField.centerYAnchor.constraint(equalTo: viewTextNumericTextField.centerYAnchor).isActive = true
        
        // Prevent Memory Leaking
        
        self.tempView = nil
    }
    
    fileprivate func animateViews(_ state: Bool) {
        activityIndicator.stopAnimating()
        
        //=====================================================
        // FIXME: Show Views One-By-One with animation
        
        if state {
            self.viewImages.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            self.viewInformation.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            self.viewDetails.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.viewImages.alpha = 1
                self.viewImages.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            }, completion: { (didFinish) in
                if didFinish {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.viewInformation.alpha = 1
                        self.viewInformation.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                    }, completion: { (didFinish) in
                        if didFinish {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.viewDetails.alpha = 1
                                self.viewDetails.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                            })
                        }
                    })
                }
            })
            
            //=====================================================
            // FIXME: Show alertView with animation
            
        } else {
            self.imageCollection.alpha = 0
            self.refreshButton.isHidden = false
            self.alertView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.alertView.alpha = 1
                self.refreshButton.alpha = 1
            })
        }
    }
    
    fileprivate func updateProduct() {
        
        activityIndicator.startAnimating()
        APIService.request.getProduct(productId: productId!) { (success, message, product) in
            if success {
                guard let product = product else { return }
                self.updateViewsAndData(product: product)
                self.animateViews(true)
            } else {
                self.animateViews(false)
            }
        }
    }
    
    // Mark: - Event and Handlers
    
    @objc fileprivate func refreshButtonPressed() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0
            self.refreshButton.alpha = 0
            self.refreshButton.isHidden = true
            self.imageCollection.alpha = 1
        }, completion: { (didFinish) in
          self.updateProduct()
        })
    }
    
    @objc fileprivate func addButtonPressed() {
        let textValue = itemsCountTextField.text
        guard let value = Int(textValue!) else { return }
        let newValue = (value + 1)
        itemsCountTextField.text = "\(newValue)"
    }
    
    @objc fileprivate func removeButtonPressed() {
        let textValue = itemsCountTextField.text
        guard let value = Int(textValue!) else { return }
        let newValue = (value == 0) ? 0 : (value - 1)
        itemsCountTextField.text = "\(newValue)"
    }
    
    @objc fileprivate func variantAttributeButtonPressed(_ sender: UIButton) {
        let superview = sender.superview as! UIStackView
        
        for item in superview.arrangedSubviews {
            if let btn = item as? UIButton {
                btn.backgroundColor = .white
                btn.setTitleColor(.darkGray, for: .normal)
            }
        }
        
        sender.backgroundColor = .lightGray
        sender.setTitleColor(.white, for: .normal)
    }
    
}

// Mark: - CollectionView DataSource and Delegate

extension ProductController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.setImage(url: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 16, height: (view.frame.width * 0.75) - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControllerForImageCollection.currentPage = indexPath.item
    }
}
