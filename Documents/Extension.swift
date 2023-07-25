//
//  Extension.swift
//  Documents
//
//  Created by Алексей Калинин on 25.07.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        for i in subviews {
            self.addSubview(i)
        }
    }
}
