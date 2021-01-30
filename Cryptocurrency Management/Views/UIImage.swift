//
//  UIImage.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/29.
//
//  usage
//  let image:UIImage = UIImage(url: "https://....")

import Foundation

import UIKit

extension UIImage {
    public convenience init?(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
