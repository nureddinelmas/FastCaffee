//
//  OrderViewModel.swift
//  HotCoffe
//
//  Created by Nureddin Elmas on 2022-11-12.
//

import Foundation


class OrderListViewModel {
    var orderViewModel : [OrderViewModel]
    
    init(){
        self.orderViewModel = [OrderViewModel]()
    }
}


extension OrderListViewModel {
    func orderViewModel(at index : Int) -> OrderViewModel {
        return self.orderViewModel[index]
    }
}



struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
   
    var name : String {
        return self.order.name
    }
    
    var email : String {
        return self.order.email
    }
    
   var type: String {
        return self.order.type.rawValue.capitalized
     //  return self.order.type
    }
    
    var size : String {
       return self.order.size.rawValue.capitalized
       // return self.order.size
    }
}
