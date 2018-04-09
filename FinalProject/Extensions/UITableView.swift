//
//  UITableViewExtension.swift
//  ATMCard
//
//  Created by framgia on 5/15/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

extension UITableView {

    override open var delaysContentTouches: Bool {
        didSet {
            for view in subviews {
                if let scroll = view as? UIScrollView {
                    scroll.delaysContentTouches = delaysContentTouches
                }
                break
            }
        }
    }

    func removeHeaderTableView() {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen.bounds.width, height: CGFloat.leastNonzeroMagnitude))
    }

    func removeFooterTableView() {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen.bounds.width, height: CGFloat.leastNonzeroMagnitude))
    }

    func addEmptyView(string: String =
        "No data is currently available. Please pull down to refresh.") {
        let label = UILabel(frame: CGRect(x: 0, y: 0,
                                          width: frame.width, height: frame.height))
        label.text = string
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        backgroundView = label
        separatorStyle = .none
    }

    func removeEmptyview() {
        self.backgroundView = nil
    }

    func setAndLayoutTableHeaderView(header: UIView?) {
        guard let header = header else {
            return
        }
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0),
                                                    withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        tableHeaderView = header
    }

    func setAndLayoutTableFooterView(footer: UIView?) {
        guard let footer = footer else {
            return
        }
        footer.setNeedsLayout()
        footer.layoutIfNeeded()
        let height = footer.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0),
                                                    withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        var frame = footer.frame
        frame.size.height = height
        footer.frame = frame
        tableFooterView = footer
    }

    func scrollsToBottom(animated: Bool) {
        let section = numberOfSections - 1
        let row = numberOfRows(inSection: section) - 1
        if section < 0 || row < 0 {
            return
        }
        let path = IndexPath(row: row, section: section)
        let offset = contentOffset.y
        scrollToRow(at: path, at: .top, animated: animated)
        let delay = (animated ? 0.2 : 0.0) * Double(NSEC_PER_SEC)
        DispatchQueue.after(time: delay) {
            if self.contentOffset.y != offset {
                self.scrollsToBottom(animated: false)
            }
        }
    }

    func registerCell<T: UITableViewCell>(aClass: T.Type) {
        let className = String(describing: aClass)
        let nibFile = UINib(nibName: className, bundle: nil)
        register(nibFile, forCellReuseIdentifier: className)
    }

    func dequeueCell<T: UITableViewCell> (aClass: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }

    func dequeueCell<T: UITableViewCell> (aClass: T.Type) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: className) as? T else {
            fatalError("\(className) isn't register")
        }
        return cell
    }
}
