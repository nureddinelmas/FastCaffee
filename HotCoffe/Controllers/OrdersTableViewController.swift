//
//  OrdersTableViewController.swift
//  HotCoffe
//
//  Created by Nureddin Elmas on 2022-11-10.
//

import Foundation
import UIKit

class OrdersTableViewController : UITableViewController, AddCoffeOrderDelegate{
    
    // Add delegate functions of AddCoffeOrderDelegate
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.orderViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addCoffeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        populateOrders()
    }
    
    
    
    private func populateOrders () {
        /*
        guard let coffeUrl = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("The Url has not exist")
            return
        }
        */
       //  let resource = Resource<[Order]>(url: coffeUrl)
        
        Webservice().load(resource: Order.all) { [weak self] result in
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addCoffeOrderVC = navC.viewControllers.first as? AddNewOrderViewController else {
            fatalError("Error performing segue ! ")
        }
        
        addCoffeOrderVC.delegate = self
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
