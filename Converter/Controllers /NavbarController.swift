//
//  NavbarController.swift
//  Converter
//
//  Created by Victor Mashukevich on 3.11.24.
//

import Foundation
import UIKit

final class NavbarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure(){
        view.backgroundColor =  .systemGray
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.fontNames(forFamilyName: "Helvetica")
        ]
    }
}
