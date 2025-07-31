//
//  ViewController.swift
//  MyPhotoBooth
//
//  Created by iKame Elite Fresher 2025 on 7/31/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        let vc = MyPhotoBoothVC()
        let naviVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = naviVC
    }


}

