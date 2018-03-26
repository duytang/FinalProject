//
//  PullTableView.swift
//  Blank Project
//
//  Created by framgia on 6/5/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class PullTableView: UITableView {

    var startRefresh: ((RefreshControl) -> Void)?
    var endRefresh: ((RefreshControl) -> Void)?
    var setupRefresh: ((RefreshControl) -> Void)?

    var refreshControlView: RefreshControl!
    var isRefresh: Bool = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        refreshControlView = RefreshControl()
        refreshControlView.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        setupRefresh?(refreshControlView)
    }

    @objc func startRefreshing() {
        refreshControlView.beginRefreshing()
        startRefresh?(refreshControlView)
        isRefresh = true
    }

    func endRefreshing() {
        refreshControlView.endRefreshing()
        endRefresh?(refreshControlView)
        isRefresh = false
    }
}
