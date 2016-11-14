//
//  EventsTableViewController.swift
//  ponominalu
//
//  Created by Kirill on 09.11.16.
//  Copyright © 2016 Rusalyow. All rights reserved.
//

import UIKit
var eventPath: Event!

class EventsTableViewController: UITableViewController {
    var events = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel()
        getEvents()
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
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        cell.nameLbl.text = events[indexPath.row].nameEvent
        cell.dateLbl.text = events[indexPath.row].dateEvent
        let imgLink = events[indexPath.row].imgEvent
        DispatchQueue.main.async {
            let imgURL: URL = URL(string: imgLink)!
            let imageData = try? Data(contentsOf: imgURL)
            cell.eventImage.image = UIImage(data: imageData!)
        }
        return cell
    }
    
    func titleLabel(){
        let titleLabel = UILabel(frame: CGRect(x: 11, y: 11, width: 15, height: 15 ))
        titleLabel.text = categoryPath.nameCategory
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
    }
    

    func getEvents(){
        let loadURL = "http://poligon.cultserv.ru/v4/events/list?session=sesson_iphone_2015_ponominalu_msk&category_id=\(categoryPath.idCateogry)"
        let request = URLRequest(url: NSURL(string:loadURL) as! URL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request as URLRequest){data,response,error in
            if let error = error{
                print(error)
                return
            }
            if let data = data{
                self.events = self.parseJsonData(data: data as NSData)
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    
    func parseJsonData(data: NSData) -> [Event]{
        do{
            let jsonResult = try JSONSerialization.jsonObject(with: data as Data) as! NSDictionary
            let jsonCaterogies = jsonResult["message"] as! [AnyObject]
            for jsonCategory in jsonCaterogies{
                let event = Event()
                event.nameEvent = jsonCategory["title"] as! String
                event.idEvent = jsonCategory["id"] as! Int
                let subCat = jsonCategory["subevents"] as! Array<NSDictionary>
                for subCategory in subCat{
                    if subCategory["date"] != nil{
                        let date = subCategory["date"] as! String
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        let dateDate = dateFormat.date(from: date)
                        let calendar = Calendar(identifier: .gregorian)
                        let dateComponents = calendar.dateComponents([.day, .month, .year], from: dateDate!)
                        event.dateEvent = "\(dateComponents.day!).\(dateComponents.month!)"
                    }
                    if subCategory["image"] != nil{
                        let imageLink = subCategory["image"] as! String
                        let loadImageURL = "http://media.cultserv.ru/i/80x80/\(imageLink)"
                        let bigLoadImageURL = "http://media.cultserv.ru/i/300x300/\(imageLink)"
                        event.imgEvent = loadImageURL
                        event.bigImgEvent = bigLoadImageURL
                    }
                    let venue = subCategory["venue"] as! NSDictionary
                        event.placeEvent = venue["title"] as! String
                }
                events.append(event)
            }
        } catch{
            print(error)
        }
        return events
    }
    
  

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToDetail", sender: self)
        eventPath = events[indexPath.row]
    }
}
