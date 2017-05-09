//
//  Poppable.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 5/9/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit

protocol Popper {
    init(originalImage: UIImage)
    func updateOriginalImage(newImage: UIImage)
    func showImageIn(imageView: UIImageView)
    func popColorFromGrayedImageIn(imageView: UIImageView, startPoint: CGPoint, endPoint: CGPoint, brushSize: CGSize)
    func getModifiedImageFrom(imageView: UIImageView) -> UIImage?
    func clearModification(imageView: UIImageView)
}



extension Popper {
    func getActualPointFrom(image: UIImage, for imageView: UIImageView, basedOn touchPoint: CGPoint ) -> CGPoint? {
        if let scaleFactor = imageView.imageScaleForAspectFit {
            let viewingImageSize = CGSize(width: scaleFactor.width * image.size.width,
                                          height: scaleFactor.height * image.size.height)
            
            let xAdjustment = (imageView.frame.width - viewingImageSize.width) / 2
            let yAdjustment = (imageView.frame.height - viewingImageSize.height) / 2
            
            let percentX = (touchPoint.x - xAdjustment) / viewingImageSize.width
            let percentY = (touchPoint.y - yAdjustment) / viewingImageSize.height
            
            
            let imagePoint = CGPoint(x: image.size.width * percentX,
                                     y: image.size.height * percentY)
            
            debugPrint("image point: " + imagePoint.debugDescription)
            
            //TODO: refactor here.
            if (imagePoint.x >= 0 && imagePoint.x <= image.size.width) &&
                (imagePoint.y >= 0 && imagePoint.y <= image.size.height) {
                return imagePoint
            } else {
                return nil
            }
        }
        
        return nil
    }

}
