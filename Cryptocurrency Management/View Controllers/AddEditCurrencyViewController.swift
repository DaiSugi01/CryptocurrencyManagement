//
//  AddCurrencyViewController.swift
//  Cryptocurrency Management
//
//  Created by Daiki Sugihara on 2021/01/19.
//

import UIKit
import Charts

protocol AddEditCurrencyInfoDelegate {
    func save(currency: Cryptocurrency)
    func edit(currency: Cryptocurrency)
}

class AddEditCurrencyViewController: UIViewController {
    
    let headerSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 10
        return sv
    }()
    
    let pageTitleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Add Currency"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "AAB6FF")
        return lb
    }()
    
    let saveButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Save", for: .normal)
        bt.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.setTitleColor(.lightGray, for: .normal)
        bt.isEnabled = false
        bt.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    let cancelButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Cancel", for: .normal)
        bt.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bt.setTitleColor(.blue, for: .normal)
        bt.setTitleColor(UIColor(hex: "007AFF"), for: .normal)
        bt.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let contentSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 40
        return sv
    }()
    
    let currencyWrapper: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 10
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 20)
        return sv
    }()
    
    let currencySV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    let currencyLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.required, for: .horizontal)
        lb.text = "Currency"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let currencyNameButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = .white
        bt.setTitleColor(.black, for: .normal)
        bt.backgroundColor = .gray
        bt.setTitle("Fetching...", for: .normal)
        bt.isEnabled = false
        bt.addTarget(self, action: #selector(currencyNameButtonTapped(_:)), for: .touchUpInside)
        bt.layer.cornerRadius = 5.0
        return bt
    }()
    
    let currencyPicker: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = .white
        pv.isHidden = true
        return pv
    }()
    
    let alertWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let alertLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = UIColor(hex: "10194E")
        lb.text = "Set the Alert (optional)"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let alertSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 50
        sv.layer.borderColor = UIColor(hex: "858EC5").cgColor
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 30, leading: 10, bottom: 20, trailing: 10)
        sv.layer.borderWidth = 1
        return sv
    }()
    
    let lowPriceSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    let lowPriceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Low Price"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let lowPriceTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(tfChanged(_:)), for: .editingChanged)
        tf.keyboardType = .numberPad
        tf.textAlignment = .right
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5.0
        return tf
    }()
    
    let highPriceSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    let highPriceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "High Price"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let highPriceTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(tfChanged(_:)), for: .editingChanged)
        tf.keyboardType = .numberPad
        tf.textAlignment = .right
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5.0
        return tf
    }()
    
    let realTimeRateWrapper: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 10
        return sv
    }()
    
    let realTimeRateSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    let realTimeRateLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Real time rate: "
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.setContentHuggingPriority(.required, for: .horizontal)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let realTimeRate: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "$ 45,970.94"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "1DC7AC")
        return lb
    }()
    
    let lineChart: CustomLineChartView = {
        let lc = CustomLineChartView()
        lc.translatesAutoresizingMaskIntoConstraints = false
        lc.noDataText = ""
        return lc
    }()
    
    var currencyInfo: Cryptocurrency?
    var currencies = [""]
    var isPickerHidden = true
    var delegate: AddEditCurrencyInfoDelegate?
    var currency: [String: String] = [String: String]()
    var registeredCurrency = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupUI()
        
        if currencyInfo == nil {
            getCurrencyList()
        } else {
            setFieldsForEdit()
        }
    }
    
    private func setDelegates() {
        /********************** Keyboard ***********************/
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
                
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        
        currencyPicker.delegate = self as UIPickerViewDelegate
        currencyPicker.dataSource = self as UIPickerViewDataSource
        
        lowPriceTF.delegate = self
        highPriceTF.delegate = self
    }
    
    private func getCurrencyList() {
        CurrencyAPI.shared.fetchCurrencyList { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencyInfo):
                    for currency in currencyInfo.data {
                        if !self.registeredCurrency.contains(currency.symbol) {
                            self.currency[currency.symbol] = currency.name
                            self.currencies.append(currency.symbol)
                        }
                    }
                    self.makeCurrencyButtonEnabled(titleText: "")
                case .failure(let error):
                    print(error)
                    self.createDialogMessage()
                }
            }
        }
    }
    
    private func getChartData(currencySymbol: String) {
        CurrencyAPI.shared.fetchCurrencyPriceTimeSeries(currency: currencySymbol) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencyInfo):
                    var values = [Double]()
                    for currency in currencyInfo.data.values {
                        values.append(currency[1])
                    }
                    self.lineChart.setLineGraph(values: values)
                case .failure(let error):
                    print(error)
                    self.createDialogMessage()
                }
            }
        }
    }
    
    private func makeCurrencyButtonEnabled(titleText: String) {
        currencyNameButton.setTitle(titleText, for: .normal)
        currencyNameButton.backgroundColor = .white
        currencyNameButton.isEnabled = true
    }

    private func makeCurrencyButtonInvalid(titleText: String) {
        currencyNameButton.setTitle(titleText, for: .normal)
        currencyNameButton.backgroundColor = .gray
        currencyNameButton.isEnabled = false
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "10194E")
        
        /* add item to views */
        view.addSubview(headerSV)
        view.addSubview(scrollView)
        
        // add items into header stack view
        headerSV.addArrangedSubview(cancelButton)
        headerSV.addArrangedSubview(pageTitleLabel)
        headerSV.addArrangedSubview(saveButton)
        
        // add stack view into scroll view
        scrollView.addSubview(contentSV)
        
        // add items into content stack view
        contentSV.addArrangedSubview(currencyWrapper)
        contentSV.addArrangedSubview(alertWrapper)
        contentSV.addArrangedSubview(realTimeRateWrapper)
        
        // add items into currency wrapper stack view
        currencyWrapper.addArrangedSubview(currencySV)
        currencyWrapper.addArrangedSubview(currencyPicker)
        
        // add items into currency stack view
        currencySV.addArrangedSubview(currencyLabel)
        currencySV.addArrangedSubview(currencyNameButton)
        
        alertWrapper.addSubview(alertSV)
        alertWrapper.addSubview(alertLabel)
        
        // add items into alert stack view
        alertSV.addArrangedSubview(lowPriceSV)
        alertSV.addArrangedSubview(highPriceSV)
        
        // add items into low price stack view
        lowPriceSV.addArrangedSubview(lowPriceLabel)
        lowPriceSV.addArrangedSubview(lowPriceTF)
        
        // add items into high price stack view
        highPriceSV.addArrangedSubview(highPriceLabel)
        highPriceSV.addArrangedSubview(highPriceTF)
        
        // add items into real time rate wrapper stack view
        realTimeRateWrapper.addArrangedSubview(realTimeRateSV)
        realTimeRateWrapper.addArrangedSubview(lineChart)
        
        // add items into real time rate stack view
        realTimeRateSV.addArrangedSubview(realTimeRateLabel)
        realTimeRateSV.addArrangedSubview(realTimeRate)
        
        setConstraints()
    }
    
    private func setConstraints() {
        /* header */
        headerSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        headerSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        headerSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        /* scroll view */
        scrollView.topAnchor.constraint(equalTo: headerSV.bottomAnchor, constant: 70).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        contentSV.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentSV.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor).isActive = true
        contentSV.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor).isActive = true
        contentSV.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        
        /* currency area */
        currencyWrapper.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        currencyNameButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currencyNameButton.widthAnchor.constraint(equalTo: contentSV.widthAnchor, multiplier: 0.5).isActive = true
        
        /* alert area */
        alertWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        alertWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        alertWrapper.heightAnchor.constraint(equalToConstant: 190).isActive = true
        
        alertLabel.topAnchor.constraint(equalTo: alertWrapper.topAnchor).isActive = true
        alertLabel.leadingAnchor.constraint(equalTo: alertWrapper.leadingAnchor, constant: 5).isActive = true
        
        alertSV.topAnchor.constraint(equalTo: alertWrapper.topAnchor, constant: 10).isActive = true
        alertSV.bottomAnchor.constraint(equalTo: alertWrapper.bottomAnchor).isActive = true
        alertSV.leadingAnchor.constraint(equalTo: alertWrapper.leadingAnchor).isActive = true
        alertSV.trailingAnchor.constraint(equalTo: alertWrapper.trailingAnchor).isActive = true
        
        lowPriceTF.widthAnchor.constraint(equalTo: contentSV.widthAnchor, multiplier: 0.5).isActive = true
        lowPriceTF.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        highPriceTF.widthAnchor.constraint(equalTo: contentSV.widthAnchor, multiplier: 0.5).isActive = true
        highPriceTF.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        /* real time rate area */
        realTimeRateSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        realTimeRateSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        lineChart.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineChart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        lineChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setFieldsForEdit() {
        // change screen title
        pageTitleLabel.text = "Edit Currency"
        
        // set low price
        if let lowPrice = currencyInfo?.lowPrice {
            lowPriceTF.text = "\(lowPrice)"
        }
        
        // set high price
        if let highPrice = currencyInfo?.highPrice {
            highPriceTF.text = "\(highPrice)"
        }
        
        // make currencyNameButton invalid
        makeCurrencyButtonInvalid(titleText: currencyInfo!.symbol)
        
        // set chart
        getChartData(currencySymbol: currencyInfo!.symbol)
    }
    
    private func isEnableSaveButton() -> Bool{
        var isTextFieldValidPass = true
        if lowPriceTF.text != "" || highPriceTF.text != "" {
            isTextFieldValidPass = isTextFieldValid()
        }
        guard let selectedCurrencyName = currencyNameButton.currentTitle else { return false }
        return selectedCurrencyName != "" && isTextFieldValidPass
    }
    
    private func isTextFieldValid() -> Bool {
        if lowPriceTF.text != "" {
            guard let _ = Double(lowPriceTF.text!) else { return false }
        }
        
        if highPriceTF.text != "" {
            guard let _ = Double(highPriceTF.text!) else { return false }
        }
        
        return true
    }
    
    private func hiddenPicker() {
        if currencyPicker.isHidden { return }
        
        UIView.animate(withDuration: 0.1) {
            self.currencyPicker.isHidden = true
        }
        
        guard let currencyName = currencyNameButton.currentTitle else { return }
        
        if !currencyName.isEmpty {
            getChartData(currencySymbol: currencyName)
            lineChart.isHidden = false
        } else {
            lineChart.isHidden = true
        }
    }
    
    private func enableSaveButton() {
        if isEnableSaveButton() {
            saveButton.isEnabled = true
            saveButton.setTitleColor(UIColor(hex: "007AFF"), for: .normal)
        } else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    private func createDialogMessage() {
        let dialogMessage = UIAlertController(title: "", message: "Sorry, we couldn't fetch data.\n Please try again", preferredStyle: .alert)
        let wrong = UIAlertAction(title: "Dissmiss", style: .cancel, handler: { (_) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        dialogMessage.addAction(wrong)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension AddEditCurrencyViewController {
    
    /********************** Keyboard ***********************/
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.size.height
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc func dismissPicker(_ sender: UITapGestureRecognizer) {
        hiddenPicker()
        view.endEditing(true)
    }

    @objc func tfChanged(_ sender: UITextField) {
        enableSaveButton()
    }
    
    @objc private func saveButtonTapped() {
        guard let currencySymbol = currencyNameButton.currentTitle else { return }
        
        let lowPrice: Double?
        lowPrice = !lowPriceTF.text!.isEmpty ? Double(lowPriceTF.text!) : nil
        let highPrice: Double?
        highPrice = !highPriceTF.text!.isEmpty ? Double(highPriceTF.text!) : nil

        if pageTitleLabel.text == "Add Currency" {
            if let currencyName = currency[currencySymbol] {
                delegate?.save(currency: Cryptocurrency(name: currencyName, symbol: currencySymbol, realTimeRate: 100.0, lowPrice: lowPrice, highPrice: highPrice))
            }
        } else {
            let currencyName = currencyInfo!.name
            let symbol = currencyInfo!.symbol
            delegate?.edit(currency: Cryptocurrency(
                            name: currencyName,
                            symbol: symbol,
                            realTimeRate: 110.0,
                            lowPrice: lowPrice,
                            highPrice: highPrice))
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func currencyNameButtonTapped(_ sender: UITextField) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.1) {
            self.currencyPicker.isHidden = false
        }
    }
}

extension AddEditCurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = currencies[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyNameButton.setTitle(currencies[row], for: .normal)
        enableSaveButton()
    }
}

extension AddEditCurrencyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableSaveButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hiddenPicker()
    }
}
