//
//  UIImageExtension.swift
//  Blank Project
//
//  Created by framgia on 5/25/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UIImage {
    
    func getMainColor() -> UIColor {
        var maxRepeatedColor = UIColor.lightGray

        let image = self.resizeImage(CGSize(width: 2, height: 2))

        let cgImage = image.cgImage!
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)

        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue

        if let ctx = CGContext.init(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) {

            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

            let data = ctx.data?.assumingMemoryBound(to: UInt8.self)

            let imageColors = NSCountedSet(capacity: width * height)

            for x in 0..<width {
                for y in 0..<height  {
                    let pixel = ((width * y) + x) * bytesPerPixel

                    let color = UIColor(red: CGFloat(data![pixel + 1])/255,
                                        green: CGFloat(data![pixel + 2])/255,
                                        blue: CGFloat(data![pixel + 3])/255,
                                        alpha: 1)

                    var isDistinct = false

                    for colr in imageColors {
                        if color.isDistinct(compare: (colr as! UIColor)) {
                            imageColors.add(colr)
                            isDistinct = true
                            break
                        }
                    }

                    if !isDistinct {
                        imageColors.add(color)
                    }
                }
            }

            var maxRepeated = 0

            for c in imageColors.allObjects {
                let repeatCount = imageColors.count(for: c)

                if repeatCount > maxRepeated {
                    maxRepeated = repeatCount
                    maxRepeatedColor = c as! UIColor
                }
            }

        }
        return maxRepeatedColor
    }

    func resizeImage(_ size: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }

    func rotate(degrees: CGFloat) -> UIImage {
        let size = self.size

        UIGraphicsBeginImageContext(size)

        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)

        bitmap.draw(self.cgImage!, in: CGRect(origin: origin, size: size))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func rotate(angle: CGFloat) -> UIImage {
        let size = self.size

        UIGraphicsBeginImageContext(size)

        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: angle)
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)

        bitmap.draw(self.cgImage!, in: CGRect(origin: origin, size: size))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
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
    
        return scaledImage!
    }


}
