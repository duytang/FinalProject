//
//  FVReadMoreLabel.swift
//  Emic_User
//
//  Created by Kieu Nhi on 4/7/18.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

typealias LineIndexTuple = (line: CTLine, index: Int)

import UIKit

/**
 * The delegate of FVReadMoreLabel.
 */
public protocol FVReadMoreLabelDelegate: NSObjectProtocol {
    func willExpandLabel(_ label: FVReadMoreLabel)
    func didExpandLabel(_ label: FVReadMoreLabel)
    func shouldExpandLabel(_ label: FVReadMoreLabel) -> Bool

    func willCollapseLabel(_ label: FVReadMoreLabel)
    func didCollapseLabel(_ label: FVReadMoreLabel)
    func shouldCollapseLabel(_ label: FVReadMoreLabel) -> Bool
}

extension FVReadMoreLabelDelegate {
    public func shouldExpandLabel(_ label: FVReadMoreLabel) -> Bool {
        return Static.DefaultShouldExpandValue
    }
    public func shouldCollapseLabel(_ label: FVReadMoreLabel) -> Bool {
        return Static.DefaultShouldCollapseValue
    }
    public func willCollapseLabel(_ label: FVReadMoreLabel) {}
    public func didCollapseLabel(_ label: FVReadMoreLabel) {}
}

private struct Static {
    fileprivate static let DefaultShouldExpandValue: Bool = true
    fileprivate static let DefaultShouldCollapseValue: Bool = false
}

/**
 * FVReadMoreLabel
 */
open class FVReadMoreLabel: UILabel {

    /// The delegate of FVReadMoreLabel
    weak open var delegate: FVReadMoreLabelDelegate?

    /// Set 'true' if the label should be collapsed or 'false' for expanded.
    @IBInspectable var collapsed: Bool = true {
        didSet {
            super.attributedText = (collapsed) ? self.collapsedText : self.expandedText
            super.numberOfLines = (collapsed) ? self.collapsedNumberOfLines : 0
        }
    }

    /// Set the link name (and attributes) that is shown when collapsed.
    /// The default value is "More". Cannot be nil.
    var collapsedAttributedLink: NSAttributedString! {
        didSet {
            self.collapsedAttributedLink = collapsedAttributedLink.copyWithAddedFontAttribute(fontText)
        }
    }

    /// Set the link name (and attributes) that is shown when expanded.
    /// The default value is "Less". Can be nil.
    var expandedAttributedLink: NSAttributedString?

    /// Set the ellipsis that appears just after the text and before the link.
    /// The default value is "...". Can be nil.
    open var ellipsis: NSAttributedString? {
        didSet {
            self.ellipsis = ellipsis?.copyWithAddedFontAttribute(fontText)
        }
    }

    //
    // MARK: Private
    //

    fileprivate var expandedText: NSAttributedString?
    fileprivate var collapsedText: NSAttributedString?
    fileprivate var linkHighlighted: Bool = false
    fileprivate let touchSize = CGSize(width: 44, height: 44)
    fileprivate var linkRect: CGRect?
    fileprivate var collapsedNumberOfLines: NSInteger = 0
    fileprivate var expandedLinkPosition: NSTextAlignment?
    fileprivate var fontText = UIFont.systemFont(ofSize: 14)

    open override var numberOfLines: NSInteger {
        didSet {
            collapsedNumberOfLines = numberOfLines
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    init() {
        super.init(frame: .zero)
    }

    fileprivate func commonInit() {
        isUserInteractionEnabled = true
        lineBreakMode = .byClipping
        numberOfLines = 3
        expandedAttributedLink = nil

        var attributedString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.scaling
        paragraphStyle.alignment = .justified
        attributedString = NSMutableAttributedString(string: "Read more")
        attributedString.setAttributes([.font: fontText, .foregroundColor: Color.main],
                                       range: NSRange(location: 0, length: attributedString.length))
        collapsedAttributedLink = attributedString
        ellipsis = NSAttributedString(string: "...",
                                      attributes: [.font: fontText, .foregroundColor: Color.main])
    }

    open override var text: String? {
        set(text) {
            if let text = text {
                expandedText = getExpandedTextForText(text, link: expandedAttributedLink)?.copyWithAddedFontAttribute(fontText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 10.scaling
                paragraphStyle.alignment = .justified
                self.attributedText = NSMutableAttributedString(string: text,
                                                                attributes: [.font: fontText, .paragraphStyle: paragraphStyle])
            } else {
                attributedText = nil
            }
        }
        get {
            return attributedText?.string
        }
    }

    open override var attributedText: NSAttributedString? {
        set(attributedText) {
            if let attributedText = attributedText, attributedText.length > 0 {
                self.collapsedText = getCollapsedTextForText(attributedText, link: (linkHighlighted) ? collapsedAttributedLink.copyWithHighlightedColor() : collapsedAttributedLink)
                super.attributedText = collapsed ? collapsedText : expandedText
            } else {
                super.attributedText = nil
            }
        }
        get {
            return super.attributedText
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        attributedText = expandedText
    }

    fileprivate func textWithLinkReplacement(_ line: CTLine, text: NSAttributedString, linkName: NSAttributedString) -> NSAttributedString {
        let lineText = text.textForLine(line)
        var lineTextWithLink = lineText
        let range = NSRange(location: 0, length: lineText.length >= 16 ? lineText.length - 16 : 0)
        let tempLineTextWithLastWordRemoved = lineText.attributedSubstring(from: range)
        let tempLineTextWithAddedLink = NSMutableAttributedString(attributedString: tempLineTextWithLastWordRemoved)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.scaling
        paragraphStyle.alignment = .justified

        (lineText.string as NSString).enumerateSubstrings(in: NSRange(location: 0, length: lineText.length), options: [.byWords, .reverse]) { (_, subRange, _, stop) -> Void in

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10.scaling
            paragraphStyle.alignment = .justified

            let lineTextWithLastWordRemoved = lineText.attributedSubstring(from: NSRange(location: 0, length: subRange.location))
            let lineTextWithAddedLink = NSMutableAttributedString(attributedString: lineTextWithLastWordRemoved)

            if let ellipsis = self.ellipsis {
                lineTextWithAddedLink.append(ellipsis)
            }
            lineTextWithAddedLink.append(linkName)

            let fits = self.textFitsWidth(lineTextWithAddedLink)
            if fits {
                tempLineTextWithAddedLink.append(lineTextWithAddedLink)
                lineTextWithLink = tempLineTextWithAddedLink

                let wordRect = linkName.boundingRectForWidth(self.frame.size.width)
                self.linkRect = CGRect(x: self.frame.halfWidth,
                                       y: self.fontText.lineHeight * CGFloat(self.collapsedNumberOfLines - 2),
                                       width: self.frame.halfWidth,
                                       height: wordRect.size.height * 3)
                stop.pointee = true
            }
        }
        return lineTextWithLink
    }
    fileprivate func getCollapsedTextForText(_ text: NSAttributedString?, link: NSAttributedString) -> NSAttributedString? {
        guard let text = text else { return nil }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.scaling
        paragraphStyle.alignment = .justified
        let lines = text.linesForWidth(frame.size.width)
        if collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count {
            let lastLineRef = lines[collapsedNumberOfLines - 1] as CTLine
            let modifiedLastLineText = textWithLinkReplacement(lastLineRef, text: text, linkName: link)
            let collapsedLines = NSMutableAttributedString()
            if collapsedNumberOfLines >= 2 {
                for index in 0...collapsedNumberOfLines - 2 {
                    collapsedLines.append(text.textForLine(lines[index]))
                }
            } else {
                collapsedLines.append(text.textForLine(lines[0]))
            }
            collapsedLines.append(modifiedLastLineText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10.scaling
            paragraphStyle.alignment = .justified
            return collapsedLines
        }
        return text
    }

    fileprivate func findLineWithWords(lastLine: CTLine, text: NSAttributedString, lines: [CTLine]) -> LineIndexTuple {
        var lastLineRef = lastLine
        var lastLineIndex = collapsedNumberOfLines - 1
        var lineWords = spiltInToWords(str: text.textForLine(lastLineRef).string as NSString)
        while lineWords.count < 2 && lastLineIndex > 0 {
            lastLineIndex -= 1
            lastLineRef = lines[lastLineIndex] as CTLine
            lineWords = spiltInToWords(str: text.textForLine(lastLineRef).string as NSString)
        }
        return (lastLineRef, lastLineIndex)
    }

    fileprivate func spiltInToWords(str: NSString) -> [String] {
        var strings: [String] = []
        str.enumerateSubstrings(in: NSRange(location: 0, length: str.length),
                                options: [.byWords, .reverse]) { (word, _, _, stop) -> Void in
            if let unwrappedWord = word {
                strings.append(unwrappedWord)
            }
            if strings.count > 1 { stop.pointee = true }
        }
        return strings
    }

    fileprivate func textFitsWidth(_ text: NSAttributedString) -> Bool {
        return (text.boundingRectForWidth(frame.size.width).size.height <= fontText.lineHeight) as Bool
    }

    fileprivate func textWillBeTruncated(_ text: NSAttributedString) -> Bool {
        let lines = text.linesForWidth(frame.size.width)
        return collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count
    }

    // MARK: Touch Handling
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: true)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: false)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !collapsed {
            if shouldCollapse() {
                delegate?.willCollapseLabel(self)
                collapsed = true
                delegate?.didCollapseLabel(self)
                linkHighlighted = isHighlighted
                setNeedsDisplay()
            }
        } else {
            if shouldExpand() && setLinkHighlighted(touches, event: event, highlighted: false) {
                delegate?.willExpandLabel(self)
                collapsed = false
                delegate?.didExpandLabel(self)
            }
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: false)
    }

    @discardableResult fileprivate func setLinkHighlighted(_ touches: Set<UITouch>?, event: UIEvent?, highlighted: Bool) -> Bool {
        let touch = event?.allTouches?.first
        let location = touch?.location(in: self)
        if let location = location, let linkRect = linkRect {
            let finger = CGRect(x: location.x - touchSize.width / 2,
                                y: location.y - touchSize.height / 2,
                                width: touchSize.width,
                                height: touchSize.height)
            if collapsed && finger.intersects(linkRect) {
                linkHighlighted = highlighted
                setNeedsDisplay()
                return true
            }
        }
        return false
    }

    fileprivate func shouldCollapse() -> Bool {
        return delegate?.shouldCollapseLabel(self) ?? Static.DefaultShouldCollapseValue
    }

    fileprivate func shouldExpand() -> Bool {
        return delegate?.shouldExpandLabel(self) ?? Static.DefaultShouldExpandValue
    }
}

extension FVReadMoreLabel {
    fileprivate func getExpandedTextForText(_ text: String?, link: NSAttributedString?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let expandedText = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.scaling
        paragraphStyle.alignment = .justified
        expandedText.append(NSAttributedString(string: "\(text)",
            attributes: [.font: fontText, .paragraphStyle: paragraphStyle]))
        if let link = link, textWillBeTruncated(expandedText) {
            let spaceOrNewLine = expandedLinkPosition == nil ? "  " : "\n"
            expandedText.append(NSMutableAttributedString(string: "\(spaceOrNewLine)\(link.string)",
                attributes: link.attributes(at: 0, effectiveRange: nil)))
        }

        return expandedText
    }
}

// MARK: Convenience Methods

private extension NSAttributedString {
    func hasFontAttribute() -> Bool {
        guard !self.string.isEmpty else { return false }
        let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
        return font != nil
    }

    func copyWithAddedFontAttribute(_ font: UIFont) -> NSAttributedString {
        if !hasFontAttribute() {
            let copy = NSMutableAttributedString(attributedString: self)
            copy.addAttribute(.font, value: font,
                              range: NSRange(location: 0, length: copy.length))
            return copy
        }
        guard let att = self.copy() as? NSAttributedString else { fatalError() }
        return att
    }

    func copyWithHighlightedColor() -> NSAttributedString {
        let alphaComponent = CGFloat(0.5)
        let baseColor: UIColor? = self.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        var color: UIColor = .black
        if let baseColor = baseColor {
            color = baseColor.withAlphaComponent(alphaComponent)
        } else {
            color = UIColor.black.withAlphaComponent(alphaComponent)
        }
        let highlightedCopy = NSMutableAttributedString(attributedString: self)
        highlightedCopy.removeAttribute(.foregroundColor,
                                        range: NSRange(location: 0, length: highlightedCopy.length))
        highlightedCopy.addAttribute(.foregroundColor,
                                     value: color, range: NSRange(location: 0, length: highlightedCopy.length))
        return highlightedCopy
    }

    func linesForWidth(_ width: CGFloat) -> [CTLine] {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        let frameSetterRef: CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)

        let linesNS: NSArray = CTFrameGetLines(frameRef)
        let linesAO: [AnyObject] = linesNS as [AnyObject]
        guard let lines: [CTLine] = linesAO as? [CTLine] else { return [] }

        return lines
    }

    func textForLine(_ lineRef: CTLine) -> NSAttributedString {
        let lineRangeRef: CFRange = CTLineGetStringRange(lineRef)
        let range = NSRange(location: lineRangeRef.location, length: lineRangeRef.length)
        return self.attributedSubstring(from: range)
    }

    func boundingRectForWidth(_ width: CGFloat) -> CGRect {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                 options: .usesLineFragmentOrigin, context: nil)
    }
}
