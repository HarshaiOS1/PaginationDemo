//
//  CarModelListViewController.swift
//  PaginationDemoPOC
//
//  Created by Harsha on 10/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation
import UIKit

class CarModelListViewController: UIViewController {
    
    @IBOutlet weak var modelTableView: UITableView!
    
    let viewModel = CarmodelListViewModel()
    var manufacturer: [String : String]?
    fileprivate var reachedEndOfItems = false
    fileprivate var lazyLoadingStartsAtIndex = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        getModelListDetails()
    }
    
    func updateUI() {
        modelTableView.delegate = self
        modelTableView.dataSource = self
        modelTableView.tableFooterView = UIView()
        modelTableView.register(UINib(nibName: "LoadingIndicatorTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingIndicatorTableViewCell")
    }
    
    func getModelListDetails() {
        viewModel.getCarModelList(manufacturer: String(manufacturer?.first?.key ?? ""), page: 0) { (isSuccess, message) in
            if !isSuccess {
                print(message ?? "error")
            } else {
                DispatchQueue.main.async {
                    self.modelTableView.reloadData()
                }
            }
        }
    }
    
    deinit {
        NSLog("deinit : CarModelListViewController")
    }
}

//MARK: UITableViewDataSource & UITableViewDelegate
extension CarModelListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel.model?.wkda?.keys.count {
            return count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.model else {
            return UITableViewCell.init()
        }
        if !(indexPath.row == (model.wkda?.keys.count ?? 0)) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ManufactureListTableViewCell", for: indexPath) as? ManufactureListTableViewCell {
                (indexPath.row % 2 == 0) ? (cell.backgroundColor = UIColor.placeholderText) : (cell.backgroundColor = UIColor.lightGray)
                if (indexPath.row <= (viewModel.sortedCarList?.count ?? 0) - 1) {
                    cell.titleLabel?.text = viewModel.sortedCarList?[indexPath.row] ?? ""
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        guard let loaderCell = tableView.dequeueReusableCell(withIdentifier: "LoadingIndicatorTableViewCell", for: indexPath) as? LoadingIndicatorTableViewCell else {
            return UITableViewCell.init()
        }
        loaderCell.activityIndicator.startAnimating()
        loaderCell.selectionStyle = .none
        return loaderCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let model = viewModel.model{
            if indexPath.row == lazyLoadingStartsAtIndex && reachedEndOfItems == false {
                reachedEndOfItems = true
                if !(((model.page ?? 0) - 1) == model.totalPageCount){
                    viewModel.getCarModelList(manufacturer: String(manufacturer?.first?.key ?? ""), page: ((model.page ?? 0) + 1)) { (isSuccess, message) in
                        if isSuccess {
                            self.reachedEndOfItems = false
                            self.lazyLoadingStartsAtIndex = (model.wkda?.keys.count ?? 0) - 1
                            DispatchQueue.main.async {
                                self.modelTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(indexPath.row == (viewModel.model?.wkda?.keys.count ?? 0)) {
            let alertVC = UIAlertController.init(title: "Car Selected", message: "Brand : \(String(describing: manufacturer?.first?.value ?? "")) \n Model : \(viewModel.sortedCarList?[indexPath.row] ?? "")", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
