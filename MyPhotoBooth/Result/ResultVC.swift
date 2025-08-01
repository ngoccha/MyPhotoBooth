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
    
    private var finalImage: UIImage?
    private var listImage: [UIImage] = [] {
        didSet {
            if (layout == 4 && listImage.count == 4) || (layout == 5 && listImage.count == 5) {
                drawResultImage()
            }
        }
    }
    private var capturedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createPhotoStrip(_ sender: UIButton) {
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
    
    private func drawResultImage() {
        guard let layout = layout else { return }
        let frame = photoStripImageView.bounds
        
        if layout == 4 {
            guard listImage.count == 4 else { return }
            
            let canvasWidth = frame.width
            let canvasHeight = frame.height
            
            let baseWidth: CGFloat = 3094
            let baseHeight: CGFloat = 4607
            
            let xScale = canvasWidth / baseWidth
            let yScale = canvasHeight / baseHeight
            
            let width = 1395 * xScale
            let height = 1939 * yScale
            
            let renderer = UIGraphicsImageRenderer(bounds: frame)
            let image = renderer.image { context in
                listImage[0].draw(in: CGRect(x: 117 * xScale, y: 198 * yScale, width: width, height: height))
                listImage[1].draw(in: CGRect(x: 1580 * xScale,y: 361 * yScale,width: width, height: height))
                listImage[2].draw(in: CGRect(x: 117 * xScale,y: 2205 * yScale,width: width, height: height))
                listImage[3].draw(in: CGRect(x: 1580 * xScale,y: 2368 * yScale,width: width, height: height))
            }
            finalImage = image
            photoStripImageView.image = image
            
        }  else {
            guard listImage.count == 5 else { return }
            
            let numberOfImage: Int = 5
            let padding: CGFloat = 24
            let width = frame.width - (padding * 2)
            let height = (frame.height - padding * 3) / 2
            let imageWidth = width / CGFloat(numberOfImage)
            
            let renderer = UIGraphicsImageRenderer(bounds: frame)
            let image = renderer.image { context in
                func draw(images: [UIImage], startY: CGFloat) {
                let frame1 = CGRect(x: padding, y: padding, width: width * 1/5, height: height)
                let firstImage = listImage.first!
                firstImage.draw(in: frame1)
                
                let fifthImage = listImage[4]
                let frame5 = CGRect(x: width * 4/5 + padding, y: padding, width: width * 1/5, height: height)
                fifthImage.draw(in: frame5)
                
                let rectPath1 = UIBezierPath()
                rectPath1.move(to: .init(x: (width * 1/5)-20 + padding, y: padding))
                rectPath1.addLine(to: .init(x: width * 2/5 + 20 + padding, y: padding))
                rectPath1.addLine(to: .init(x: width * 2/5 + padding, y: height + padding))
                rectPath1.addLine(to: .init(x: width * 1/5 + padding, y: height + padding))
                rectPath1.close()
                rectPath1.addClip()
                
                let secondImage = listImage[1]
                let frame2 = CGRect(x: (width * 1/5) - 20 + padding, y: padding, width: width / 5 + 40, height: height)
                secondImage.draw(in: frame2)
                
                UIGraphicsGetCurrentContext()?.resetClip()
                
                let rectPath2 = UIBezierPath()
                rectPath2.move(to: CGPoint(x: (width * 3/5) - 20 + padding, y: padding))
                rectPath2.addLine(to: CGPoint(x: width * 4/5 + 20 + padding, y: padding))
                rectPath2.addLine(to: CGPoint(x: width * 4/5 + padding, y: height + padding))
                rectPath2.addLine(to: CGPoint(x: width * 3/5 + padding, y: height + padding))
                rectPath2.close()
                rectPath2.addClip()
                
                let fourthImage = listImage[3]
                let frame4 = CGRect(x: (width * 3/5) - 20 + padding, y: padding, width: width / 5 + 40, height: height)
                fourthImage.draw(in: frame4)
                
                
                UIGraphicsGetCurrentContext()?.resetClip()
                
                let rectPath3 = UIBezierPath()
                rectPath3.move(to: CGPoint(x: width * 2/5 + padding, y: padding))
                rectPath3.addLine(to: CGPoint(x: width * 3/5 + padding, y: padding))
                rectPath3.addLine(to: CGPoint(x: width * 3/5 + 20 + padding, y: height + padding))
                rectPath3.addLine(to: CGPoint(x: width * 2/5 - 20 + padding, y: height + padding))
                rectPath3.close()
                
                rectPath3.addClip()
                
                let thirdImage = listImage[2]
                let frame3 = CGRect(x: width * 2/5 - 20 + padding, y: padding, width: width * 1/5 + 40, height: height)
                thirdImage.draw(in: frame3)
                
                
                // Bỏ clip đi để còn vẽ típ
                UIGraphicsGetCurrentContext()?.resetClip()
                
                let borderPath = UIBezierPath()
                borderPath.move(to: .init(x: (width * 1/5)-20 + padding, y: padding))
                borderPath.addLine(to: .init(x: width * 1/5 + padding, y: height + padding))
                
                borderPath.move(to: .init(x: width * 2/5 + padding, y: padding))
                borderPath.addLine(to: .init(x: width * 2/5 - 20 + padding, y: height + padding))
                
                borderPath.move(to: .init(x: width * 3/5 + padding, y: padding))
                borderPath.addLine(to: .init(x: width * 3/5 + 20 + padding, y: height + padding))
                
                borderPath.move(to: .init(x: width * 4/5 + 20 + padding, y: padding))
                borderPath.addLine(to: .init(x: width * 4/5 + padding, y: height + padding))
                
                UIColor.blue3.setStroke()
                borderPath.lineWidth = 10
                borderPath.stroke()
                
                
                
                let frame21 = CGRect(x: padding, y: padding * 2 + height, width: width * 1/5, height: height)
                let first2Image = listImage.first!
                first2Image.draw(in: frame21)
                
                let fifth2Image = listImage[4]
                let frame25 = CGRect(x: width * 4/5 + padding, y: padding * 2 + height, width: width * 1/5, height: height)
                fifth2Image.draw(in: frame25)
                
                let rectPath21 = UIBezierPath()
                rectPath21.move(to: .init(x: (width * 1/5)-20 + padding, y: padding * 2 + height))
                rectPath21.addLine(to: .init(x: width * 2/5 + 20 + padding, y: padding * 2 + height))
                rectPath21.addLine(to: .init(x: width * 2/5 + padding, y: height * 2 + padding * 2))
                rectPath21.addLine(to: .init(x: width * 1/5 + padding, y: height * 2 + padding * 2))
                rectPath21.close()
                rectPath21.addClip()
                
                let second2Image = listImage[1]
                let frame22 = CGRect(x: (width * 1/5) - 20 + padding, y: padding + padding + height, width: width / 5 + 40, height: height)
                second2Image.draw(in: frame22)
                
                UIGraphicsGetCurrentContext()?.resetClip()
                
                let rectPath22 = UIBezierPath()
                rectPath22.move(to: CGPoint(x: (width * 3/5) - 20 + padding, y: padding + padding + height))
                rectPath22.addLine(to: CGPoint(x: width * 4/5 + 20 + padding, y: padding + padding + height))
                rectPath22.addLine(to: CGPoint(x: width * 4/5 + padding, y: height + padding + padding + height))
                rectPath22.addLine(to: CGPoint(x: width * 3/5 + padding, y: height + padding + padding + height))
                rectPath22.close()
                rectPath22.addClip()
                
                let fourth2Image = listImage[3]
                let frame24 = CGRect(x: (width * 3/5) - 20 + padding, y: padding + padding + height, width: width / 5 + 40, height: height)
                fourth2Image.draw(in: frame24)
                
                
                UIGraphicsGetCurrentContext()?.resetClip()
                
                let rectPath23 = UIBezierPath()
                rectPath23.move(to: CGPoint(x: width * 2/5 + padding, y: padding + padding + height))
                rectPath23.addLine(to: CGPoint(x: width * 3/5 + padding, y: padding + padding + height))
                rectPath23.addLine(to: CGPoint(x: width * 3/5 + 20 + padding, y: height + padding + padding + height))
                rectPath23.addLine(to: CGPoint(x: width * 2/5 - 20 + padding, y: height + padding + padding + height))
                rectPath23.close()
                
                rectPath23.addClip()
                
                let third2Image = listImage[2]
                let frame23 = CGRect(x: width * 2/5 - 20 + padding, y: padding + padding + height, width: width * 1/5 + 40, height: height)
                third2Image.draw(in: frame23)
                
                
                // Bỏ clip đi để còn vẽ típ
                UIGraphicsGetCurrentContext()?.resetClip()
                
                let borderPath2 = UIBezierPath()
                borderPath2.move(to: .init(x: (width * 1/5)-20 + padding, y: padding + padding + height))
                borderPath2.addLine(to: .init(x: width * 1/5 + padding, y: height + padding + padding + height))
                
                borderPath2.move(to: .init(x: width * 2/5 + padding, y: padding + padding + height))
                borderPath2.addLine(to: .init(x: width * 2/5 - 20 + padding, y: height + padding + padding + height))
                
                borderPath2.move(to: .init(x: width * 3/5 + padding, y: padding + padding + height))
                borderPath2.addLine(to: .init(x: width * 3/5 + 20 + padding, y: height + padding + padding + height))
                
                borderPath2.move(to: .init(x: width * 4/5 + 20 + padding, y: padding + padding + height))
                borderPath2.addLine(to: .init(x: width * 4/5 + padding, y: height + padding + padding + height))
                
                UIColor.blue3.setStroke()
                borderPath2.lineWidth = 10
                borderPath2.stroke()
            }
                draw(image: listImage, startY: padding)
                draw(images: listImage, startY: padding * 2 + height)
            }
            finalImage = image
            photoStripImageView.image = image
        }
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
                            self.drawResultImage()
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
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
        } else {
            drawResultImage()
        }
    }
}
