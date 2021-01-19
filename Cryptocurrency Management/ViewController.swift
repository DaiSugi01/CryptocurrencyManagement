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
        bt.addTarget(self, action: #selector(addCurrencyTapped(_:)), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addCurrencyButton)
        addCurrencyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addCurrencyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func addCurrencyTapped(_ semder: UIButton) {
        let addCurrencyVC = AddCurrencyViewController()
        present(addCurrencyVC, animated: true, completion: nil)
    }

}

