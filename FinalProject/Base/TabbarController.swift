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
    }

    func configTabBar() {
        let homeVC = HomeViewController()
        let homeNavi = NavigationController(rootViewController: homeVC)
        homeNavi.setAttributeForNavigation(title: "Home", image: #imageLiteral(resourceName: "ic_home"))

        let trendingVC = TrendingViewController()
        let trendingNavi = NavigationController(rootViewController: trendingVC)
        trendingNavi.setAttributeForNavigation(title: "Trending", image: #imageLiteral(resourceName: "ic_trending"))

        let favoriteVC = FavoriteViewController()
        let favoriteNavi = NavigationController(rootViewController: favoriteVC)
        favoriteNavi.setAttributeForNavigation(title: "Favorite", image: #imageLiteral(resourceName: "ic_favorite"))

        let playListVC = PlayListViewController()
        let playListNavi = NavigationController(rootViewController: playListVC)
        playListNavi.setAttributeForNavigation(title: "PlayList", image: #imageLiteral(resourceName: "ic_chanel"))

        let historyVC = HistoryViewController()
        let historyNavi = NavigationController(rootViewController: historyVC)
        historyNavi.setAttributeForNavigation(title: "History", image: #imageLiteral(resourceName: "ic_history"))

        viewControllers = [homeNavi, trendingNavi, favoriteNavi, playListNavi, historyNavi]
    }

}

// MARK: - Extension
extension TabbarController: TabBarViewDelegate {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int) {
        selectedIndex = index
    }
}
