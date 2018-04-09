//
//  BaseTabbarController.swift
//  Blank Project
//
//  Created by framgia on 6/5/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import SnapKit

class TabbarController: UITabBarController {
    // MARK: - Property
    private let tabBarView = TabBarView.loadView(fromNib: TabBarView.self)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        view.addSubview(tabBarView)
        tabBarView.delegate = self
        tabBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(60)
        }
        tabBarView.index = 0
        configTabBar()
    }

    func configTabBar() {
        let homeVC = HomeViewController()
        let homeNavi = NavigationController(rootViewController: homeVC)

        let trendingVC = TrendingViewController()
        let trendingNavi = NavigationController(rootViewController: trendingVC)

        let favoriteVC = FavoriteViewController()
        let favoriteNavi = NavigationController(rootViewController: favoriteVC)

        let historyVC = HistoryViewController()
        let historyNavi = NavigationController(rootViewController: historyVC)

        viewControllers = [homeNavi, trendingNavi, favoriteNavi, historyNavi]
    }

}

// MARK: - Extension
extension TabbarController: TabBarViewDelegate {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int) {
        selectedIndex = index
    }
}
