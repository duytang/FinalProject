//
//  TagView.swift
//  Blank Project
//
//  Created by Kieu Nhi on 6/5/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import Foundation
import UIKit

class TagView: UIScrollView {
    var numberOfRows = 0
    var currentRow = 0
    var tags: [UILabel] = [UILabel]()
    var widdth: CGFloat = 0
    var hashtagsOffset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
    var rowHeight: CGFloat = 26 // height of rows
    var tagHorizontalPadding: CGFloat = 10.0 // padding between tags horizontally
    var tagVerticalPadding: CGFloat = 10.0 // padding between tags vertically
    var tagCombinedMargin: CGFloat = 16.0 // margin of left and right combined, text in tags are by default centered.
    var maxRow = 2
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfRows = Int(frame.height / rowHeight)
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addTag(text: String, target: AnyObject, tapAction: Selector? = nil, longPressAction: Selector? = nil, backgroundColor: UIColor = UIColor.white, textColor: UIColor = .black) {
        // instantiate label
        // you can customize your label here! but make sure everything fit. Default row height is 30.
        let label = UILabel()
        label.layer.cornerRadius = rowHeight / 2
        label.clipsToBounds = true
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.text = text
        label.font = Font.helveticaNeue.normal(ofSize: 11)
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        label.tag = tags.count
        tags.append(label)
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        // process actions
        if let tapAction = tapAction {
            let tap = UITapGestureRecognizer(target: target, action: tapAction)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
        }

        if let longPressAction = longPressAction {
            let longPress = UILongPressGestureRecognizer(target: target, action: longPressAction)
            label.addGestureRecognizer(longPress)
        }

        // calculate frame
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width + tagCombinedMargin, height: rowHeight)
        if tags.isEmpty {
            label.frame = CGRect(x: hashtagsOffset.left, y: hashtagsOffset.top, width: label.frame.width, height: label.frame.height)
            addSubview(label)

        } else {
            label.frame = generateFrameAtIndex(index: tags.count - 1, rowNumber: &currentRow)
            if currentRow < maxRow {
                addSubview(label)
                let height = label.frame.origin.y + label.frame.height + hashtagsOffset.top
                contentSize = CGSize(width: widdth, height: height)
            }
        }
    }

    private func isOutofBounds(newPoint: CGPoint, labelFrame: CGRect) {
        let bottomYLimit = newPoint.y + labelFrame.height
        if bottomYLimit > contentSize.height {
            contentSize = CGSize(width: contentSize.width, height: contentSize.height + rowHeight - tagVerticalPadding)
        }
    }

    func getNextPosition() -> CGPoint {
        return getPositionForIndex(index: tags.count - 1, rowNumber: self.currentRow)
    }

    func getPositionForIndex(index: Int, rowNumber: Int) -> CGPoint {
        if index == 0 {
            return CGPoint(x: hashtagsOffset.left, y: 0)
        }
        let y = CGFloat(rowNumber) * rowHeight
        let lastTagFrame = tags[index - 1].frame
        let x = lastTagFrame.origin.x + lastTagFrame.width + tagHorizontalPadding
        return CGPoint(x: x, y: y)
    }

    func reset() {
        for tag in tags {
            tag.removeFromSuperview()
        }
        tags = []
        currentRow = 0
        numberOfRows = 0
        self.contentSize = CGSize(width: 0, height: 0)
    }

    func removeTagWithName(name: String) {
        for (index, tag) in tags.enumerated() {
            if let text = tag.text, text == name {
                removeTagWithIndex(index: index)
            }
        }
    }

    func removeTagWithIndex(index: Int) {
        if index > tags.count - 1 {
            print("ERROR: Tag Index \(index) Out of Bounds")
            return
        }
        tags[index].removeFromSuperview()
        tags.remove(at: index)
        layoutTagsFromIndex(index: index)
    }

    private func getRowNumber(index: Int) -> Int {
        return Int((tags[index].frame.origin.y - hashtagsOffset.top) / rowHeight)
    }

    private func layoutTagsFromIndex(index: Int, animated: Bool = true) {
        if tags.isEmpty {
            return
        }

        let animation: () -> Void = {
            var rowNumber = self.getRowNumber(index: index)
            for i in index...self.tags.count - 1 {
                self.tags[i].frame = self.generateFrameAtIndex(index: i, rowNumber: &rowNumber)
            }
        }
        UIView.animate(withDuration: 0.3, animations: animation)
    }

    private func generateFrameAtIndex(index: Int, rowNumber: inout Int) -> CGRect {
        var newPoint = getPositionForIndex(index: index, rowNumber: rowNumber)
        if (newPoint.x + tags[index].frame.width) >= widdth {
            rowNumber += 1
            newPoint = CGPoint(x: self.hashtagsOffset.left, y: CGFloat(rowNumber) * rowHeight)
        }
        newPoint = CGPoint(x: newPoint.x, y: newPoint.y + CGFloat(rowNumber + 1) * hashtagsOffset.top)
        isOutofBounds(newPoint: newPoint, labelFrame: tags[index].frame)
        return CGRect(x: newPoint.x, y: newPoint.y, width: tags[index].frame.width, height: tags[index].frame.height)
    }

    func removeMultipleTagsWithIndices(indexSet: Set<Int>) {
        let sortedArray = Array(indexSet).sorted()
        for index in sortedArray {
            if index > tags.count - 1 {
                print("ERROR: Tag Index \(index) Out of Bounds")
                continue
            }
            tags[index].removeFromSuperview()
            tags.remove(at: index)
        }
        if let first = sortedArray.first {
            layoutTagsFromIndex(index: first)
        }
    }
}
