//
//  UIImageExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/25/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

extension UIImage {

    func resizeImage(_ size: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let resizeImage = resizeImage {
            return resizeImage
        } else {
            return UIImage()
        }
    }

    func rotate(degrees: CGFloat) -> UIImage {
        let size = self.size

        UIGraphicsBeginImageContext(size)
        guard let bitmap: CGContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        guard let cgImage = self.cgImage else { return UIImage() }
        bitmap.draw(cgImage, in: CGRect(origin: origin, size: size))

        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }

    func rotate(angle: CGFloat) -> UIImage {
        let size = self.size

        UIGraphicsBeginImageContext(size)

        guard let bitmap: CGContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: angle)
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        guard let cgImage = self.cgImage else { return UIImage() }
        bitmap.draw(cgImage, in: CGRect(origin: origin, size: size))

        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }

    func scaleToSize(newSize: CGSize, aspectFill: Bool = false) -> UIImage {
        let scaleFactorWidth = newSize.width / size.width
        let scaleFactorHeight = newSize.height / size.height
        let scaleFactor = aspectFill ? max(scaleFactorWidth, scaleFactorHeight) : min(scaleFactorWidth, scaleFactorHeight)

        var scaledSize = size
        scaledSize.width *= scaleFactor
        scaledSize.height *= scaleFactor

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, UIScreen.main.scale)
        let scaledImageRect = CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let scaledImage = scaledImage {
            return scaledImage
        } else {
            return UIImage()
        }
    }
}
