//
//  MyPhotoBoothVC.swift
//  MyPhotoBooth
//
//  Created by iKame Elite Fresher 2025 on 7/31/25.
//

import UIKit

class MyPhotoBoothVC: UIViewController {
    
    var layout: Int?
    var isCamera: Bool?
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chooseLayoutStackView: UIStackView!
    @IBOutlet weak var chooseCameraStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        chooseCameraStackView.isHidden = true
        backButton.isHidden = true
    }
    
    @IBAction func fourPicsButton(_ sender: Any) {
        chooseLayoutStackView.isHidden = true
        chooseCameraStackView.isHidden = false
        backButton.isHidden = false
        
        layout = 4
    }
    
    
    @IBAction func fivePicsButton(_ sender: Any) {
        chooseLayoutStackView.isHidden = true
        chooseCameraStackView.isHidden = false
        backButton.isHidden = false

        layout = 5
    }
    
    @IBAction func chooseCamera(_ sender: Any) {
        let cameraVC = CameraVC()
        cameraVC.numberOfImages = self.layout
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    @IBAction func chooseUpload(_ sender: Any) {
        isCamera = false
        let resultVC = ResultVC()
        resultVC.layout = self.layout
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        chooseLayoutStackView.isHidden = false
        chooseCameraStackView.isHidden = true
        backButton.isHidden = true
    }
    
}
