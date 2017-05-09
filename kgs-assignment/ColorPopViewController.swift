//
//  ViewController.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 4/28/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit

enum ColorPopMode {
    case masking
    case cropping
}

class ColorPopViewController: UIViewController {
    @IBOutlet weak fileprivate var imageView: UIImageView!
    @IBOutlet weak var brushSlider: UISlider!
    
    private var colorPopMode: ColorPopMode = .masking
    private var taskController: TaskController!
    private var colorPopper: Popper?
    
    private var lastTouchPoint = CGPoint.zero
    private var didSwipe = false
    
    private var sourceImage: UIImage!
    
    fileprivate func setSourceImage(sourceImage: UIImage) {
        self.sourceImage = sourceImage
        
        clearImageViewChanges()
        updateAndRefreshImageView()
        
    }
    
    private var brushSize: CGSize {
        get {
            let calculatedWidth = sourceImage.size.width * CGFloat(brushSlider.value)
            return CGSize(width: calculatedWidth, height: calculatedWidth)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceImage = #imageLiteral(resourceName: "sunflower")
        imageView.isUserInteractionEnabled = false
        
        colorPopper = PopperFactory.createPopper(type: colorPopMode, withImage: sourceImage)
        taskController = TaskController(taskControllerDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateAndRefreshImageView()
    }
    
    @IBAction func popingModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            colorPopMode = .masking
            
        case 1:
            colorPopMode = .cropping
            
        default: break
        }
        
        clearImageViewChanges()
        colorPopper = PopperFactory.createPopper(type: colorPopMode, withImage: sourceImage)
        updateAndRefreshImageView()
    }
    
    @IBAction func pickImageFromGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveImageToGallery(_ sender: Any) {
        if let modifiedImage = colorPopper?.getModifiedImageFrom(imageView: imageView) {
            taskController.saveImageToPhotoLibrary(image: modifiedImage)
        } else {
            showAlert(title: "Error!", message: "Something wrong with the image.")
        }
    }
    
    @IBAction func brushSizeSliderValueChanged(_ sender: UISlider) {
        debugPrint(sender.value.description)
    }
    
    private func clearImageViewChanges() {
        colorPopper?.clearModification(imageView: imageView)
    }
    
    private func updateAndRefreshImageView() {
        colorPopper?.updateOriginalImage(newImage: sourceImage)
        colorPopper?.showImageIn(imageView: imageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didSwipe = false
        
        if let touch = touches.first {
            lastTouchPoint = touch.location(in: imageView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        didSwipe = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            colorPopper?.popColorFromGrayedImageIn(imageView: imageView, startPoint: lastTouchPoint,
                                                   endPoint: currentPoint, brushSize: brushSize)
            
            lastTouchPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !didSwipe {
            colorPopper?.popColorFromGrayedImageIn(imageView: imageView, startPoint: lastTouchPoint,
                                                   endPoint: lastTouchPoint, brushSize: brushSize)
        }
    }
    
}

extension ColorPopViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setSourceImage(sourceImage: pickedImage)
            
        } else {
            showAlert(title: "Error!", message: "Something wrong with the picked image.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ColorPopViewController: TaskControllerDelegate {
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "Saving. Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoader(completion: (() -> Swift.Void)? = nil) {
        dismiss(animated: false, completion: completion)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: false, completion: nil)
        }))
        
        hideLoader {
            self.present(alertController, animated: false)
        }
    }
    
    
}

