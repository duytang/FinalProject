//
//  BaseXibView.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/22/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

class BaseNibView: UIView {
    private var nibView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nibView = UIView.loadXibView(fromNib: type(of: self), owner: self)
        addSubview(nibView)
        self.nibView = nibView
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        nibView.frame = bounds
    }
}
