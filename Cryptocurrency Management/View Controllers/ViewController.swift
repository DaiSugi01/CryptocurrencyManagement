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
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        bt.frame.size.height = 36
        bt.layer.cornerRadius = bt.frame.height * 0.3
        bt.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        bt.frame.size.height = 48
        bt.layer.cornerRadius = bt.frame.height * 0.5
        bt.backgroundColor = UIColor(hex: "#212A6B")
        bt.addTarget(self, action: #selector(tableViewSwitchButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()
    let headerWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let tableHeaderSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    let rootHeaderSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    let tableHeaderRightSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 10
        return sv
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
        bt.setImage(UIImage(systemName: "trash"), for: .normal)
        bt.tintColor = .red
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#10194E")
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
            [
                Cryptocurrency(name: "Bitcoin", symbol: "BTC", price: 45497.94)
            ]
    var allowDissmissModal = true
    var selectedRows: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        nextView.delegate = self
        nextView.registeredCurrency = registeredCurrencies.map { $0.symbol }
        present(nextView, animated: true, completion: nil)
    }
    
    @objc func tableViewSwitchButtonTapped(_ sender: UIButton) {
        switchTableViewDisplay()
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        // allow multiple selection
        currencyTableView.allowsMultipleSelection = true
        currencyTableView.allowsMultipleSelectionDuringEditing = true
        currencyTableView.setEditing(!currencyTableView.isEditing, animated: true)
        // disable modal dismissal during editing
        allowDissmissModal = !currencyTableView.isEditing
        // show delete button during editing
        deleteButton.isHidden = !currencyTableView.isEditing
        if currencyTableView.isEditing {
            editButton.setTitle("✕", for: .normal)
        } else {
            // reset the contents of selectedRows array if the user stops editing without deleting
            selectedRows.removeAll()
            editButton.setTitle("Edit", for: .normal)
        }
    }
    
    // multiple deletion
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let sortedSelectedRows = selectedRows.sorted { $0 > $1 }
        for eachRow in sortedSelectedRows {
            registeredCurrencies.remove(at: eachRow)
        }
        // reset the contents of selectedRows array after deleting selected items
        selectedRows.removeAll()
        currencyTableView.reloadData()
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func setupLayout() {
        view.backgroundColor = UIColor(hex: "#010A43")
        
        // currencyTableView
        currencyTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.backgroundColor = UIColor(hex: "#10194E")
        
        // addSubview
        view.addSubview(rootHeaderSV)
        rootHeaderSV.addArrangedSubview(tableViewSwitchButton)
        rootHeaderSV.addArrangedSubview(addCurrencyButton)
        view.addSubview(popupView)
        popupView.addSubview(currencyTableView)
        popupView.addSubview(headerWrapper)
        headerWrapper.addSubview(tableHeaderSV)
        tableHeaderSV.addArrangedSubview(allCurrencyLabel)
        tableHeaderSV.addArrangedSubview(tableHeaderRightSV)
        tableHeaderRightSV.addArrangedSubview(deleteButton)
        tableHeaderRightSV.addArrangedSubview(editButton)
        
        deleteButton.isHidden = true
                
        NSLayoutConstraint.activate([
            rootHeaderSV.heightAnchor.constraint(equalToConstant: 50),
            rootHeaderSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rootHeaderSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            rootHeaderSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            tableViewSwitchButton.heightAnchor.constraint(equalToConstant: 48),
            tableViewSwitchButton.widthAnchor.constraint(equalToConstant: 48),
            
            addCurrencyButton.widthAnchor.constraint(equalToConstant: 140),
            
            tableHeaderSV.topAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.topAnchor, constant: 15),
            tableHeaderSV.heightAnchor.constraint(equalTo: headerWrapper.heightAnchor, multiplier: 0.7),
            
            headerWrapper.heightAnchor.constraint(equalToConstant: 50),
            headerWrapper.topAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerWrapper.leadingAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            headerWrapper.trailingAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            tableHeaderSV.topAnchor.constraint(equalTo: headerWrapper.topAnchor),
            tableHeaderSV.bottomAnchor.constraint(equalTo: headerWrapper.bottomAnchor),
            tableHeaderSV.leadingAnchor.constraint(equalTo: headerWrapper.leadingAnchor),
            tableHeaderSV.trailingAnchor.constraint(equalTo: headerWrapper.trailingAnchor),
            
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            currencyTableView.heightAnchor.constraint(equalTo: popupView.heightAnchor, constant: -60),
            currencyTableView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
            currencyTableView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            currencyTableView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor)
        ])
        // for switching currencyTableView position
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.size.height * 0.05)
        bottomConstraint.isActive = true
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
        cell.imageView?.image = UIImage(named: "default")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowDissmissModal {
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
            // for updating cell.backgroundColor
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

extension ViewController: AddEditCurrencyInfoDelegate {
    func save(currency: Cryptocurrency) {
        registeredCurrencies.append(currency)
        currencyTableView.reloadData()
    }
    
}
