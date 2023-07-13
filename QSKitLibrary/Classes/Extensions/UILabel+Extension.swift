//
//  UILabel+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2022/3/18.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    /// UILabel根据文字的需要的高度
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: CGFloat.greatestFiniteMagnitude)
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

    var requiredWidth: CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: CGFloat.greatestFiniteMagnitude,
            height: frame.height)
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.width
    }

    /// UILabel根据文字实际的行数
    var lines: Int {
        return Int(requiredHeight / font.lineHeight)
    }


    func setText(_ str: String, _ space: CGFloat? = nil) {
        let font = self.font ?? UIFont.systemFont(ofSize: 12)
        let color = self.textColor ?? UIColor.textMainBlack
        let attrStr = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        if let lineSpace = space {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attrStr.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: str.count)
            )
        }
        self.attributedText = attrStr
    }
    func getFirstSecondLineString() -> [String] {
        if let text = self.attributedText {
            let path = CGPath(rect: CGRect(x: 0, y: 0, width: self.bounds.width, height: 40), transform: nil)
            let framesetter = CTFramesetterCreateWithAttributedString(text)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, text.length), path, nil)
            let lines = CTFrameGetLines(frame)
            let numberOfLines = CFArrayGetCount(lines)
            var lineOrigins = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: numberOfLines)
            CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
            var results: [String] = []
            if numberOfLines > 1 {
                for index in 0...1 {
                    let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, index), to: CTLine.self)
                    let lineRef: CTLine = line
                    let lineRange: CFRange = CTLineGetStringRange(lineRef)
                    let range = NSRange(location: lineRange.location, length: lineRange.length)
                    let lineString = (attributedText?.attributedSubstring(from: range))
                    if let str = lineString?.string {
                        results.append(str)
                    }
                }
                return results
            }
            return results
        } else {
            return []
        }
    }
}
