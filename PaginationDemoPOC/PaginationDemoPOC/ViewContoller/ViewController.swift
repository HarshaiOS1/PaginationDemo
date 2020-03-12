//
//  ViewController.swift
//  PaginationDemoPOC
//
//  Created by Harsha on 10/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var brandListTableView: UITableView!
    var viewModel = ManufacturerListViewModel()
    
    fileprivate var reachedEndOfItems = false
    fileprivate var lazyLoadingStartsAtIndex = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getBrandListDetails()
        updateUI()
    }
    
    func updateUI() {
        self.title = "Manufacturer's List"
        
        brandListTableView.delegate = self
        brandListTableView.dataSource = self
        brandListTableView.tableFooterView = UIView()
        brandListTableView.register(UINib(nibName: "LoadingIndicatorTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingIndicatorTableViewCell")
    }
    
    func getBrandListDetails() {
        viewModel.getManufacturerList(page: 0) { (issuccess, message) in
            if !issuccess {
                print(message ?? "error")
            } else {
                DispatchQueue.main.async {
                    self.brandListTableView.reloadData()
                }
            }
        }
    }
    
    deinit {
        NSLog("deinit: ViewController")
    }
}

//MARK: UITableViewDataSource & UITableViewDelegate
extension ViewController : UITableViewDataSource, UITableViewDelegate {
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
                (indexPath.row % 2 == 0) ? (cell.backgroundColor = UIColor.lightGray) : (cell.backgroundColor = UIColor.placeholderText)
                if (indexPath.row <= (viewModel.sortedBrandList?.count ?? 0) - 1) {
                    cell.titleLabel?.text = viewModel.sortedBrandList?[indexPath.row] ?? ""
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // navigate and update selection
        if !(indexPath.row == (viewModel.model?.wkda?.keys.count ?? 0)) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(identifier: "CarModelListViewController") as? CarModelListViewController {
                if let _manufacturer = viewModel.sortedBrandList?[indexPath.row] {
                    vc.manufacturer = [viewModel.getManufacturerIDForValue(manufacturerName: _manufacturer) ?? "" : _manufacturer]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let model = viewModel.model{
            if indexPath.row == lazyLoadingStartsAtIndex && reachedEndOfItems == false {
                reachedEndOfItems = true
                if !(((model.page ?? 0) - 1) == model.totalPageCount){
                    viewModel.getManufacturerList(page: ((model.page ?? 0) + 1)) { (isSuccess, message) in
                        if isSuccess {
                            self.reachedEndOfItems = false
                            self.lazyLoadingStartsAtIndex = (model.wkda?.keys.count ?? 0) - 1
                            DispatchQueue.main.async {
                                self.brandListTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
