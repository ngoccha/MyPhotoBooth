//
//  CameraVC.swift
//  MyPhotoBooth
//
//  Created by Ngoc Ha on 3/8/25.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var cameraPreviewView: UIView!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let captureSession = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var isUsingFrontCamera = true
    private var flashMode = AVCaptureDevice.FlashMode.auto
    private var hasCapturedPhoto = false
    
    var numberOfImages: Int?
    var currentCapturedImage: UIImage?
    var capturedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraPreviewView.layer.cornerRadius = 20
        previewLayer?.frame = cameraPreviewView.bounds
    }
    
    @IBAction func shutterButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func changeCameraButton(_ sender: Any) {
        captureSession.beginConfiguration()
        
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }
        
        let newPosition: AVCaptureDevice.Position = isUsingFrontCamera ? .back : .front
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: newDevice),
              captureSession.canAddInput(newInput) else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.addInput(newInput)
        isUsingFrontCamera.toggle()
        
        captureSession.commitConfiguration()
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        if hasCapturedPhoto == false {
            navigationController?.popViewController(animated: true)
        } else {
            hasCapturedPhoto = false
            previewLayer.frame = cameraPreviewView.bounds
            cameraPreviewView.layer.addSublayer(previewLayer)
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    @IBAction func flashButton(_ sender: Any) {
        if flashMode == .auto {
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "icFlashOn"), for: .normal)
        }
        else if flashMode == .on {
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "icFlashOff"), for: .normal)
        }
        else {
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "icFlashAuto"), for: .normal)
        }
    }
    
    @IBAction func chooseButton(_ sender: Any) {
        guard let selectedImage = currentCapturedImage else { return }
        
        capturedImages.append(selectedImage)
        currentCapturedImage = nil
        hasCapturedPhoto = false
        
        if let expectedCount = numberOfImages, capturedImages.count == expectedCount {
            captureSession.stopRunning()
            
            let resultVC = ResultVC()
            resultVC.layout = expectedCount
            resultVC.isCamera = true
            resultVC.listImage = capturedImages
            
            navigationController?.pushViewController(resultVC, animated: true)
        } else {
            cameraPreviewView.subviews.forEach { $0.removeFromSuperview() }
            cameraPreviewView.layer.addSublayer(previewLayer)
            previewLayer.frame = cameraPreviewView.bounds
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
            
            hasCapturedPhoto = false
        }
    }
}

//MARK: setup config ----
extension CameraVC: AVCapturePhotoCaptureDelegate {
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self.configCamera()
                }
            })
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            configCamera()
        @unknown default:
            break
        }
    }
    
    private func configCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        //lấy cam trước làm auto + tạo input
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = cameraPreviewView.bounds
        cameraPreviewView.layer.addSublayer(previewLayer)
        previewLayer.cornerRadius = 20
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data = photo.fileDataRepresentation() else { return }
        var image = UIImage(data: data)
        
        if let img = image, let cgImg = img.cgImage {
            image = UIImage(
                cgImage: cgImg,
                scale: img.scale,
                orientation: isUsingFrontCamera ? .leftMirrored : .right
            )
        }
        
        hasCapturedPhoto = true
        currentCapturedImage = image

        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = cameraPreviewView.bounds
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        cameraPreviewView.subviews.forEach { $0.removeFromSuperview() }
        cameraPreviewView.addSubview(imageView)
    }
}
