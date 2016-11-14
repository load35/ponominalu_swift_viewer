//
//  CategoiresTableViewController.swift
//  ponominalu
//
//  Created by Kirill on 09.11.16.
//  Copyright © 2016 Rusalyow. All rights reserved.
//

import UIKit
import CoreData
var categoryPath: Categories!

class CategoiresTableViewController: UITableViewController {
    let loadURL = "http://poligon.cultserv.ru/v4/categories/list?session=sesson_iphone_2015_ponominalu_msk"
    var categories : [Categories] = []
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        if context == nil{
        getCategories()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryNameLabel.text = categories[indexPath.row].nameCategory
        cell.categoryCountLabel.text = String(categories[indexPath.row].countCategory)
        return cell
    }
    
    func getCategories(){
        let request = URLRequest(url: NSURL(string:loadURL) as! URL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest){data,response,error in
            
            if let error = error{
                print(error)
                return
            }
            
            if let data = data{
                self.categories = self.parseJsonData(data: data as NSData)
                OperationQueue.main.addOperation({ 
                    self.tableView.reloadData()
                })
                }
            }
        task.resume()
        }
    
    
    func parseJsonData(data: NSData) -> [Categories]{
        
        do{
            let jsonResult = try JSONSerialization.jsonObject(with: data as Data) as! NSDictionary
            let jsonCaterogies = jsonResult["message"] as! [AnyObject]
            for jsonCategory in jsonCaterogies{
                let categoryCore = Categories(context: context)
                categoryCore.nameCategory = jsonCategory["title"] as? String
                categoryCore.countCategory = Int32(jsonCategory["events_count"] as! Int)
                categoryCore.idCateogry = Int32(jsonCategory["id"] as! Int)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                categories.append(categoryCore)
            }
        } catch{
          print(error)
        }
        return categories
        
    }
    func getData(){
        do{
        categories = try context.fetch(Categories.fetchRequest())
        }
        catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToEvents", sender: self)
        categoryPath = categories[indexPath.row]
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            let cat = categories[indexPath.row]
//            context.delete(cat)
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//        
//            
//            
////            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
