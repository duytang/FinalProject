//
//  UIImageExtension.swift
//  Blank Project
//
//  Created by framgia on 5/22/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import Haneke
import CoreGraphics

extension UIImageView {

    func setThumnailFormat() {
        var format = HNKCache.shared().formats["thumbnail"] as? HNKCacheFormat
        if format == nil {
            format = HNKCacheFormat(name: "thumbnail")
            guard let format = format else { return }
            format.scaleMode = HNKScaleMode.aspectFill
            format.compressionQuality = 0.5
            format.diskCapacity = UInt64(2 * 1_024 * 1_024) // 2MB
            format.preloadPolicy = HNKPreloadPolicy.lastSession
            hnk_cacheFormat = format
        }
    }

    func downloadImage(fromURL string: String, placeHolder: UIImage, completionHandler: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: string) else {
            return
        }
        if let completionHandler = completionHandler {
            hnk_setImage(from: url, placeholder: placeHolder, success: completionHandler, failure: nil)
        } else {
            hnk_setImage(from: url, placeholder: placeHolder)
        }
    }

    func downloadImage(fromURL string: String, completionHandler: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: string) else {
            return
        }
        if let completionHandler = completionHandler {
            hnk_setImage(from: url, placeholder: UIImage(), success: completionHandler, failure: nil)
        } else {
            hnk_setImage(from: url)
        }
    }

}
