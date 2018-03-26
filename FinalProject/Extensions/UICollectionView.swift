//
//  UICollectionViewExtension.swift
//  Blank Project
//
//  Created by framgia on 5/29/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

enum CollectionViewKind: String {
    case header
    case footer

    var value: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        default:
            return UICollectionElementKindSectionFooter
        }
    }
}

extension UICollectionView {

    func registerCell<T: UICollectionViewCell>(aClass: T.Type) {
        let className = String(describing: aClass)
        let nibFile = UINib(nibName: className, bundle: nil)
        register(nibFile, forCellWithReuseIdentifier: className)
    }

    func registerCell<T: UICollectionViewCell>(aClass: T.Type, kind: CollectionViewKind) {
        let className = String(describing: aClass)
        let nibFile = UINib(nibName: className, bundle: nil)
        register(nibFile, forSupplementaryViewOfKind: kind.value, withReuseIdentifier: className)
    }

    func dequeueCell<T: UICollectionViewCell> (aClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }

    func dequeueCell<T: UICollectionReusableView> (aClass: T.Type, kind: CollectionViewKind, indexPath: IndexPath) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind.value,
                                                          withReuseIdentifier: className,
                                                          for: indexPath) as? T else {
                                                            fatalError("\(className) isn't register")
        }
        return cell
    }
}
