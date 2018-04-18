//
//  UIImageExtension.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/22/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit
import Kingfisher
import CoreGraphics

extension UIImageView {
    func downloadImage(fromURL string: String, placeHolder: UIImage, completionHandler: ((UIImage?) -> Void)? = nil) {
        guard let url = string.url else {
            return
        }

        let resource = ImageResource(downloadURL: url as URL)
        if let completionHandler = completionHandler {
            kf.setImage(with: resource, placeholder: placeHolder, options: [], completionHandler: { (image, _, _, _) in
                completionHandler(image)
            })
        } else {
            kf.setImage(with: resource, placeholder: placeHolder)
        }
    }

    func downloadImage(fromURL string: String, completionHandler: ((UIImage?) -> Void)? = nil) {
        guard let url = string.url else {
            return
        }

        let resource = ImageResource(downloadURL: url as URL)
        if let completionHandler = completionHandler {
            kf.setImage(with: resource, options: [], completionHandler: { (image, _, _, _) in
                completionHandler(image)
            })
        } else {
            kf.setImage(with: resource)
        }
    }
}
