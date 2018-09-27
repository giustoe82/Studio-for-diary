//
//  ShowFullScreenController.swift
//  Studio for diary
//
//  Created by Marco Giustozzi on 2018-09-27.
//  Copyright © 2018 marcog. All rights reserved.
//

import UIKit
import Firebase

class ShowFullScreenController: UIViewController {
    
    @IBOutlet weak var fullImage: UIImageView!
    
    //this variable is going to be used as parameter in the loadImage function
    var getFullImage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get image from loadImage with a specific name which is getFullImage
        loadImage(imgUrl: getFullImage)
    }
    
    func loadImage(imgUrl:String)  {
        
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    
                    if let myImg = UIImage(data: imgData) {
                        
                        self.fullImage.image = myImg
                        
                    }
                }
            }
        }
    }
}


