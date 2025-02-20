//
//  MainController.swift
//  Converter
//
//  Created by Victor Mashukevich on 21.10.24.
//

import UIKit

class MainController: UIViewController {
    
    // MARK: - UI Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .tableBackground
        tableView.separatorColor = .inputFieldBorder
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private let amountTextField = UITextField()
    private let apiManager: ApiManager = VCApiManager()
    
    private let defaultsManager = DefaultsManager()
    
    // MARK: - Data Properties
    private var currencyCodes: [String] = ["USD", "GBP", "JPY", "AUD"]
    private var exchangeRates: [String: Double] = [:]
    private var baseAmount: Double = 1.0
    
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        exchangeRates = defaultsManager.loadExchangeRates()
        tableView.reloadData()
        
        setupUI()
        
        // Fetching data from API
        apiManager.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.exchangeRates = data.rates
                    self?.defaultsManager.saveExchangeRates(data.rates)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {

        view.backgroundColor = .primaryBackground
        
        amountTextField.borderStyle = .roundedRect
        amountTextField.placeholder = "Введите сумму"
        amountTextField.keyboardType = .decimalPad
        amountTextField.backgroundColor = .inputFieldBackground
        amountTextField.textColor = .primaryText
        amountTextField.layer.borderColor = UIColor.inputFieldBorder.cgColor
        amountTextField.layer.borderWidth = 1.0
        amountTextField.addTarget(self, action: #selector(amountDidChange), for: .editingChanged)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.addDoneAndCancelButtonsOnKeyboard()
        view.addSubview(amountTextField)
        
        let addCurrencyButton = UIButton(type: .system)
        addCurrencyButton.setTitle("Добавить валюту", for: .normal)
        addCurrencyButton.setTitleColor(.accentBlue, for: .normal)
        addCurrencyButton.layer.cornerRadius = 8
        addCurrencyButton.backgroundColor = .white
        addCurrencyButton.layer.borderColor = UIColor.accentBlue.cgColor
        addCurrencyButton.layer.borderWidth = 1.0
        addCurrencyButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
        addCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCurrencyButton)
        
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addCurrencyButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 10),
            addCurrencyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: addCurrencyButton.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func amountDidChange() {
        guard let text = amountTextField.text, let amount = Double(text) else {
            baseAmount = 0
            tableView.reloadData()
            return
        }
        
        baseAmount = amount
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        tableView.reloadRows(at: visibleIndexPaths, with: .none)
    }
    
    @objc private func addCurrency() {
        showCurrencyPicker(forAdding: true)
    }
    
    @objc private func selectCurrency(_ sender: UIButton) {
        let row = sender.tag
        showCurrencyPicker(forRow: row)
    }
    
    private func showCurrencyPicker(forRow row: Int? = nil, forAdding: Bool = false) {
        let alertController = UIAlertController(title: "Выберите валюту", message: nil, preferredStyle: .actionSheet)
        
        for currency in exchangeRates.keys where !currencyCodes.contains(currency) || (row != nil && currencyCodes[row!] == currency) {
            let action = UIAlertAction(title: currency, style: .default) { _ in
                if let row = row {
                    self.currencyCodes[row] = currency
                } else if forAdding {
                    self.currencyCodes.append(currency)
                }
                self.tableView.reloadData()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate & DataSource
extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        let currencyCode = currencyCodes[indexPath.row]
        
        cell.configure(with: currencyCode, amount: baseAmount, exchangeRates: exchangeRates)
        cell.currencyButton.tag = indexPath.row
        cell.currencyButton.addTarget(self, action: #selector(selectCurrency(_:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension MainController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let amount = Double(text) else { return }
        baseAmount = amount
        tableView.reloadData()
    }
}
