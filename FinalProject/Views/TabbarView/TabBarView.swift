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
            return #imageLiteral(resourceName: "ic-favorite")
        case .home:
            return #imageLiteral(resourceName: "ic-home")
        case .trending:
            return #imageLiteral(resourceName: "ic-trending")
        case .history:
            return #imageLiteral(resourceName: "ic-history")
        }
    }

    var selectImage: UIImage {
        switch self {
        case .favorite:
            return #imageLiteral(resourceName: "ic-favorite-select")
        case .home:
            return #imageLiteral(resourceName: "ic-home-select")
        case .trending:
            return #imageLiteral(resourceName: "ic-trending-select")
        case .history:
            return #imageLiteral(resourceName: "ic-history-select")
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

            if let imageView = oldview.findImageView(), let label = oldview.findLabel() {
                let buttonType = ButtonItemType.type(index: index)
                imageView.image = buttonType.nonSelectImage
                label.textColor = Color.categoryText
            }

            let newView = itemView[newValue]
            if let imageView = newView.findImageView(), let label = newView.findLabel() {
                let buttonType = ButtonItemType.type(index: newValue)
                imageView.image = buttonType.selectImage
                label.textColor = Color.main
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
