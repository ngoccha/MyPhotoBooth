//
//  MyPhotoBoothVC.swift
//  MyPhotoBooth
//
//  Created by iKame Elite Fresher 2025 on 7/31/25.
//

import UIKit

class MyPhotoBoothVC: UIViewController {
    
    @IBOutlet weak var exampleImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var fourPicsImageView: UIImageView!
    @IBOutlet weak var fivePicsImageView: UIImageView!
    @IBOutlet weak var chooseLayoutStackView: UIStackView!
    @IBOutlet weak var chooseCameraStackView: UIStackView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fourPicsImageView.tag = 4
        fivePicsImageView.tag = 5
        
        let tapFour = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        fourPicsImageView.isUserInteractionEnabled = true
        fourPicsImageView.addGestureRecognizer(tapFour)
        
        let tapFive = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        fivePicsImageView.isUserInteractionEnabled = true
        fivePicsImageView.addGestureRecognizer(tapFive)
        
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        exampleImageView.isHidden = true
        startButton.isHidden = true
        chooseCameraStackView.isHidden = true
        chooseLayoutStackView.isHidden = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Tapped gesture called")
        
        chooseLayoutStackView.isHidden = true
        chooseCameraStackView.isHidden = false
    }
    
}
