//
//  Extension.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 10/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


// MARK: - Float extension

extension Float {
    
    // MARK: - Pretty printed numbers
    
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
}
