//
//  ChoosePhotoBoothVC.swift
//  MyPhotoBooth
//
//  Created by Ngoc Ha on 31/7/25.
//

import UIKit

class ChoosePhotoBoothVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func startButton(_ sender: Any) {
        let optionVC = MyPhotoBoothVC()
        
        navigationController?.pushViewController(optionVC, animated: true)
    }
}
