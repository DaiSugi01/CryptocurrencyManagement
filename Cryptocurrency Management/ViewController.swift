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
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        bt.frame = CGRect(x: 261, y: 76, width: 120, height: 36)
        bt.layer.cornerRadius = bt.frame.height * 0.10
        bt.backgroundColor = UIColor(hex: "#212A6B", alpha: 1.0)
        bt.addTarget(self, action: #selector(addCurrencyButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()
    let tableViewSwitchButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("＝", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        bt.setTitleColor(UIColor(hex: "#FF2E63"), for: .normal)
        bt.frame = CGRect(x: 16, y: 76, width: 48, height: 48)
        bt.layer.cornerRadius = bt.frame.height * 0.50
        bt.backgroundColor = UIColor(hex: "#212A6B")
        bt.addTarget(self, action: #selector(tableViewSwitchButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()
    let editButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Edit", for: .normal)
        bt.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
        bt.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()
    let deleteButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Delete", for: .normal)
        bt.setTitleColor(UIColor(hex: "#fc0303"), for: .normal)
        bt.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()
    let allCurrencyLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "All Currencies"
        lb.textColor = UIColor(hex: "#FFFFFF")
        return lb
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
    var registeredCurrencies: [Cryptocurrency] =
            [Cryptocurrency(name: "Bitcoin", price: 45497.94),
             Cryptocurrency(name: "Ethereum", price: 1408.84),
             Cryptocurrency(name: "Ripple", price: 0.301),
             Cryptocurrency(name: "Litecoin", price: 180.64),
             Cryptocurrency(name: "Bitcoin Cash", price: 476.05),
             Cryptocurrency(name: "Stellar", price: 0.29),
             Cryptocurrency(name: "EOS", price: 2.73),
             Cryptocurrency(name: "Tezos", price: 2.75),
             Cryptocurrency(name: "Dash", price: 113.29),
             Cryptocurrency(name: "Ethereum Classic", price: 7.75),
             Cryptocurrency(name: "Bitcoin", price: 45497.94),
             Cryptocurrency(name: "Ethereum", price: 1408.84),
             Cryptocurrency(name: "Ripple", price: 0.301),
             Cryptocurrency(name: "Litecoin", price: 180.64),
             Cryptocurrency(name: "Bitcoin Cash", price: 476.05),
             Cryptocurrency(name: "Stellar", price: 0.29),
             Cryptocurrency(name: "EOS", price: 2.73),
             Cryptocurrency(name: "Tezos", price: 2.75),
             Cryptocurrency(name: "Dash", price: 113.29),
             Cryptocurrency(name: "Ethereum Classic", price: 7.75),
             Cryptocurrency(name: "Bitcoin", price: 45497.94),
             Cryptocurrency(name: "Ethereum", price: 1408.84),
             Cryptocurrency(name: "Ripple", price: 0.301),
             Cryptocurrency(name: "Litecoin", price: 180.64),
             Cryptocurrency(name: "Bitcoin Cash", price: 476.05),
             Cryptocurrency(name: "Stellar", price: 0.29),
             Cryptocurrency(name: "EOS", price: 2.73),
             Cryptocurrency(name: "Tezos", price: 2.75),
             Cryptocurrency(name: "Dash", price: 113.29),
             Cryptocurrency(name: "Ethereum Classic", price: 7.75)]
    var allowDissmissModal = true
    var selectedRows: [Int] = []
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hex: "#010A43")
        super.viewDidLoad()
        view.addSubview(addCurrencyButton)
        view.addSubview(tableViewSwitchButton)
        currencyTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        layout()
        popupView.addSubview(editButton)
        popupView.addSubview(deleteButton)
        deleteButton.isHidden = true
        popupView.addSubview(allCurrencyLabel)
        NSLayoutConstraint.activate([
            addCurrencyButton.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            addCurrencyButton.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23),
            addCurrencyButton.heightAnchor.constraint(equalToConstant: 36),
            tableViewSwitchButton.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 74),
            tableViewSwitchButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewSwitchButton.heightAnchor.constraint(equalToConstant: 48),
            tableViewSwitchButton.widthAnchor.constraint(equalToConstant: 48),
            editButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 24),
            editButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -24),
            deleteButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 24),
            deleteButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            allCurrencyLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 28),
            allCurrencyLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 18)
        ])
    }
    
    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        present(nextView, animated: true, completion: nil)
    }
    
    @objc func tableViewSwitchButtonTapped(_ sender: UIButton) {
        switchTableViewDisplay()
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        // allow multiple selection
        currencyTableView.allowsMultipleSelection = true
        currencyTableView.allowsMultipleSelectionDuringEditing = true
        let tableViewEditingMode = currencyTableView.isEditing  // false during editing mode (strange)
        currencyTableView.setEditing(!tableViewEditingMode, animated: true)
        // disable modal dismissal during editing
        allowDissmissModal = tableViewEditingMode
        // show delete button during editing
        deleteButton.isHidden = tableViewEditingMode
        if tableViewEditingMode == true {
            selectedRows.removeAll()
        }
    }
    
    // multiple deletion
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let sortedSelectedRows = selectedRows.sorted { $0 > $1 }
        for eachRow in sortedSelectedRows {
            registeredCurrencies.remove(at: eachRow)
        }
        selectedRows.removeAll()
        currencyTableView.reloadData()
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    private func layout() {
        view.backgroundColor = UIColor(hex: "#010A43")
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = UIColor(hex: "#10194E")
        view.addSubview(popupView)
        popupView.addSubview(currencyTableView)
        currencyTableView.backgroundColor = UIColor(hex: "#10194E")
        
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.size.height * 0.05)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
        currencyTableView.heightAnchor.constraint(equalTo: popupView.heightAnchor, constant: -60).isActive = true
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
        let cell = UITableViewCell(style: .value1 , reuseIdentifier: cellId)
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(hex: "#192259") : UIColor(hex: "#10194E")
        cell.textLabel?.textColor = UIColor(hex: "#858EC5")
        cell.textLabel?.text = registeredCurrencies[indexPath.row].name
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        cell.detailTextLabel?.text = "$ \(registeredCurrencies[indexPath.row].price)"
        cell.detailTextLabel?.textColor = UIColor(hex: "#1DC7AC")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowDissmissModal == true {
            switchTableViewDisplay()
        } else {
            selectedRows.append(indexPath.row)
        }
    }
    
    // swipe delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registeredCurrencies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            // for update cell.backgroundColor
            tableView.reloadData()
        }
    }
    
    // table view modal dismissal and reappearance
    private func switchTableViewDisplay() {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = self.view.frame.height * 0.95
            case .closed:
                self.bottomConstraint.constant = self.view.frame.size.height * 0.05
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
                self.bottomConstraint.constant = self.view.frame.height * 0.95
            case .closed:
                self.bottomConstraint.constant = self.view.frame.size.height * 0.05
            }
        }
        transitionAnimator.startAnimation()
    }
}
