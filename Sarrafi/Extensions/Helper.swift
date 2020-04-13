//
//  Helper.swift
//  Sarrafi
//
//  Created by armin on 1/23/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit

extension UIViewController {
    open override func awakeFromNib() {
        super.awakeFromNib()
        navigationController?.view.semanticContentAttribute = .forceRightToLeft
        navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
    }
}
