//
//  ProductsViewController.swift
//  InventoryGUI
//
//  Created by Mauricio Figueroa on 8/30/18.
//  Copyright © 2018 Mauricio Figueroa. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSONProductsData(uri: "http://localhost:3001/products") { _ in
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }//end getJSONProductsData
    }//end viewDidLoad
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.products.count
    }//end numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        cell.name.text = Model.products[indexPath.row].Product_Name
        cell.totalQty.text = "\(String(describing: Model.products[indexPath.row].Total_Qty!))"
        cell.remainingQty.text = "\(String(describing: Model.products[indexPath.row].Remaining_Qty!))"
        cell.warehouse.text = Model.products[indexPath.row].Warehouse_Name
        return cell
    }//end cellForRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = Model.products[indexPath.row]
        let alertController = UIAlertController(title: "Update/Delete", message: "Product: \(String(describing: product.Product_Name!))", preferredStyle:.alert)
        
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let totalQty = alertController.textFields?[0].text
            let remainingQty = alertController.textFields?[1].text
            let warehouse = alertController.textFields?[2].text
            
            let uri = "http://localhost:3001/update_product_info"
            let request = NSMutableURLRequest(url: NSURL (string: uri)! as URL) //Creamos objeto NSMutableURLRequest con la uri
            request.httpMethod = "POST" //Llamamos metodo httpMethod POST
            
            let parameters = "product_name=\(String(describing: product.Product_Name!))&newTotal_Qty=\(String(describing: totalQty!))&newRemaining_Qty=\(String(describing: remainingQty!))&newWarehouse_Name=\(String(describing: warehouse!))"
            
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
            
            let uri = "http://localhost:3001/delete_product"
            let request = NSMutableURLRequest(url: NSURL (string: uri)! as URL) //Creamos objeto NSMutableURLRequest con la uri
            request.httpMethod = "POST" //Llamamos metodo httpMethod POST
            
            let parameters = "product_name=\(String(describing: product.Product_Name!))"
            
            request.httpBody = parameters.description.data(using: String.Encoding.utf8) //Se llama metodo httpBody
            let task = URLSession.shared.dataTask(with: request as URLRequest) { //Creamos dataTask de la URLSession
                data, response, error in
                if error != nil {
                    
                    return
                }//end if error
            }//end dataTask
            task.resume()//resume dataTask
            self.tableView.reloadData()
            self.viewDidLoad()
        }//end deleteAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alertController.dismiss(animated: true, completion:nil) })
        
        alertController.addTextField{(UITextField) in
            UITextField.text = "\(product.Total_Qty!)"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.text = "\(product.Remaining_Qty!)"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.text = product.Warehouse_Name!
        }//end addTextField
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated:  true, completion: nil)
        
    }//end didSelectRowAt
    
    func getJSONProductsData(uri: String, completion: @escaping ([Product]) -> ()) {
        
        let jsonUrlString = uri
        guard let url = URL(string:jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            print("imprimiendo data (bytes): ",data)
            
            do {
                Model.products = try JSONDecoder().decode([Product].self, from: data)
            }//end do
                
            catch let jsonError {
                print("Error serializing json: ", jsonError)
            }//end catch
            DispatchQueue.main.async {
                completion(Model.products)
            }//end DispatchQueue
        }//end dataTask
        .resume()
    }//end getJSONProductsData
    
    @IBAction func refreshButton(_ sender: Any) {
        getJSONProductsData(uri: "http://localhost:3001/products") { _ in
            self.tableView.reloadData()
        }//end getJSONProductsData
    }//end refreshButton
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "New product", message: "Enter product info", preferredStyle:.alert)
        alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (action) in alertController.dismiss(animated: true, completion:nil)
            let name = alertController.textFields?[0].text
            let totalQty = alertController.textFields?[1].text
            let remainingQty = alertController.textFields?[2].text
            let warehouse = alertController.textFields?[3].text

            let uri = "http://localhost:3001/create_product"
            let request = NSMutableURLRequest(url: NSURL (string: uri)! as URL) //Creamos objeto NSMutableURLRequest con la uri
            request.httpMethod = "POST" //Llamamos metodo httpMethod POST
            
            let parameters = "product_name=\(String(describing: name!))&total_qty=\(String(describing: totalQty!))&remaining_qty=\(String(describing: remainingQty!))&warehouse=\(String(describing: warehouse!))"

            request.httpBody = parameters.description.data(using: String.Encoding.utf8) //Se llama metodo httpBody
            let task = URLSession.shared.dataTask(with: request as URLRequest) { //Creamos dataTask de la URLSession
                data, response, error in
                if error != nil {
                    return
                }//end if error
            }//end dataTask
            task.resume()//ranaudamos dataTask que por default inicia en un estado suspendido
            self.tableView.reloadData()
            self.viewDidLoad()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alertController.dismiss(animated: true, completion:nil)
        }))
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Product name"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Total Qty"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Remaining Qty"
        }//end addTextField
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Warehouse"
        }//end addTextField
        
        self.present(alertController, animated: true, completion: nil)
    }//end addButton
}//end class
