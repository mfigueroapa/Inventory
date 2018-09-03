//
//  WarehousesViewController.swift
//  InventoryGUI
//
//  Created by Mauricio Figueroa on 8/30/18.
//  Copyright © 2018 Mauricio Figueroa. All rights reserved.
//

import UIKit

class WarehousesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSONWarehousesData(uri: "http://localhost:3001/warehouses") { _ in
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }//end getJSONWarehousesDAta
    }//end viewDidLoad
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.warehouses.count
    }//end numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "warehouseCell", for: indexPath) as! WarehouseCell
        cell.warehouseName.text = Model.warehouses[indexPath.row].Warehouse_name
        cell.minProduct.text = "\(String(describing: Model.warehouses[indexPath.row].Min_Product!))"
        cell.maxProduct.text = "\(String(describing: Model.warehouses[indexPath.row].Max_Product!))"
        return cell
    }//end cellForRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let warehouse = Model.warehouses[indexPath.row]
        let alertController = UIAlertController(title: "Update/Delete", message: "Warehouse: \(String(describing: warehouse.Warehouse_name!))", preferredStyle:.alert)
        
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let minProduct = alertController.textFields?[0].text
            let maxProduct = alertController.textFields?[1].text
            
            let uri = "http://localhost:3001/update_warehouse_info"
            let request = NSMutableURLRequest(url: NSURL (string: uri)! as URL)
            request.httpMethod = "POST" //Post Method
            
            let parameters = "warehouse_name=\(String(describing: warehouse.Warehouse_name!))&minproduct=\(String(describing: minProduct!))&maxproduct=\(String(describing: maxProduct!))"//indicate parameters for server
            
            request.httpBody = parameters.description.data(using: String.Encoding.utf8) //Se llama metodo httpBody
            let task = URLSession.shared.dataTask(with: request as URLRequest) { //Creamos dataTask de la URLSession
                data, response, error in
                if error != nil {
                    return
                }//end if error
            }//end dataTask
            task.resume()
            self.tableView.reloadData()
            self.viewDidLoad()
        }//end updateAction
        
        let deleteAction = UIAlertAction(title: "Delete product", style:.default){(_) in
            let uri = "http://localhost:3001/delete_warehouse"
            let request = NSMutableURLRequest(url: NSURL (string: uri)! as URL) //Creamos objeto NSMutableURLRequest con la uri
            request.httpMethod = "POST" //Llamamos metodo httpMethod POST
            
            let parameters = "warehouse_name=\(String(describing: warehouse.Warehouse_name!))"
            
            request.httpBody = parameters.description.data(using: String.Encoding.utf8) //Se llama metodo httpBody
            let task = URLSession.shared.dataTask(with: request as URLRequest) { //Creamos dataTask de la URLSession
                data, response, error in
                if error != nil {
                    return
                }//end if error
            }//end dataTask
            task.resume()
            self.tableView.reloadData()
            self.viewDidLoad()
        }//end deleteAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alertController.dismiss(animated: true, completion:nil) })
        
        alertController.addTextField{(UITextField) in
            UITextField.text = "\(warehouse.Min_Product!)"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.text = "\(warehouse.Max_Product!)"
        }//end addTextField
    
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated:  true, completion: nil)
    }//end didSelectRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }//end heightForRowAt
    
    func getJSONWarehousesData(uri: String, completion: @escaping ([Warehouse]) -> ()) {
        let jsonUrlString = uri
        guard let url = URL(string:jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do {
                Model.warehouses = try JSONDecoder().decode([Warehouse].self, from: data)
            }//end do
            catch let jsonError {
                print("Got the following error while serializing JSON:", jsonError)
            }//end catch
            DispatchQueue.main.async {
                completion(Model.warehouses)
            }//end DispatchQueue
        }//end dataTask
        .resume()
    }//end getJSONWarehouseData
    
    @IBAction func refreshButton(_ sender: Any) {
        getJSONWarehousesData(uri: "http://localhost:3001/warehouses") { _ in
            self.tableView.reloadData()
        }//end getJSONWarehousesData
    }//end refreshButton
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "New warehouse", message: "Enter warehouse info", preferredStyle:.alert)
        alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (action) in alertController.dismiss(animated: true, completion:nil)
            let name = alertController.textFields?[0].text
            let minproduct = alertController.textFields?[1].text
            let maxproduct = alertController.textFields?[2].text
            let uri = "http://localhost:3001/create_warehouse"
            let request = NSMutableURLRequest(url: NSURL (string: uri)! as URL) //Creamos objeto NSMutableURLRequest con la uri
            request.httpMethod = "POST"
            let parameters = "warehouse_name=\(String(describing: name!))&minproduct=\(String(describing: minproduct!))&maxproduct=\(String(describing: maxproduct!))"
            
            request.httpBody = parameters.description.data(using: String.Encoding.utf8) //Se llama metodo httpBody
            let task = URLSession.shared.dataTask(with: request as URLRequest) { //Creamos dataTask de la URLSession
                data, response, error in
                if error != nil {
                    return
                }//end if error
            }//end dataTsk
            task.resume()
            self.tableView.reloadData()
            self.viewDidLoad()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alertController.dismiss(animated: true, completion:nil)
        }))
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Warehouse name"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Min Product"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Max Product"
        }//end addTextField
        
        self.present(alertController, animated: true, completion: nil)
    }//end addButton
}//end class
