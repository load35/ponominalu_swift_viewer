//
//  DetailEventViewController.swift
//  ponominalu
//
//  Created by Kirill on 12.11.16.
//  Copyright © 2016 Rusalyow. All rights reserved.
//

import UIKit

class DetailEventViewController: UIViewController {
    var events = [Event]()
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDesc: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        eventName.text = eventPath.nameEvent
        let imageData = try? Data(contentsOf: URL(string:eventPath.bigImgEvent)!)
        eventImage.image = UIImage(data: imageData!)
        eventPlace.text = eventPath.placeEvent
        eventDate.text = eventPath.dateEvent
        let loadDescURL = "http://poligon.cultserv.ru/v4/subevents/description/get?session=sesson_iphone_2015_ponominalu_msk&id=\(eventPath.idEvent)"
        let request = URLRequest(url: NSURL(string:loadDescURL) as! URL)
        let urlSession = URLSession.shared
        DispatchQueue.global(qos: .userInitiated).async {
        let task = urlSession.dataTask(with: request as URLRequest){data,response,error in
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data! as Data) as! NSDictionary
                DispatchQueue.main.async {
                    let textWithTags = (jsonResult["message"] as! String)
                    let textWithOutTags = textWithTags.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    self.eventDesc.text = textWithOutTags
                }
            }
            catch{
                print(error)
            }
            }
        task.resume()
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
