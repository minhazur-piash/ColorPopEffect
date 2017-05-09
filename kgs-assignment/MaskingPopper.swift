//
//  MaskingPopper.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 5/9/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit

class MaskingPopper: Popper {
    private var originalImage: UIImage
    private var grayedImage: UIImage
    private var maskedImage: UIImage?
    private var grayedLayer = CALayer()
    
    private let transparentColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
    
    required init(originalImage: UIImage) {
        self.originalImage = originalImage
        self.grayedImage = ImageUtils.convertedToGrayScale(image: self.originalImage) 
    }
    
    func updateOriginalImage(newImage: UIImage) {
        self.originalImage = newImage
        self.grayedImage = ImageUtils.convertedToGrayScale(image: self.originalImage)
    }
    
    public func clearModification(imageView: UIImageView) {
//        imageView.image = nil
        grayedLayer.mask = nil
        maskedImage = nil
        imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    public func showImageIn(imageView: UIImageView) {
        imageView.image = originalImage
        
        showGrayedImageUsingSubLayer(imageView: imageView)
    }
    
    private func showGrayedImageUsingSubLayer(imageView: UIImageView) {
        grayedLayer.drawsAsynchronously = true
        grayedLayer.contentsGravity = kCAGravityResizeAspect
        grayedLayer.frame = imageView.bounds
        grayedLayer.contentsScale = 1.0
        grayedLayer.contents = grayedImage.cgImage
        grayedLayer.mask = nil
        
        imageView.layer.addSublayer(grayedLayer)
    }

    
    public func popColorFromGrayedImageIn(imageView: UIImageView, startPoint: CGPoint, endPoint: CGPoint, brushSize: CGSize) {
        
        if let actualStartPointInImage = getActualPointFrom(image: grayedImage, for: imageView, basedOn: startPoint),
            let actualEndPointInImage = getActualPointFrom(image: grayedImage, for: imageView, basedOn: endPoint) {
            
            if maskedImage == nil {
                maskedImage = grayedImage
            }
            maskedImage = ImageUtils.drawLineIn(image: maskedImage!,
                                                startPoint: actualStartPointInImage,
                                                endPoint: actualEndPointInImage,
                                                lineColor: transparentColor,
                                                lineWidth: brushSize.width)
            
            grayedLayer.contents = maskedImage?.cgImage
        }
    }
    
    public func getModifiedImageFrom(imageView: UIImageView) -> UIImage? {
        if let maskedImage = maskedImage {
            return ImageUtils.getMixedImage(image1: originalImage, image2: maskedImage)
        } else {
            return ImageUtils.getLayerImageFrom(view: imageView)
        }
    }

}
