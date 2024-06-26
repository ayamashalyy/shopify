//
//  Color.swift
//  Shopify
//
//  Created by aya on 03/06/2024.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

class BadgeView: UILabel {
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = .white
        self.backgroundColor = color
        self.font = UIFont.boldSystemFont(ofSize: 12)
        self.textAlignment = .center
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.sizeToFit()
        self.frame.size = CGSize(width: self.frame.size.width + 8, height: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIBarButtonItem {
    private var badgeViewTag: Int { return 999 }

    func addBadge(text: String, color: UIColor) {
        removeBadge()
        guard let customView = self.customView else {
            return
        }

        let badgeView = BadgeView(text: text, color: color)
        badgeView.tag = badgeViewTag

        let badgeX = customView.frame.size.width - badgeView.frame.size.width - 4
        let badgeY = customView.frame.size.height / 10
        badgeView.frame.origin = CGPoint(x: badgeX, y: badgeY)

        customView.addSubview(badgeView)
    }

    func removeBadge() {
        guard let customView = self.customView else {
            return
        }
        customView.subviews.forEach { view in
            if view is BadgeView {
                view.removeFromSuperview()
            }
        }
    }
}
