//
//  MainTableBarController.swift
//  firebaseSocialLoginPractice
//
//  Created by 旌榮 凌 on 2020/9/30.
//  Copyright © 2020 com.dltic. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class MainTableBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        checkLoggedInUserStatus()
        setupViewControllers()
    }
    
    fileprivate func checkLoggedInUserStatus(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let welcomeController = WelcomeController()
                let welcomeNavigationController = UINavigationController(rootViewController: welcomeController)
                welcomeNavigationController.modalPresentationStyle = .fullScreen
                self.present(welcomeNavigationController, animated: false, completion: nil)
                return
            }
        }
    }
    
    fileprivate func setupViewControllers(){
        
        tabBar.unselectedItemTintColor = Service.unSelectedItemColor
        tabBar.tintColor = Service.darkBaseColor
        
        let homeController = HomeController()
        let homeNavigationController = UINavigationController(rootViewController: homeController)
        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        homeNavigationController.tabBarItem.selectedImage = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        
        
        let userProfileController = UserProfileController()
        let userProfileNavigationController = UINavigationController(rootViewController: userProfileController)
        userProfileNavigationController.tabBarItem.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate)
        userProfileNavigationController.tabBarItem.selectedImage = UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate)
        
        viewControllers = [homeNavigationController, userProfileNavigationController]
        
        guard let items = tabBar.items else {
            return
        }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
