//
//  AddCurrencyViewController.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/18.
//

import UIKit

class AddCurrencyViewController: UIViewController {

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
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return sv
    }()
    
    let currencySV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 50
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
        sv.spacing = 50
        return sv
    }()
    
    let lowPriceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.required, for: .horizontal)
        lb.text = "Low Price"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let lowPriceTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(selectedTF(_:)), for: .editingDidBegin)
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
        sv.spacing = 50
        return sv
    }()
    
    let highPriceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.required, for: .horizontal)
        lb.text = "High Price"
        lb.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        lb.textColor = UIColor(hex: "858EC5")
        return lb
    }()
    
    let highPriceTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(selectedTF(_:)), for: .editingDidBegin)
        tf.keyboardType = .numberPad
        tf.textAlignment = .right
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5.0
        return tf
    }()
    
    let currencies = ["", "BTC", "ETH", "XRP", "German", "Science", "Japanese", "French"]
    var isPickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupUI()
    }
    

    private func setDelegates() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker(_:)))
        view.addGestureRecognizer(gestureRecognizer)

        currencyPicker.delegate = self as UIPickerViewDelegate
        currencyPicker.dataSource = self as UIPickerViewDataSource
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "10194E")

        view.addSubview(scrollView)
        view.addSubview(headerSV)
        scrollView.addSubview(contentSV)
        // add items into header stack view
        headerSV.addArrangedSubview(cancelButton)
        headerSV.addArrangedSubview(pageTitleLabel)
        headerSV.addArrangedSubview(saveButton)
        // add contents into scroll view
        scrollView.addSubview(contentSV)
        // add label and textField to stack view
        contentSV.addArrangedSubview(currencyWrapper)
        currencyWrapper.addArrangedSubview(currencySV)
        // add label and textField to stack view
        currencySV.addArrangedSubview(currencyLabel)
        currencySV.addArrangedSubview(currencyNameButton)
        currencyWrapper.addArrangedSubview(currencyPicker)

        contentSV.addArrangedSubview(alertSV)

        alertSV.addArrangedSubview(lowPriceSV)
        alertSV.addArrangedSubview(highPriceSV)

        lowPriceSV.addArrangedSubview(lowPriceLabel)
        lowPriceSV.addArrangedSubview(lowPriceTF)
        
        highPriceSV.addArrangedSubview(highPriceLabel)
        highPriceSV.addArrangedSubview(highPriceTF)

        /* header stack view**/
        // set header stack view constraints
        headerSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        headerSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        headerSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        /* scroll view */
        // set contents scroll view constraints
        scrollView.topAnchor.constraint(equalTo: headerSV.bottomAnchor, constant: 70).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        /* contents stack view**/
        // set contents stack view constraints
        contentSV.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentSV.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor).isActive = true
        contentSV.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor).isActive = true
        contentSV.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        
        lowPriceTF.widthAnchor.constraint(equalTo: contentSV.widthAnchor, multiplier: 0.5).isActive = true
        lowPriceTF.heightAnchor.constraint(equalToConstant: 40).isActive = true

        highPriceTF.widthAnchor.constraint(equalTo: contentSV.widthAnchor, multiplier: 0.5).isActive = true
        highPriceTF.heightAnchor.constraint(equalToConstant: 40).isActive = true

        currencyNameButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currencyNameButton.widthAnchor.constraint(equalTo: contentSV.widthAnchor, multiplier: 0.5).isActive = true

        print(alertSV.frame.origin.x)
        print(alertSV.frame.origin.y)
//        let alertLabel = UILabel(frame: .init(x: alertSV.bounds., y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
//        contentSV.addArrangedSubview(alertLabel)

    }
    
    private func isEnableSaveButton(buttonTitle: String) -> Bool{
        return buttonTitle != ""
    }
    
    private func hiddenPicker() {
        if !currencyPicker.isHidden {
            UIView.animate(withDuration: 0.1) {
                self.currencyPicker.isHidden = true
            }
        }
    }
}

extension AddCurrencyViewController {
    @objc func dismissPicker(_ sender: UITapGestureRecognizer) {
        hiddenPicker()
        view.endEditing(true)
    }
        
    @objc func keyboardWasShown(_ notification: NSNotification) {
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
    }
    
    @objc func selectedTF(_ sender: UITextField) {
        hiddenPicker()
    }
    
    @objc private func saveButtonTapped() {
        print("Save button tapped")
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

extension AddCurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
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
        let selectedCurrency = currencies[row]
        currencyNameButton.setTitle(selectedCurrency, for: .normal)
        if isEnableSaveButton(buttonTitle: selectedCurrency) {
            saveButton.isEnabled = true
            saveButton.setTitleColor(.blue, for: .normal)
        } else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(.lightGray, for: .normal)
        }
    }
}
