//
//  CroppingPopper.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 5/9/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit

class CroppingPopper: Popper {
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
        imageView.image = nil
    }
    
    public func showImageIn(imageView: UIImageView) {
        imageView.image = grayedImage
    }
      
    public func popColorFromGrayedImageIn(imageView: UIImageView, startPoint: CGPoint, endPoint: CGPoint, brushSize: CGSize) {
        if let actualEndPointInImage = getActualPointFrom(image: grayedImage, for: imageView, basedOn: startPoint) {
            let calculatedRect = ImageUtils.getCalculatedRectBasedOn(touchPoint: actualEndPointInImage, size: brushSize)
            
            if let grayedImage = imageView.image,
                let coloredImage = ImageUtils.getColorImageFrom(image: originalImage, rect: calculatedRect) {
                
                let mixedImage = ImageUtils.getMixedImg(image1: grayedImage, image2: coloredImage, point: calculatedRect.origin)
                imageView.image = mixedImage
            }
        }
    }
    
    public func getModifiedImageFrom(imageView: UIImageView) -> UIImage? {
        return imageView.image
    }
    
    
    
}
