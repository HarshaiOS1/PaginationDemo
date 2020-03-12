//
//  ManufacturerModel.swift
//  PaginationDemoPOC
//
//  Created by Harsha on 10/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation

// MARK: - Manufacturers
struct ManufacturersModel: Codable {
    var page, pageSize, totalPageCount: Int?
    var wkda: [String: String]?
}

// MARK: - CarModel
struct CarModel: Codable {
    var page, pageSize, totalPageCount: Int?
    var wkda: [String: String]?
    
}
