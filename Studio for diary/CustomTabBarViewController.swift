//
//  CustomTabBarViewController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-13.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    var myTabBarItem = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.darkGray], for: .normal)
        
        let selectedImage1 = UIImage(named: "add-white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "add")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![0]
        myTabBarItem.image = deSelectedImage1
        myTabBarItem.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "calendar-white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "calendar")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![1]
        myTabBarItem.image = deSelectedImage2
        myTabBarItem.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "map-white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "map")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![2]
        myTabBarItem.image = deSelectedImage3
        myTabBarItem.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "list-white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "list")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![3]
        myTabBarItem.image = deSelectedImage4
        myTabBarItem.selectedImage = selectedImage4
        
        let numberOfTabs = CGFloat((tabBar.items?.count)!)
        let tabBarSize = CGSize(width: tabBar.frame.width / numberOfTabs, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.08455248696, green: 0.5158828309, blue: 0.9233660698, alpha: 1), size: tabBarSize)
        self.selectedIndex = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
   class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        }
    
}
