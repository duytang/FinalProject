//
//  RefreshControl.swift
//  Blank Project
//
//  Created by Kieu Nhi on 5/31/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

class RefreshControl: UIRefreshControl {

    override func endRefreshing() {
        let scrollView = superview as? UIScrollView
        let scrollEnabled = scrollView?.isScrollEnabled ?? true
        scrollView?.isScrollEnabled = false
        super.endRefreshing()
        scrollView?.isScrollEnabled = scrollEnabled
    }
}
