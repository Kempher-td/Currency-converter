//
//  UiTextField + ext.swift
//  Converter
//
//  Created by Victor Mashukevich on 21.11.24.
//

import UIKit

extension UITextField {
    func addDoneAndCancelButtonsOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc private func cancelButtonTapped() {
        self.text = ""
        self.resignFirstResponder()
    }
    
    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
}


