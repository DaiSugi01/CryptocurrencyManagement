//
//  ViewController.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/17.
//

import UIKit

class ViewController: UIViewController {
    let addCurrencyButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Add Currency", for: .normal)
        bt.setTitleColor(UIColor(hex: "#426DDC"), for: .normal)
        bt.titleLabel?.font = UIFont(name: "HelveticaNeueCyr", size: 14)
        bt.frame = CGRect(x: 261, y: 76, width: 120, height: 36)
        bt.backgroundColor = UIColor(hex: "#212A6B", alpha: 1.0)
        bt.addTarget(self, action: #selector(addCurrencyButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#010A43")
        view.addSubview(addCurrencyButton)
        NSLayoutConstraint.activate([
            addCurrencyButton.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            addCurrencyButton.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23)
        ])
    }

    
    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        present(nextView, animated: true, completion: nil)

    }

}

