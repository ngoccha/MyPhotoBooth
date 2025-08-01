//@IBAction func createPhotoStrip(_ sender: UIButton) {
//        listImage = []
//        capturedCount = 0
//        
//        if isCamera == true {
//            presentCamera()
//        } else {
//            presentPhotoLibrary()
//        }
//    }
//
//    private func presentCamera() {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//
//    private func presentPhotoLibrary() {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = layout ?? 4
//        config.filter = .images
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//    
//    private func drawResultImage() {
//        guard let layout = layout else { return }
//        let frame = photoStripImageView.bounds
//
//        let renderer = UIGraphicsImageRenderer(bounds: frame)
//        finalImage = renderer.image { context in
//            if layout == 4 {
//                drawLayout4(in: context.cgContext, frame: frame)
//            } else {
//                drawLayout5(in: context.cgContext, frame: frame)
//            }
//        }
//
//        photoStripImageView.image = finalImage
//    }
//
//    private func drawLayout4(in context: CGContext, frame: CGRect) {
//        guard listImage.count == 4 else { return }
//
//        let baseWidth: CGFloat = 3094
//        let baseHeight: CGFloat = 4607
//        let xScale = frame.width / baseWidth
//        let yScale = frame.height / baseHeight
//
//        let width = 1395 * xScale
//        let height = 1939 * yScale
//
//        let positions: [(CGFloat, CGFloat)] = [
//            (117, 198), (1580, 361), (117, 2205), (1580, 2368)
//        ]
//
//        for (index, pos) in positions.enumerated() {
//            let rect = CGRect(x: pos.0 * xScale, y: pos.1 * yScale, width: width, height: height)
//            listImage[index].draw(in: rect)
//        }
//    }
//
//    private func drawLayout5(in context: CGContext, frame: CGRect) {
//        guard listImage.count == 5 else { return }
//
//        let padding: CGFloat = 24
//        let width = frame.width - padding * 2
//        let height = (frame.height - padding * 3) / 2
//
//        for row in 0..<2 {
//            let yOffset = padding + CGFloat(row) * (height + padding)
//            drawRow(in: context, yOffset: yOffset, width: width, height: height, padding: padding)
//        }
//    }
//
//    private func drawRow(in context: CGContext, yOffset: CGFloat, width: CGFloat, height: CGFloat, padding: CGFloat) {
//        let xPositions: [CGFloat] = [0, 1, 2, 3, 4].map { width * CGFloat($0) / 5 + padding }
//        let drawRects: [CGRect] = [
//            CGRect(x: xPositions[0], y: yOffset, width: width/5, height: height),
//            CGRect(x: xPositions[1] - 20, y: yOffset, width: width/5 + 40, height: height),
//            CGRect(x: xPositions[2] - 20, y: yOffset, width: width/5 + 40, height: height),
//            CGRect(x: xPositions[3] - 20, y: yOffset, width: width/5 + 40, height: height),
//            CGRect(x: xPositions[4], y: yOffset, width: width/5, height: height),
//        ]
//
//        for (index, rect) in drawRects.enumerated() {
//            if [1, 2, 3].contains(index) {
//                let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: 0)
//                clipPath.addClip()
//            }
//            listImage[index].draw(in: rect)
//            context.resetClip()
//        }
//
//        drawVerticalBorders(context: context, width: width, height: height, yOffset: yOffset, padding: padding)
//    }
//
//    private func drawVerticalBorders(context: CGContext, width: CGFloat, height: CGFloat, yOffset: CGFloat, padding: CGFloat) {
//        let borderPath = UIBezierPath()
//        for i in 1..<5 {
//            let x = width * CGFloat(i) / 5 + padding
//            borderPath.move(to: CGPoint(x: x, y: yOffset))
//            borderPath.addLine(to: CGPoint(x: x, y: yOffset + height))
//        }
//        UIColor.blue3.setStroke()
//        borderPath.lineWidth = 10
//        borderPath.stroke()
//    }
//}
//
//extension ResultVC: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        dismiss(animated: true)
//        let itemProviders = results.map { $0.itemProvider }
//        
//        for item in itemProviders where item.canLoadObject(ofClass: UIImage.self) {
//            item.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                guard let self = self, let image = image as? UIImage else { return }
//                DispatchQueue.main.async {
//                    self.listImage.append(image)
//                }
//            }
//        }
//    }
//}
//
//extension ResultVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//        guard let image = info[.originalImage] as? UIImage else { return }
//
//        listImage.append(image)
//        capturedCount += 1
//
//        if let layout = layout, capturedCount < layout {
//            presentCamera()
//        }
//    }
//}
//
