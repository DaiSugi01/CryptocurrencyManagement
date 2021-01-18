//
//  UIColorHex.swift
//  NavbarAnimation
//
//  Created by Yuki Tsukada on 2021/01/13.
//

import Foundation

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let noHashHex = hex.suffix(6)
        let v = Int(noHashHex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
