//
//  CameraVC.swift
//  MyPhotoBooth
//
//  Created by Ngoc Ha on 3/8/25.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    
    private var previewLayer: AVCaptureVideoPreviewLayer! //layer dùng để preview cam lên màn chính
    private let captureSession = AVCaptureSession() //bộ xử lý chính để lấy hình ảnh từ cam
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCamera()
    }
    
    private func configCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        //lấy cam trước làm auto + tạo input
        captureSession.addInput(input) // gắn input vào session
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) //tạo layer để hiển thị ảnh từ session
        previewLayer.frame = cameraPreviewView.bounds
        cameraPreviewView.layer.addSublayer(previewLayer) //thêm layer vào giao diện
        captureSession.startRunning() //chạy camera
    }
}
