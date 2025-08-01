//
//  ChooseImageVC.swift
//  MyPhotoBooth
//
//  Created by iKame Elite Fresher 2025 on 7/31/25.
//

import UIKit
import PhotosUI

class ResultVC: UIViewController {
    
    @IBOutlet weak var photoStripImageView: UIImageView!
    
    var layout: Int?
    var isCamera: Bool?

//    let myPhotoBoothVC = MyPhotoBoothVC()
    private var finalImage: UIImage?
    private var listImage: [UIImage] = []
    private var capturedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createPhotoStrip(_ sender: UIButton) {
        
//        guard let result = result else { return }
        
        listImage = []
        capturedCount = 0
        
        if isCamera == true {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
        } else {
            var config = PHPickerConfiguration()
            config.selectionLimit = layout ?? 4
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
            
            
            
            
        }
    }
    
    //    private func drawResultImage() {
    //        guard listImage.count == 4 else { return }
    //
    //        let frame = photoStripImageView.bounds
    //        let width = frame.width * 1395 / 3094
    //        let height = frame.height * 1939 / 4608
    //        let firstX: CGFloat =  117 / 3094
    //        let firstY: CGFloat = 198 / 4608
    //        let secondX: CGFloat = 1580 / 3094
    //        let secondY: CGFloat = 2463 / 4608
    //
    //        let renderer = UIGraphicsImageRenderer(bounds: frame)
    //        let image = renderer.image { context in
    //            listImage[0].draw(in: CGRect(x: width * firstX, y: height * firstY, width: width, height: height))
    //            listImage[1].draw(in: CGRect(x: width * secondX, y: height * firstY, width: width, height: height))
    //            listImage[2].draw(in: CGRect(x: width * firstX, y: height * secondY, width: width, height: height))
    //            listImage[3].draw(in: CGRect(x: width * secondX, y: height * secondY, width: width, height: height))
    //        }
    //
    //        finalImage = image
    //        photoStripImageView.image = image
    //    }
    
    private func drawResultImage() {
        guard listImage.count == 4 else { return }
        
        let frame = photoStripImageView.bounds
        let canvasWidth = frame.width
        let canvasHeight = frame.height
        
        // Kích thước gốc ảnh: 3094 x 4607
        let baseWidth: CGFloat = 3094
        let baseHeight: CGFloat = 4607
        
        // Scale theo tỷ lệ giữa ảnh thật và ảnh hiển thị
        let xScale = canvasWidth / baseWidth
        let yScale = canvasHeight / baseHeight
        
        let renderer = UIGraphicsImageRenderer(bounds: frame)
        let image = renderer.image { context in
            // Ô 1
            listImage[0].draw(in: CGRect(
                x: 117 * xScale,
                y: 198 * yScale,
                width: 1395 * xScale,
                height: 1939 * yScale
            ))
            
            // Ô 2
            listImage[1].draw(in: CGRect(
                x: 1580 * xScale,
                y: 361 * yScale,
                width: 1395 * xScale,
                height: 1939 * yScale
            ))
            
            // Ô 3
            listImage[2].draw(in: CGRect(
                x: 117 * xScale,
                y: 2300 * yScale,
                width: 1395 * xScale,
                height: 1939 * yScale
            ))
            
            // Ô 4
            listImage[3].draw(in: CGRect(
                x: 1580 * xScale,
                y: 2463 * yScale,
                width: 1395 * xScale,
                height: 1939 * yScale
            ))
        }
        
        finalImage = image
        photoStripImageView.image = image
    }
    
}

extension ResultVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        listImage = []
        let itemProviders = results.map { $0.itemProvider }
        
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.listImage.append(image)
                            if self.listImage.count == 4 {
                                self.drawResultImage()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ResultVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        listImage.append(image)
        capturedCount += 1
        
        if let layoutCount = layout, layoutCount > 0, capturedCount < layoutCount {
            //            presentCamera()
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
        } else {
            drawResultImage()
        }
    }
}
