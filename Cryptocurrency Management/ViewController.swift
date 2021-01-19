//
//  ViewController.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/17.
//

import UIKit

class ViewController: UIViewController {
    let addCurrencyButton: UIButton = UIButton()
//    var addCurrencyButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "#010A43")
        createAddCurrencyButton()
    }

    
    func createAddCurrencyButton() {
//        addCurrencyButton = {
//            let bt = UIButton()
//            bt.translatesAutoresizingMaskIntoConstraints = false
//            bt.setTitleColor(UIColor(hex: "#426DDC"), for: .normal)
//            bt.titleLabel?.font = UIFont(name: "HelveticaNeueCyr", size: 14)
//            bt.frame = CGRect(x: 261, y: 76, width: 120, height: 36)
//            bt.backgroundColor = UIColor(hex: "#212A6B", alpha: 1.0)
//            bt.addTarget(self, action: #selector(self.addCurrencyButtonTapped(_:)), for: .touchUpInside)
//            bt.addTarget(self, action: #selector(self.addCurrencyButtonTapped(_:)), for: .touchUpInside)
//            self.view.addSubview(bt)
//            return bt
//        }()
        
        
        addCurrencyButton.setTitle("Add Currency", for: .normal)
        addCurrencyButton.setTitleColor(UIColor(hex: "#426DDC"), for: .normal)
        addCurrencyButton.titleLabel?.font = UIFont(name: "HelveticaNeueCyr", size: 14)
        addCurrencyButton.frame = CGRect(x: 261, y: 76, width: 120, height: 36)
        addCurrencyButton.backgroundColor = UIColor(hex: "#212A6B", alpha: 1.0)
        addCurrencyButton.addTarget(self, action: #selector(self.addCurrencyButtonTapped(_:)), for: .touchUpInside)

        self.view.addSubview(addCurrencyButton)
    }
    
    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        present(nextView, animated: true, completion: nil)

    }

}

