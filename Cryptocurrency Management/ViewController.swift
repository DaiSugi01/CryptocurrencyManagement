//
//  ViewController.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/17.
//
import UIKit
private enum State {
    case closed
    case open
}
extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

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
    let cellId = "currencyCellId"
    private var currentState: State = .closed
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "010A43")
        view.layer.cornerRadius = 20
        return view
    }()
    let currencyTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .gray
        return tv
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
//        view.backgroundColor = UIColor(hex: "#010A43")
        view.addSubview(addCurrencyButton)
        NSLayoutConstraint.activate([
            addCurrencyButton.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            addCurrencyButton.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23)
        ])
        currencyTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        layout()
    }

    
    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        present(nextView, animated: true, completion: nil)
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    private func layout() {
        view.backgroundColor = UIColor(hex: "10194E")
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.addSubview(currencyTableView)
        
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.size.height * 0.3)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9).isActive = true
        
        currencyTableView.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.9).isActive = true
        currencyTableView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        currencyTableView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        currencyTableView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(hex: "192259") : UIColor(hex: "10194E")
        cell.textLabel?.textColor = UIColor(hex: "858EC5")
        cell.textLabel?.text = "TEST Label"
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = self.view.frame.height * 0.9
            case .closed:
                self.bottomConstraint.constant = self.view.frame.size.height * 0.4
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = self.view.frame.height * 0.9
            case .closed:
                self.bottomConstraint.constant = self.view.frame.size.height * 0.4
            }
        }
        transitionAnimator.startAnimation()
    }
}
