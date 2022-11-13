//
//  Order.swift
//  HotCoffe
//
//  Created by Nureddin Elmas on 2022-11-10.
//

import Foundation



struct Order : Codable {
   
    let name: String
    let email : String
    let type : CoffeType
    let size : CoffeSize
}

enum CoffeType : String, Codable, CaseIterable {
    case cappucino
    case latte
    case expresso
    case cartado
}

enum CoffeSize : String, Codable, CaseIterable {
    case small
    case medium
    case large
}


extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is not correct")
            
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeOrderViewModel) -> Resource<Order?> {
        
        
        let order = Order(vm)
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is not correct")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order! ")
        }
            
            var resource = Resource<Order?>(url: url)
            resource.httpMethod = HttpMethod.post
            resource.body = data
            
            
        return resource
    }
    
}
extension Order {
    init?(_ vm : AddCoffeOrderViewModel){
        guard let name = vm.name,
             let email = vm.email,
              let selectedType = CoffeType(rawValue: (vm.selectedType?.lowercased())!),
              let selectedSize = CoffeSize(rawValue: (vm.selectedSize?.lowercased())!) else { return nil}
                
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}
