//
//  BaseTabbarController.swift
//  Blank Project
//
//  Created by Kieu Nhi on 6/5/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
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
        let homeNavi = NavigationController(rootViewController: HomeViewController())
        let trendingNavi = NavigationController(rootViewController: TrendingViewController())
        let favoriteNavi = NavigationController(rootViewController: FavoriteViewController())
        let historyNavi = NavigationController(rootViewController: HistoryViewController())
        setViewControllers([homeNavi, trendingNavi, favoriteNavi, historyNavi], animated: true)
        viewControllers = [homeNavi, trendingNavi, favoriteNavi, historyNavi]
    }

}

// MARK: - Extension
extension TabbarController: TabBarViewDelegate {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int) {
        selectedIndex = index
    }
}
