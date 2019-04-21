//
//  UIViewController+Alert.swift
//  DZ_SystemControllers
//
//  Created by user on 21/04/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert,animated: true)
    }
    
}
