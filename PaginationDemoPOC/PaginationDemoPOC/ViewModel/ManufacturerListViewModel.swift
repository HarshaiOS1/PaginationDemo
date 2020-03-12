//
//  ManufacturerListViewModel.swift
//  PaginationDemoPOC
//
//  Created by Harsha on 10/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation

class ManufacturerListViewModel: NSObject {
    var model: ManufacturersModel?
    var sortedBrandList: [String]?
    func getManufacturerList(page: Int ,completion: @escaping (Bool, String?) -> Void) {
        let baseURL = NetworkConstants.baseURl + NetworkConstants.manufacturerAPIext //"http://api-aws-eu-qa-1.auto1-test.com/v1/car-types/manufacturer"
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: String(page)),
                                     URLQueryItem(name: "pageSize", value: "15"),
                                     URLQueryItem(name: "wa_key", value: "coding-puzzle-client-449cc9d")]
        if let url = urlComponents?.url{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                if error != nil {
                    completion(false, "error")
                }
                let string1 = String(data: data ?? Data(), encoding: String.Encoding.utf8) ?? "Data could not be printed"
                print(string1)
                guard let _data = data else {
                    completion(false, "no data")
                    return
                }
                do {
                    let decodModel =  try JSONDecoder().decode(ManufacturersModel.self, from: _data)
                    if self.model == nil {
                        self.model = decodModel
                        self.sortedBrandList = self.model?.wkda?.values.sorted()
                    } else {
                        self.model?.page = decodModel.page
                        if let dict = decodModel.wkda {
                            self.model?.wkda?.merge(dict: dict)
                        }
                        self.sortedBrandList = self.model?.wkda?.values.sorted()
                    }
                    completion(true, "got data ")
                } catch {
                    completion(false, "error")
                }
            }.resume()
        }
    }
    
    func getManufacturerIDForValue(manufacturerName: String) -> String? {
        if let dict = model?.wkda {
            for (key, value) in dict {
                if value == manufacturerName {
                    return key
                }
            }
        }
        return nil
    }
}
