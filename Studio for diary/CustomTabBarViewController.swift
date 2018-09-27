//
//  CustomTabBarViewController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi, Aleks Edholm, Aleksander Frostelén on 2018-09-23.
//  Copyright © 2018 Group g. All rights reserved.
//




import UIKit

class CustomTabBarViewController: UITabBarController {
    
    var myTabBarItem = UITabBarItem()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up text color for icons
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)
        
        /*
         Setting up images to be used as icons
         */
        let selectedImage1 = UIImage(named: "add-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![0]
        myTabBarItem.image = deSelectedImage1
        myTabBarItem.selectedImage = selectedImage1
        
        /*let selectedImage2 = UIImage(named: "calendar-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "calendar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![1]
        myTabBarItem.image = deSelectedImage2
        myTabBarItem.selectedImage = selectedImage2*/
        
        let selectedImage3 = UIImage(named: "map-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "map")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![1]
        myTabBarItem.image = deSelectedImage3
        myTabBarItem.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "list-white")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "list")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem = self.tabBar.items![2]
        myTabBarItem.image = deSelectedImage4
        myTabBarItem.selectedImage = selectedImage4
        
        
    }
    /*
     We set up the blue rectangle for the selected tabBar item in viewDidLayoutSubviews()
     so that it is responsive when the user switch the screen to landscape mode
     */
    override func viewDidLayoutSubviews() {
        let numberOfTabs = CGFloat((tabBar.items?.count)!)
        let tabBarSize = CGSize(width: tabBar.frame.width / numberOfTabs, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), size: tabBarSize)
        //self.selectedIndex = 0
        
        
    }

    
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


//iphoneX screen adjusting
extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + 40
        return sizeThatFits
}
}
