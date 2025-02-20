//
//  conversionRate.swift
//  Converter
//
//  Created by Victor Mashukevich on 3.11.24.
//

import Foundation
import UIKit

class CurrencyCell: UITableViewCell {
    
    let currencyButton = UIButton(type: .system)
        let convertedAmountLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    private func setupUI() {
        
        backgroundColor = .cellBackground
        
            currencyButton.translatesAutoresizingMaskIntoConstraints = false
            currencyButton.setTitleColor(.accentBlue, for: .normal)
            currencyButton.layer.borderColor = UIColor.accentBlue.cgColor
            currencyButton.layer.borderWidth = 1.0
            currencyButton.layer.cornerRadius = 8
        
            convertedAmountLabel.translatesAutoresizingMaskIntoConstraints = false
            convertedAmountLabel.textAlignment = .left
            convertedAmountLabel.textColor = .primaryText
        
            
            contentView.addSubview(currencyButton)
            contentView.addSubview(convertedAmountLabel)
            
            NSLayoutConstraint.activate([
                
                currencyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                currencyButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                currencyButton.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.bounds.width * 0.4),

                convertedAmountLabel.leadingAnchor.constraint(equalTo: currencyButton.trailingAnchor, constant: 10),
                convertedAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                convertedAmountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    func configure(with currencyCode: String, amount: Double, exchangeRates: [String: Double]) {
            currencyButton.setTitle(currencyCode, for: .normal)
            
            if let baseRate = exchangeRates[currencyCode] {
                let convertedAmount = amount * baseRate
                convertedAmountLabel.text = String(format: "%.2f", convertedAmount)
            } else {
                convertedAmountLabel.text = "N/A"
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            convertedAmountLabel.text = nil
        }
}
