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
    @IBOutlet weak var createPhotoStripButton: UIButton!
    
    var layout: Int?
    var isCamera: Bool?
    
    private var finalImage: UIImage?
    private var didCreatePhotoStrip = false
    private var didSaveToLibrary = false
    
    var listImage: [UIImage] = [] {
        didSet {
            if (layout == 4 && listImage.count == 4) || (layout == 5 && listImage.count == 5) {
                DispatchQueue.main.async { [weak self] in
                    self?.drawResultImage()
                }
            }
        }
    }
    
    init(listImage: [UIImage] = [], layout: Int? = nil, isCamera: Bool? = nil) {
        super.init(nibName: "ResultVC", bundle: nil)
        self.layout = layout
        self.isCamera = isCamera
        self.listImage = listImage
        
        if (layout == 4 && listImage.count == 4) || (layout == 5 && listImage.count == 5) {
            DispatchQueue.main.async { [weak self] in
                self?.drawResultImage()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var capturedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createPhotoStrip(_ sender: UIButton) {
        if !didCreatePhotoStrip {
            listImage = []
            capturedCount = 0
            
            if isCamera == true {
                drawResultImage()
            } else {
                var config = PHPickerConfiguration()
                config.selectionLimit = layout ?? 4
                config.filter = .images
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                present(picker, animated: true)
            }
            
        } else if !didSaveToLibrary, let savedImage = finalImage {
            UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil)
            didSaveToLibrary = true
            setButtonTitle("Start again")
        } else {
            navigationController?.popToRootViewController(animated: true)
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
                UIColor.blue3.setFill()
                context.fill(frame)
                
                let targetRects = [
                    CGRect(x: 117 * xScale, y: 198 * yScale, width: width, height: height),
                    CGRect(x: 1580 * xScale, y: 361 * yScale, width: width, height: height),
                    CGRect(x: 117 * xScale, y: 2205 * yScale, width: width, height: height),
                    CGRect(x: 1580 * xScale, y: 2368 * yScale, width: width, height: height)
                ]
                
                for i in 0..<4 {
                    context.cgContext.saveGState()
                    
                    let target = targetRects[i]
                    
                    let clipPath = UIBezierPath(rect: target)
                    clipPath.addClip()
                    
                    let drawRect = aspectFilledRect(for: listImage[i].size, in: target)
                    listImage[i].draw(in: drawRect)
                    
                    context.cgContext.restoreGState()
                }
                
            }
            finalImage = image
            photoStripImageView.image = image
            didCreatePhotoStrip = true
            setButtonTitle("Save to Library")
        }  else {
            
            guard listImage.count == 5 else { return }
            
            let numberOfImage: Int = 5
            let padding: CGFloat = 24
            let overlap: CGFloat = 20
            
            let width = frame.width - (padding * 2)
            let height = (frame.height - padding * 3) / 2
            let imageWidth = width / CGFloat(numberOfImage)
            
            let renderer = UIGraphicsImageRenderer(bounds: frame)
            let image = renderer.image { context in
                UIColor.blue3.setFill()
                context.fill(frame)
                
                for row in 0..<2 {
                    let lastIndex = listImage.count - 1
                    
                    let startY = CGFloat(row) * (height + padding) + padding
                    
                    for index in 0..<listImage.count {
                        context.cgContext.saveGState()
                        
                        let image = listImage[index]
                        let imageFrame = CGRect(x: padding + CGFloat(index) * imageWidth, y: startY, width: imageWidth, height: height)
                        
                        if index == 0 {
                            let leftX = padding
                            let rightX = padding + imageWidth + overlap
                            
                            let clipPath = UIBezierPath()
                            clipPath.move(to: CGPoint(x: leftX, y: startY))
                            clipPath.addLine(to: CGPoint(x: rightX - overlap, y: startY))
                            clipPath.addLine(to: CGPoint(x: rightX, y: startY + height))
                            clipPath.addLine(to: CGPoint(x: leftX, y: startY + height))
                            clipPath.close()
                            clipPath.addClip()
                            
                        } else {
                            let leftX = padding + CGFloat(index) * imageWidth - overlap
                            let rightX = padding + CGFloat(index + 1) * imageWidth + overlap
                            
                            let clipPath = UIBezierPath()
                            
                            if index == lastIndex {
                                clipPath.move(to: CGPoint(x: leftX + overlap, y: startY))
                                clipPath.addLine(to: CGPoint(x: rightX - overlap, y: startY))
                                clipPath.addLine(to: CGPoint(x: rightX - overlap, y: startY + height))
                                clipPath.addLine(to: CGPoint(x: leftX, y: startY + height))
                            } else if index % 2 == 1 {
                                clipPath.move(to: CGPoint(x: leftX, y: startY))
                                clipPath.addLine(to: CGPoint(x: rightX, y: startY))
                                clipPath.addLine(to: CGPoint(x: rightX - overlap, y: startY + height))
                                clipPath.addLine(to: CGPoint(x: leftX + overlap, y: startY + height))
                            } else {
                                clipPath.move(to: CGPoint(x: leftX + overlap, y: startY))
                                clipPath.addLine(to: CGPoint(x: rightX - overlap, y: startY))
                                clipPath.addLine(to: CGPoint(x: rightX, y: startY + height))
                                clipPath.addLine(to: CGPoint(x: leftX, y: startY + height))
                            }
                            
                            clipPath.close()
                            clipPath.addClip()
                        }
                        
                        
                        let fittedFrame = aspectFilledRect(for: image.size, in: imageFrame)
                        image.draw(in: fittedFrame)
                        context.cgContext.restoreGState()
                    }
                    
                    let border = UIBezierPath()
                    border.lineWidth = 10
                    UIColor.blue3.setStroke()
                    
                    for index in 1..<listImage.count {
                        let y = startY
                        let x = padding + imageWidth * CGFloat(index)
                        
                        if index == lastIndex {
                            border.move(to: CGPoint(x: x, y: y))
                            border.addLine(to: CGPoint(x: x - overlap, y: y + height))
                        } else if index % 2 == 1 {
                            border.move(to: CGPoint(x: x - overlap, y: y))
                            border.addLine(to: CGPoint(x: x, y: y + height))
                        } else {
                            border.move(to: CGPoint(x: x, y: y))
                            border.addLine(to: CGPoint(x: x - overlap, y: y + height))
                        }
                    }
                    
                    border.stroke()
                    
                }
            }
            
            finalImage = image
            photoStripImageView.image = image
            didCreatePhotoStrip = true
            setButtonTitle("Save to Library")
        }
    }
    
    private func setButtonTitle(_ title: String) {
        let attributed = NSAttributedString(
            string: title,
            attributes: [
                .font: createPhotoStripButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 20, weight: .semibold),
                .foregroundColor: createPhotoStripButton.titleLabel?.textColor ?? UIColor.blue1
            ]
        )
        createPhotoStripButton.setAttributedTitle(attributed, for: .normal)
    }

    func aspectFilledRect(for imageSize: CGSize, in targetRect: CGRect) -> CGRect {
        let imageAspect = imageSize.width / imageSize.height
        let targetAspect = targetRect.width / targetRect.height
        var drawRect = targetRect
        if imageAspect > targetAspect {
            // Image is wider than target: scale by height, crop horizontally
            let width = targetRect.height * imageAspect
            let x = targetRect.origin.x - (width - targetRect.width) / 2
            drawRect = CGRect(x: x, y: targetRect.origin.y, width: width, height: targetRect.height)
        } else {
            // Image is taller than target: scale by width, crop vertically
            let height = targetRect.width / imageAspect
            let y = targetRect.origin.y - (height - targetRect.height) / 2
            drawRect = CGRect(x: targetRect.origin.x, y: y, width: targetRect.width, height: height)
        }
        return drawRect
    } //chatgpt
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
                        DispatchQueue.main.sync {
                            self.listImage.append(image)
                            self.drawResultImage()
                        }
                    }
                }
            }
        }
    }
}

//    extension ResultVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            picker.dismiss(animated: true)
//
//            guard let image = info[.originalImage] as? UIImage else { return }
//
//            listImage.append(image)
//            capturedCount += 1
//
//            if let layoutCount = layout, layoutCount > 0, capturedCount < layoutCount {
//                let picker = UIImagePickerController()
//                picker.sourceType = .camera
//                picker.delegate = self
//                present(picker, animated: true)
//            } else {
//                drawResultImage()
//            }
//        }
//    }
