//
//  Inventory.swift
//  InventoryGUI
//
//  Created by Mauricio Figueroa on 8/30/18.
//  Copyright © 2018 Mauricio Figueroa. All rights reserved.
//

import Foundation

class Inventory: Decodable {
    
    var Product_Name: String?
    var On_Stock: Int?
    var Sold: Int?
    var Total: Int?
    var Warehouse: String?
    var MinProduct: Int?
    var MaxProduct: Int?
    
}//end Inventory
