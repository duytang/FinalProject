//
//  TabBarView.swift
//  YouTube
//
//  Created by Duy Tang on 8/29/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

enum ButtonItemType: Int {
    case home = 0
    case trending
    case favorite
    case history

    var nonSelectImage: UIImage {
        switch self {
        case .favorite:
            return #imageLiteral(resourceName: "ic_favorite")
        case .home:
            return #imageLiteral(resourceName: "ic_home")
        case .trending:
            return #imageLiteral(resourceName: "ic_trending")
        case .history:
            return #imageLiteral(resourceName: "ic_history")
        }
    }

    var selectImage: UIImage {
        switch self {
        case .favorite:
            return #imageLiteral(resourceName: "ic_selectfavorite")
        case .home:
            return #imageLiteral(resourceName: "ic_selecthome")
        case .trending:
            return #imageLiteral(resourceName: "ic_selecttrending")
        case .history:
            return #imageLiteral(resourceName: "ic_selecthistory")
        }
    }

    static func type(index: Int) -> ButtonItemType {
        switch index {
        case 0:
            return .home
        case 1:
            return .trending
        case 2:
            return .favorite
        default:
            return .history
        }
    }
}

protocol TabBarViewDelegate: class {
    func tabBarView(tabBar: TabBarView, didSelectIndex index: Int)
}

class TabBarView: UIView {
    @IBOutlet private var itemView: [UIView]!

    weak var delegate: TabBarViewDelegate?

    var index: Int = 0 {
        willSet {
            let oldview = itemView[index]
            oldview.backgroundColor = .clear

            if let imageView = oldview.findImageView(), let label = oldview.findLabel() {
                let buttonType = ButtonItemType.type(index: index)
                imageView.image = buttonType.nonSelectImage
                label.textColor = Color.categoryText
            }

            let newView = itemView[newValue]
            newView.backgroundColor = Color.navBar
            if let imageView = newView.findImageView(), let label = newView.findLabel() {
                let buttonType = ButtonItemType.type(index: newValue)
                imageView.image = buttonType.selectImage
                label.textColor = .white
            }
        }
    }

    @IBAction private func selectTabBarItem(sender: AnyObject) {
        guard let tag = sender.tag else { return }
        if tag != index {
            index = tag
            delegate?.tabBarView(tabBar: self, didSelectIndex: tag)
        }
    }
}
