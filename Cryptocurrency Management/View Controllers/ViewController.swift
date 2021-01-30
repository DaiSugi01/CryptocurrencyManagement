//
//  ViewController.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/17, advised by Daiki Sugihara.
//

import UIKit
import Charts
import SDWebImageSVGCoder

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
    
    let editCurrencyButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Edit Currency", for: .normal)
        bt.setTitleColor(UIColor(hex: "#426DDC"), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        bt.frame.size.height = 36
        bt.layer.cornerRadius = bt.frame.height * 0.3
        bt.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bt.backgroundColor = UIColor(hex: "#212A6B", alpha: 1.0)
        bt.isHidden = true
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
    let rootHeaderSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    let spinnerForChart = UIActivityIndicatorView(style: .large)
    let spinnerForCurrencyList = UIActivityIndicatorView(style: .large)
    let chartContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    let orderBookContainer: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    let orderBookContainerHeaderSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    let orderBookLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Order Book"
        lb.textAlignment = .center
        lb.textColor = UIColor(hex: "#858EC5")
        lb.font = UIFont.systemFont(ofSize: 24)
        return lb
    }()
    let orderBookContainerHeaderLowerSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    let askLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Ask"
        lb.textAlignment = .center
        lb.textColor = UIColor(hex: "#858EC5")
        return lb
    }()
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Price"
        lb.textAlignment = .center
        lb.textColor = UIColor(hex: "#858EC5")
        return lb
    }()
    let bidLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Bid"
        lb.textAlignment = .center
        lb.textColor = UIColor(hex: "#858EC5")
        return lb
    }()
    let orderBookChartContainer: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    let orderBookScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
    
    let defaults = UserDefaults.standard
    
    var registeredCurrencies = [Cryptocurrency]()
    var selectedCurrency = Cryptocurrency(name: "BTC", symbol: "BitCoin", realTimeRate: 0, lowPrice: nil, highPrice: nil, image: "")
    var allowDissmissModal = true
    var registeredOrders: [OrderBook] = [
        OrderBook(currencyName: "Bitcoin", price: 4050.0, amount: 100, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4100.0, amount: 200, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4150.0, amount: 300, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4200.0, amount: 400, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4250.0, amount: 500, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4300.0, amount: 600, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4350.0, amount: 700, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4400.0, amount: 800, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4450.0, amount: 900, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4500.0, amount: 1000, orderBookType: OrderBook.OrderBookType.bid),
        OrderBook(currencyName: "Bitcoin", price: 4550.0, amount: 1000, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4600.0, amount: 900, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4650.0, amount: 800, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4700.0, amount: 700, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4750.0, amount: 600, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4800.0, amount: 500, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4850.0, amount: 400, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4900.0, amount: 300, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 4950.0, amount: 200, orderBookType: OrderBook.OrderBookType.ask),
        OrderBook(currencyName: "Bitcoin", price: 5000.0, amount: 100, orderBookType: OrderBook.OrderBookType.ask)
    ]
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrencyListFromLocal()
        setDelegate()
        setupLayout()
        createOrderBookContents()
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 11.0, repeats: true) { _ in
            self.fetchRealTimeRate()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func fetchRealTimeRate() {
        // when nothing is registered
        if registeredCurrencies.count == 0 { return }
        // make a string to fetch registered currencies from nomics api
        let currencySymbolsString: String = registeredCurrencies.map { $0.symbol }.joined(separator: ",")
        
        CurrencyAPI.shared.fetchCryptocurrencyFromNomics(currencySymbols: currencySymbolsString) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencyInfo):
                    for currency in currencyInfo {
                        let symbol = currency.symbol
                        let price = Double(currency.price)
                        let imageURL = currency.logo_url
                        for (index, target) in self.registeredCurrencies.enumerated() {
                            if target.symbol == symbol {
                                self.registeredCurrencies[index].realTimeRate = price!
                                self.registeredCurrencies[index].image = imageURL
                                break
                            }
                        }
                    }
                    self.currencyTableView.reloadData()
                    self.spinnerForCurrencyList.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setCurrencyListFromLocal() {
        if let savedCurrencyList = defaults.object(forKey: "RegisteredCurrencyList") as? Data {
            let decoder = JSONDecoder()
            if let loadedCurrencyList = try? decoder.decode([Cryptocurrency].self, from: savedCurrencyList) {
                registeredCurrencies = loadedCurrencyList
            }
        } else {
            registeredCurrencies = [Cryptocurrency(name: "Bitcoin", symbol: "BTC", realTimeRate: 45497.94, lowPrice: nil, highPrice: nil, image: "")]
        }
    }
    
    func setDelegate() {
        /********************** App ***********************/
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resignActive(_:)),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    func saveCurrencyListToLocal() {
        let encoder = JSONEncoder()
        if let encodedList = try? encoder.encode(registeredCurrencies) {
            defaults.set(encodedList, forKey: "RegisteredCurrencyList")
        }
    }
    
    /********************** App ***********************/
    @objc func resignActive(_ sender: UIApplication) {
        saveCurrencyListToLocal()
    }
    
    @objc func addCurrencyButtonTapped(_ sender: UIButton) {
        let nextView = AddEditCurrencyViewController()
        nextView.modalTransitionStyle = .coverVertical
        nextView.delegate = self
        nextView.registeredCurrency = registeredCurrencies.map { $0.symbol }
        
        if !editCurrencyButton.isHidden {
            nextView.currencyInfo = selectedCurrency
        }
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
            editButton.setTitle("Edit", for: .normal)
        }
    }
    
    // multiple deletion
    @objc func deleteButtonTapped(_ sender: UIButton) {
        guard let selectedRows = currencyTableView.indexPathsForSelectedRows else { return }
        let newSelectedRows = selectedRows.sorted { $0 < $1 }
        
        for indexPath in newSelectedRows.reversed() {
            registeredCurrencies.remove(at: indexPath.row)
        }
        currencyTableView.reloadData()
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func setupLayout() {
        view.backgroundColor = UIColor(hex: "#010A43")
        
        // spinner  // spinnerForChart
        spinnerForChart.startAnimating()
        spinnerForChart.translatesAutoresizingMaskIntoConstraints = false
        // spinnerForCurrencyList
        spinnerForCurrencyList.startAnimating()
        spinnerForCurrencyList.translatesAutoresizingMaskIntoConstraints = false
        spinnerForCurrencyList.color = UIColor(hex: "#FF2E63")
        
        // currencyTableView
        currencyTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.backgroundColor = UIColor(hex: "#10194E")
        
        // addSubview in detail page
        view.addSubview(rootHeaderSV)
        rootHeaderSV.addArrangedSubview(tableViewSwitchButton)
        rootHeaderSV.addArrangedSubview(addCurrencyButton)
        rootHeaderSV.addArrangedSubview(editCurrencyButton)

        view.addSubview(chartContainer)
        chartContainer.addSubview(spinnerForChart)
        
        view.addSubview(orderBookContainer)
        orderBookContainer.addArrangedSubview(orderBookContainerHeaderSV)
        orderBookContainerHeaderSV.addArrangedSubview(orderBookLabel)
        orderBookContainerHeaderSV.addArrangedSubview(orderBookContainerHeaderLowerSV)
        orderBookContainerHeaderLowerSV.addArrangedSubview(askLabel)
        orderBookContainerHeaderLowerSV.addArrangedSubview(priceLabel)
        orderBookContainerHeaderLowerSV.addArrangedSubview(bidLabel)
        orderBookContainer.addArrangedSubview(orderBookScrollView)
        orderBookScrollView.addSubview(orderBookChartContainer)
        
        // addSubView in main page
        view.addSubview(popupView)
        popupView.addSubview(currencyTableView)
        popupView.addSubview(headerWrapper)
        popupView.addSubview(spinnerForCurrencyList)
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
            editCurrencyButton.widthAnchor.constraint(equalToConstant: 140),

            chartContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chartContainer.topAnchor.constraint(equalTo: rootHeaderSV.bottomAnchor, constant: 10),
            chartContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            chartContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            
            spinnerForChart.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            spinnerForChart.centerYAnchor.constraint(equalTo: chartContainer.centerYAnchor),
            
            orderBookContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderBookContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orderBookContainer.topAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: 20),
            orderBookContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            orderBookContainerHeaderSV.leadingAnchor.constraint(equalTo: orderBookContainer.leadingAnchor),
            orderBookContainerHeaderSV.trailingAnchor.constraint(equalTo: orderBookContainer.trailingAnchor),
            orderBookContainerHeaderSV.topAnchor.constraint(equalTo: orderBookContainer.topAnchor),
            
            orderBookLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            orderBookContainerHeaderLowerSV.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.025),
            
            orderBookScrollView.topAnchor.constraint(equalTo: orderBookContainerHeaderSV.bottomAnchor),
            orderBookScrollView.leadingAnchor.constraint(equalTo: orderBookContainer.leadingAnchor),
            orderBookScrollView.widthAnchor.constraint(equalTo: orderBookContainer.widthAnchor),
            orderBookScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),

            orderBookChartContainer.topAnchor.constraint(equalTo: orderBookScrollView.contentLayoutGuide.topAnchor),
            orderBookChartContainer.bottomAnchor.constraint(equalTo: orderBookScrollView.contentLayoutGuide.bottomAnchor),
            orderBookChartContainer.leadingAnchor.constraint(equalTo: orderBookScrollView.frameLayoutGuide.leadingAnchor),
            orderBookChartContainer.trailingAnchor.constraint(equalTo: orderBookScrollView.frameLayoutGuide.trailingAnchor),
                        
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
            
            spinnerForCurrencyList.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            spinnerForCurrencyList.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
            
            currencyTableView.heightAnchor.constraint(equalTo: popupView.heightAnchor, constant: -60),
            currencyTableView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
            currencyTableView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            currencyTableView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor)
        ])
        // for switching currencyTableView position
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.size.height * 0.05)
        bottomConstraint.isActive = true
    }
    
    private func createOrderBookContents() {
        // may have to be deleted later
        let sortedRegisteredCurrencies = registeredOrders.sorted { $1.price < $0.price }
        for order in sortedRegisteredCurrencies {

            let orderBookCellSV = UIStackView()
            orderBookCellSV.translatesAutoresizingMaskIntoConstraints = false
            orderBookCellSV.axis = .horizontal
            orderBookCellSV.distribution = .fillEqually
            orderBookCellSV.alignment = .center
            orderBookCellSV.spacing = 10
            
            let askAmountLabel = UILabel()
            askAmountLabel.translatesAutoresizingMaskIntoConstraints = false
            askAmountLabel.text = (order.orderBookType == OrderBook.OrderBookType.bid) ? "" : "\(order.amount)"
            askAmountLabel.textAlignment = .center
            askAmountLabel.textColor = UIColor(hex: "#858EC5")
            
            let eachPriceLabel = UILabel()
            eachPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            eachPriceLabel.text = "\(order.price)"
            eachPriceLabel.textAlignment = .center
            eachPriceLabel.textColor =  (order.orderBookType == OrderBook.OrderBookType.bid) ? UIColor(hex: "#1DC7AC") : UIColor(hex: "#FF3B30")
            
            let bidAmountLabel = UILabel()
            bidAmountLabel.translatesAutoresizingMaskIntoConstraints = false
            bidAmountLabel.text = (order.orderBookType == OrderBook.OrderBookType.bid) ? "\(order.amount)" : ""
            bidAmountLabel.textAlignment = .center
            bidAmountLabel.textColor = UIColor(hex: "#858EC5")
            
            orderBookChartContainer.addArrangedSubview(orderBookCellSV)
            orderBookCellSV.addArrangedSubview(askAmountLabel)
            orderBookCellSV.addArrangedSubview(eachPriceLabel)
            orderBookCellSV.addArrangedSubview(bidAmountLabel)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurrencyTableViewCell(style: .value1 , reuseIdentifier: cellId)
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(hex: "#192259") : UIColor(hex: "#10194E")
        cell.textLabel?.textColor = UIColor(hex: "#858EC5")
        cell.textLabel?.text = registeredCurrencies[indexPath.row].name
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        cell.detailTextLabel?.text = "$ \(registeredCurrencies[indexPath.row].realTimeRate)"
        cell.detailTextLabel?.textColor = UIColor(hex: "#1DC7AC")
        
        for currency in registeredCurrencies {
            if cell.textLabel?.text == currency.name {
                if currency.image.hasSuffix(".svg") {
                    let svgURL = URL(string: currency.image)
                    cell.imageView?.sd_setImage(with: svgURL)

                } else if !currency.image.isEmpty {
                    cell.imageView?.image = UIImage(url: currency.image)
                } else {
                    cell.imageView?.image = UIImage(named: "default")
                }
                break
            }
        }
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
        }
        selectedCurrency = registeredCurrencies[indexPath.row]
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
        
        switch state {
        case .open:
            self.addCurrencyButton.isHidden = true
            self.editCurrencyButton.isHidden = false
        case .closed:
            self.addCurrencyButton.isHidden = false
            self.editCurrencyButton.isHidden = true
        }
        self.view.layoutIfNeeded()

    }
}

extension ViewController: AddEditCurrencyInfoDelegate {
    func save(currency: Cryptocurrency) {
        registeredCurrencies.append(currency)
        saveCurrencyListToLocal()
        currencyTableView.reloadData()
    }
    
    func edit(currency: Cryptocurrency) {
        if let index = registeredCurrencies.firstIndex(of: currency) {
            registeredCurrencies[index] = currency
        }
        saveCurrencyListToLocal()
        currencyTableView.reloadData()
    }
}
