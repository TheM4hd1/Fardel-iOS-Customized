//
//  HomeController.swift
//  Fardel-Persian
//
//  Created by MaHDi on 7/15/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit
import MaterialComponents

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeCellDelegate {
    
    private let cellId = "homeCell"
    private var postCollection: [Post] = []
    
    private lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshControllHandler(_:)), for: .valueChanged)
        return refreshControll
    }()
    
    private lazy var btnRefresh: UIBarButtonItem = { // Placed on navBar
        let btn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(btnRefreshPressed(_:)))
        return btn
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
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [.red, UIColor.fromRgb(red: 68, green: 110, blue: 212)]
        return indicator
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        //==========================================================//
        // TODO: Customize View and Navigation
        
        view.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        navigationItem.title = "خانه"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = btnRefresh
        
        //==========================================================//
        // TODO: Customize collectionView
        
        collectionView?.backgroundColor = UIColor.fromRgb(red: 247, green: 247, blue: 247)
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        
        //==========================================================//
        // TODO: Add Subviews
        
        if #available(iOS 11.0, *) {
            collectionView?.refreshControl = refreshControll
        } else {
            collectionView?.addSubview(refreshControll)
        }
        
        view.addSubview(activityIndicator)
        view.addSubview(alertView)
        view.addSubview(refreshButton)
        alertView.addSubview(alertLabel)
        
        //==========================================================//
        // TODO: Setup Constraints
        
        if #available(iOS 11.0, *) {
            
            activityIndicator.anchorManual(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            NSLayoutConstraint.activate([refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                         refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         refreshButton.widthAnchor.constraint(equalToConstant: 30),
                                         refreshButton.heightAnchor.constraint(equalToConstant: 30)])
            
            alertView.anchorManual(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
            alertLabel.anchorManual(top: alertView.topAnchor, left: alertView.leftAnchor, bottom: alertView.bottomAnchor, right: alertView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        } else {
            
        }

        refreshControll.beginRefreshing()
        APIService.request.refreshHome { (success) in
            self.updateHome(true)
        }
    }
    
    
    // Mark: - tableView delegate and datasource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Customize Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        cell.post = postCollection[indexPath.item]
        cell.delegate = self
        cell.setupViews()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // TODO: Load More Posts
        if indexPath.item == postCollection.count - 1 {
            updateHome(false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // TODO: Size for Cell
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let sampleCell = HomeCell(frame: frame)
        sampleCell.post = postCollection[indexPath.item]
        sampleCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = sampleCell.systemLayoutSizeFitting(targetSize)
        
        if #available(iOS 11.0, *) {
            let height = estimatedSize.height + view.frame.width/2 + 62
            return CGSize(width: view.frame.width - 20, height: height)
        } else {
            let height = estimatedSize.height + view.frame.width/2 + 48
            return CGSize(width: view.frame.width - 20, height: height)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    // Mark: - Cell delegate

    func didReadMorePressed(postId: Int) {
        let postController = PostController()
        postController.postId = postId
        navigationController?.pushViewController(postController, animated: true)
    }

    // Mark: - Event and Handlers
    
    @objc fileprivate func refreshButtonPressed() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.alpha = 0
            self.refreshButton.alpha = 0
        }) { (didFinish) in
            if didFinish {
                self.refreshButton.isHidden = true
                self.refreshButton.isEnabled = false
                self.collectionView?.isHidden = false
                self.updateHome(false)
            }
        }
    }
    
    @objc fileprivate func btnRefreshPressed(_ : UIBarButtonItem) {
        requestRefresh()
    }
    
    @objc fileprivate func refreshControllHandler(_ : UIRefreshControl) {
        requestRefresh()
    }
    
    fileprivate func updateHome(_ refreshControll: Bool) {
        if refreshControll {
            self.refreshControll.beginRefreshing()
        } else {
            activityIndicator.startAnimating()
        }
        
        APIService.request.receivePosts { (success, message, posts) in
            if success {
                self.postCollection.append(contentsOf: posts)
                self.refreshHandlers(refreshControll)
                self.collectionView?.reloadData()
                if (self.collectionView?.isHidden)! {
                    self.collectionView?.isHidden = false
                }
            } else {
                if !(message == "no more post") {
                    self.alertLabel.text = message
                    self.alertView.isHidden = false
                    self.collectionView?.isHidden = true
                    self.refreshButton.isEnabled = true
                    self.refreshButton.isHidden = false
                    UIView.animate(withDuration: 0.5) {
                        self.alertView.alpha = 1
                        self.refreshButton.alpha = 1
                    }
                }
                self.refreshHandlers(refreshControll)
            }
        }
    }
    
    fileprivate func requestRefresh() {
        APIService.request.refreshHome { (success) in
            if success {
                self.postCollection = []
                if !alertView.isHidden {
                    UIView.animate(withDuration: 0.5) {
                        self.alertView.alpha = 0
                    }
                }
                
                self.updateHome(true)
            }
        }
    }
    
    fileprivate func refreshHandlers(_ refreshControll: Bool) {
        if refreshControll {
            self.refreshControll.endRefreshing()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}
