//
//  InventoryViewController.swift
//  InventoryGUI
//
//  Created by Mauricio Figueroa on 8/30/18.
//  Copyright © 2018 Mauricio Figueroa. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getJSONInventoryData(uri: "http://localhost:3001/inventory") { _ in
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }//end getJSONInventoryData
    }//end viewDidLoad
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.inventory.count
    }//end numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InventoryCell
        cell.productName.text = Model.inventory[indexPath.row].Product_Name
        cell.onStock.text = "\(String(describing: Model.inventory[indexPath.row].On_Stock!))"
        cell.sold.text = "\(String(describing: Model.inventory[indexPath.row].Sold!))"
        cell.total.text = "\(String(describing: Model.inventory[indexPath.row].Total!))"
        cell.warehouse.text = Model.inventory[indexPath.row].Warehouse
        
        if Model.inventory[indexPath.row].On_Stock! > Model.inventory[indexPath.row].MaxProduct! {
            cell.onStock.backgroundColor = #colorLiteral(red: 0.9578202435, green: 0.9607843161, blue: 0.2103817326, alpha: 1)
        }//end if
        
        if Model.inventory[indexPath.row].On_Stock! < Model.inventory[indexPath.row].MinProduct! {
            cell.onStock.backgroundColor = #colorLiteral(red: 0.8603267766, green: 0.1760058155, blue: 0.08719307171, alpha: 1)
        }//end if

        
        if Model.inventory[indexPath.row].On_Stock! == Model.inventory[indexPath.row].MaxProduct! {
            cell.onStock.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }//end if
    
        return cell
    }//end cellForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }//end heightForRowAt
    
    
    func getJSONInventoryData(uri: String, completion: @escaping ([Inventory]) -> ()) {
        let jsonUrlString = uri
        guard let url = URL(string:jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            print("printing data (bytes): ",data)
            
            do {
                Model.inventory = try JSONDecoder().decode([Inventory].self, from: data)
            }//end do
                
            catch let jsonError {
                print("Error serializing json: ", jsonError)
            }//end catch
            
            DispatchQueue.main.async {
                completion(Model.inventory)
            }//end DispatchQueue
        }//end dataTask
        .resume()
    }//end getJSONInventoryData
    
    @IBAction func refreshButton(_ sender: Any) {
        getJSONInventoryData(uri: "http://localhost:3001/inventory") { _ in
            self.tableView.reloadData()
        }//end getJSONInventoryData
    }//end refreshButton
}//end class




