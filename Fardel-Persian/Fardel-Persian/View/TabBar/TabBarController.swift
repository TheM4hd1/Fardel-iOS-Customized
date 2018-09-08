//
//  TabBarController
//  Fardel-Persian
//
//  Created by MaHDi on 7/5/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //==========================================================//
        // TODO: Creating tabBar items
        
        // FIXME: Home
        let layoutForHome = UICollectionViewFlowLayout() // We should pass a unique layout for each CollectionViewController otherwise it doesnt work correctly.
        layoutForHome.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let home = configureItem(controller: HomeController(collectionViewLayout: layoutForHome), unselectedImage: #imageLiteral(resourceName: "baseline_home_white_36pt_"), selectedImage: #imageLiteral(resourceName: "baseline_home_black_36pt_"))
        
        // FIXME: Profile
        let person = configureItem(controller: ProfileController(), unselectedImage: #imageLiteral(resourceName: "baseline_person_white_36pt_"), selectedImage: #imageLiteral(resourceName: "baseline_person_black_36pt_"))
        
        // FIXME: Shop
        let shop = configureItem(controller: ShopController(), unselectedImage: #imageLiteral(resourceName: "baseline_shopping_cart_white_36pt_"), selectedImage: #imageLiteral(resourceName: "baseline_shopping_cart_black_36pt_"))
        
        //==========================================================//
        // TODO: Configuring tabBar items
        
        viewControllers = [home, shop, person]
        tabBar.tintColor = .black
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func configureItem(controller: UIViewController, unselectedImage: UIImage, selectedImage: UIImage) -> UINavigationController {
        
        let template = UINavigationController(rootViewController: controller)
        template.tabBarItem.image = unselectedImage
        template.tabBarItem.selectedImage = selectedImage
        template.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return template
    }
    
}

