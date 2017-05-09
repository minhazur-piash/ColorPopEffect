//
//  ImageUtils.swift
//  kgs-assignment
//
//  Created by Minhazur Rahman on 4/29/17.
//  Copyright © 2017 MinhazHome. All rights reserved.
//

import UIKit

class ImageUtils {
    
    /**
     Calculate point based on touch point and given size. If point is smaller then size, size has no impact on return value.
     
     - parameter touchPoint: touched point
     - parameter size: size
     
     - returns: calculated point
     */
    class func getCalculatedPointBasedOn(touchPoint: CGPoint, size: CGSize) -> CGPoint {
        var point: CGPoint
        
        if touchPoint.x < size.width || touchPoint.y < size.height {
            point = CGPoint(x: touchPoint.x, y: touchPoint.y)
            
        } else {
            point = CGPoint(x: touchPoint.x - size.width/2,
                            y: touchPoint.y - size.height/2)
        }
        
        return point
    }
    
    class func getCalculatedRectBasedOn(touchPoint: CGPoint, size: CGSize) -> CGRect {
        let calculatedPoint = getCalculatedPointBasedOn(touchPoint: touchPoint, size: size)
        return CGRect(origin: calculatedPoint, size: size)
    }
    
    
    /**
     Get colored part of given image.
     
     - parameter image: Source image, from which color part will be taken.
     - parameter rect: rectangular area to take from given image
     
     - returns: colored image cropped from given image.
     */
    class func getColorImageFrom(image: UIImage, rect: CGRect) -> UIImage? {
        let croppedImage = ImageUtils.cropImage(image: image, toRect: rect)
        
        return croppedImage
    }
    
    
    class func convertedToGrayScale(image: UIImage) -> UIImage {
        let imageRect =  CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let imageContext = CGContext(data: nil, width: Int(width), height: Int(height),
                                     bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace,
                                     bitmapInfo: bitmapInfo.rawValue)
        
        imageContext?.draw(image.cgImage!, in: imageRect)
        
        let imageRef = imageContext!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }
    
    class func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage? {
        var maskedImage: UIImage?
        
        let maskRef = maskImage.cgImage
        
        let mask = CGImage(
            maskWidth: maskRef!.width,
            height: maskRef!.height,
            bitsPerComponent: maskRef!.bitsPerComponent,
            bitsPerPixel: maskRef!.bitsPerPixel,
            bytesPerRow: maskRef!.bytesPerRow,
            provider: maskRef!.dataProvider!,
            decode: nil,
            shouldInterpolate: false)
        
        if let mask = mask, let masked = image.cgImage?.masking(mask) {
            maskedImage = UIImage(cgImage: masked)
        }
        
        return maskedImage
    }
    
    class func clipToMask(image: UIImage, withMask maskImage: UIImage) -> UIImage {
        let rct = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(rct.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: rct, mask: maskImage.cgImage!)
        context?.fill(rct)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     Draw a line in a image from the start point to end point using line color and width.
     */
    class func drawLineIn(image: UIImage, startPoint: CGPoint, endPoint: CGPoint, lineColor: UIColor, lineWidth: CGFloat) -> UIImage? {
        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()
        
        image.draw(in: CGRect(x: 0, y: 0,
                               width: imageSize.width,
                               height: imageSize.height))
        
        context?.move(to: startPoint)
        context?.addLine(to: endPoint)
        context?.setLineCap(.round)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor.cgColor)
        context?.setBlendMode(.clear)     
        context?.strokePath()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    /**
     Place second image on first image at given point and returns the new image.
     */
    class func getMixedImg(image1: UIImage, image2: UIImage, point: CGPoint, image2alpha: CGFloat = 1.0) -> UIImage {
        let firstImageSize = CGSize(width: image1.size.width, height: image1.size.height)
        
        UIGraphicsBeginImageContext(firstImageSize)
        
        image1.draw(in: CGRect(x: 0, y: 0,
                               width: firstImageSize.width,
                               height: firstImageSize.height))
        
        let secondImageRect = CGRect(x: point.x, y: point.y,
                                     width: image2.size.width,
                                     height: image2.size.height)
        
        image2.draw(in: secondImageRect, blendMode: .copy, alpha: image2alpha)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    /**
     Create single image from two given images.
     */

    class func getMixedImage(image1: UIImage, image2: UIImage) -> UIImage {
        let firstImageSize = CGSize(width: image1.size.width, height: image1.size.height)
        
        UIGraphicsBeginImageContext(firstImageSize)
        
        image1.draw(in: CGRect(x: 0, y: 0,
                               width: firstImageSize.width,
                               height: firstImageSize.height))
        
        let secondImageRect = CGRect(x: 0, y: 0,
                                     width: image2.size.width,
                                     height: image2.size.height)
        
        image2.draw(in: secondImageRect, blendMode: .sourceAtop, alpha: 1.0)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    class func cropImage(image: UIImage, toRect: CGRect) -> UIImage? {
        var croppedImage: UIImage?
        
        let cgImage = image.cgImage
        let croppedCgImage = cgImage?.cropping(to: toRect)
        if let croppedCgImg = croppedCgImage {
            croppedImage = UIImage(cgImage: croppedCgImg)
        }
        return croppedImage
    }
    
    /**
     Get combined image from view layer's content.
     - parameter view: view to take image from.
     - returns: combined image from view layer's content
     */
    class func getLayerImageFrom(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
}

extension UIImageView {
    
    var imageScaleForAspectFit: CGSize? {
        if let image = self.image {
            let sx = Double(self.frame.size.width / image.size.width)
            let sy = Double(self.frame.size.height / image.size.height)
            
            if self.contentMode == .scaleAspectFit {
                let limitingFactor = fmin(sx, sy)
                return CGSize (width: limitingFactor, height: limitingFactor)
                
            }
        }
        return nil
    }
}
