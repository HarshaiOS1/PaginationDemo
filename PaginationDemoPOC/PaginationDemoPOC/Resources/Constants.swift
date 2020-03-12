//
//  Constants.swift
//  PaginationDemoPOC
//
//  Created by Harsha on 10/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation

struct NetworkConstants {
    static let baseURl = "http://api-aws-eu-qa-1.auto1-test.com/"
    
    static let manufacturerAPIext = "v1/car-types/manufacturer"
    
    static let carTypeAPIext = "v1/car-types/main-types"
    
    static let authKey = "coding-puzzle-client-449cc9d​"
    
    static let positiveStatusCodes = [200,201,202,203,204]
}

//MARK : Class extension
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
