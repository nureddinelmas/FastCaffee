//
//  OrdersTableViewController.swift
//  HotCoffe
//
//  Created by Nureddin Elmas on 2022-11-10.
//

import Foundation
import UIKit

class OrdersTableViewController : UITableViewController{
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        populateOrders()
    }
    
    
    
    private func populateOrders () {
        
        guard let coffeUrl = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("The Url has not exist")
            return
        }
        
        let resource = Resource<[Order]>(url: coffeUrl)
        
        Webservice().load(resource: resource) { [weak self] result in
            
            switch result {
            case .success(let orders):
                 print(orders)
                self?.orderListViewModel.orderViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                
                print(error)
            }
            
            
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.orderViewModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.name.capitalized
        cell.detailTextLabel?.text = vm.size.capitalized
        
        return cell
    }
}
