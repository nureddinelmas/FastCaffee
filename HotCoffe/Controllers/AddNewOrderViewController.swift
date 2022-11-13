//
//  AddNewOrderViewController.swift
//  HotCoffe
//
//  Created by Nureddin Elmas on 2022-11-10.
//

import Foundation
import UIKit

protocol AddCoffeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller : UIViewController)
    func addCoffeOrderViewControllerDidClose(controller: UIViewController)
}

class AddNewOrderViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var delegate : AddCoffeOrderDelegate?
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    
    private var vm = AddCoffeOrderViewModel()
    
    private var coffeSizesSegmentedControl : UISegmentedControl!
    
    
    override func viewDidLoad() {
        setupUI()
        // self.tableView.delegate = self
       // self.tableView.dataSource = self
    }

    private func setupUI(){
        self.coffeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        self.coffeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeSizesSegmentedControl)
        
        self.coffeSizesSegmentedControl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 40).isActive = true
        
        self.coffeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.vm.types[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func close() {
        if let delegate = self.delegate {
            delegate.addCoffeOrderViewControllerDidClose(controller: self)
        }
    }
    
    @IBAction func save() {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        let selectedSize = self.coffeSizesSegmentedControl.titleForSegment(at: self.coffeSizesSegmentedControl.selectedSegmentIndex)
    
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee")
        }
        
        self.vm.name = name
        self.vm.email = email
        
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case .success(let order) :
                if let order = order , let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
                print(order)
            case .failure(let error) :
                print(error)
            }
        }
        
    }
    
}
