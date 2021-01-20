//
//  ViewController.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/17.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let headerNavigationBar: UIView = UIView()
    let chartView: UIView = UIView()
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
    let showChartButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false


        bt.frame = CGRect(x: 30, y: 76, width: 40, height: 40)
        bt.backgroundColor = UIColor(hex: "#212A6B", alpha: 1.0)
        bt.layer.cornerRadius = 15.0
        bt.addTarget(self, action: #selector(showChartButtonTapped(_:)), for: .touchUpInside)
        return bt
    }()
    var helloLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.frame = CGRect(x: 60, y: 76, width: 200, height: 36)
        lb.textAlignment = NSTextAlignment.center
        lb.text = "Hello Daiki,"
        lb.backgroundColor = UIColor(hex: "#010A43")
        lb.textColor = .white
        return lb
    }()
    let tableViewHeader: UIView = UIView()
    let tableView: UITableView = UITableView()
    var selectedCurrencies: [Cryptocurrency] =
        [Cryptocurrency(name: "Bitcoin", price: 45497.94),
         Cryptocurrency(name: "Ethereum", price: 1408.84),
         Cryptocurrency(name: "Ripple", price: 0.301),
         Cryptocurrency(name: "Litecoin", price: 180.64)]
    var showChartButtonTappedState = false



    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = UIColor(hex: "#010A43")
        headerNavigationBarFunc()
        charViewFunc()
        setupTableView()

        headerNavigationBar.addSubview(showChartButton)
        headerNavigationBar.addSubview(helloLabel)
        headerNavigationBar.addSubview(addCurrencyButton)
        NSLayoutConstraint.activate([
            addCurrencyButton.topAnchor.constraint(greaterThanOrEqualTo: headerNavigationBar.safeAreaLayoutGuide.topAnchor, constant: 50),
            addCurrencyButton.trailingAnchor.constraint(greaterThanOrEqualTo: headerNavigationBar.safeAreaLayoutGuide.trailingAnchor, constant: -23),
            showChartButton.topAnchor.constraint(greaterThanOrEqualTo: headerNavigationBar.safeAreaLayoutGuide.topAnchor, constant: 50),
            showChartButton.leadingAnchor.constraint(greaterThanOrEqualTo: headerNavigationBar.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            helloLabel.topAnchor.constraint(greaterThanOrEqualTo: headerNavigationBar.safeAreaLayoutGuide.topAnchor, constant: 55),
            helloLabel.leadingAnchor.constraint(greaterThanOrEqualTo: showChartButton.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            chartView.topAnchor.constraint(equalTo: headerNavigationBar.bottomAnchor, constant: 10),
            chartView.leadingAnchor.constraint(equalTo: headerNavigationBar.leadingAnchor, constant: 10)
//            chartView.widthAnchor.constraint(equalTo: headerNavigationBar.widthAnchor, multiplier: 0.9),
//            chartView.heightAnchor.constraint(equalToConstant: 200)


        ])
    }


    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        present(nextView, animated: true, completion: nil)

    }

    @objc func showChartButtonTapped(_ sender: UIButton) {
        let width = self.view.frame.width
        if showChartButtonTappedState == false {
            showChartButtonTappedState = true
        } else {
            showChartButtonTappedState = false
        }
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 10) {
            if self.showChartButtonTappedState == true {
                self.headerNavigationBar.frame = CGRect(x: 0, y: 0, width: width, height: 358)
                let height = self.headerNavigationBar.frame.height
                self.chartView.frame = CGRect(x: 10, y: height - self.chartView.frame.height - 10, width: width - 20, height: 180)
                self.chartView.isHidden = false
                self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y + 200, width: self.tableView.frame.size.width, height: self.tableView.contentSize.height)
            } else {
                self.headerNavigationBar.frame = CGRect(x: 0, y: 0, width: width, height: 158)
                let height = self.headerNavigationBar.frame.height
                self.chartView.frame = CGRect(x: 10, y: height - self.chartView.frame.height - 10, width: width - 20, height: 180)
                self.chartView.isHidden = true
                self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y - 200, width: self.tableView.frame.size.width, height: self.tableView.contentSize.height)
            }
        }
    }

    func headerNavigationBarFunc() {
        let width = self.view.frame.width
        let originalFrame = CGRect(x: 0, y: 0, width: width, height: 160)

        headerNavigationBar.backgroundColor = UIColor(hex: "#010A43")  // 010A43 DDDDDD
        headerNavigationBar.frame = originalFrame

        self.view.addSubview(headerNavigationBar)
    }

    func charViewFunc() {
        let width = self.view.frame.width
        chartView.backgroundColor = .green
        chartView.frame = CGRect(x: 10, y: 170, width: width - 20, height: 180)
        self.headerNavigationBar.addSubview(chartView)
        chartView.isHidden = true
    }


    func setupTableView() {
        // required
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerNavigationBar.bottomAnchor, constant: 80).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCurrencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundColor = UIColor(hex: "#10194E")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            // ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")  // UITableViewCell.CellStyle.value1
        // if that fails, create a new one
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
//        }

        cell.textLabel?.text = selectedCurrencies[indexPath.row].name  // 858EC5
        cell.textLabel?.textColor = UIColor(hex: "#858EC5")
        cell.detailTextLabel?.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -20).isActive = true
        cell.detailTextLabel?.text = "\(selectedCurrencies[indexPath.row].price)"
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(hex: "#192259")
        } else {
            cell.backgroundColor = UIColor(hex: "#10194E")
        }
        return cell
    }


}
