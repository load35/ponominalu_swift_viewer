//
//  StartViewController.swift
//  ponominalu
//
//  Created by Kirill on 09.11.16.
//  Copyright © 2016 Rusalyow. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var startImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlImg = "http://spasibosberbank.ru/media/uploads/logo-ponominalu.png"
        let imgURL: URL = URL(string: urlImg)!
        let imageData = try? Data(contentsOf: imgURL)
        startImage.image = UIImage(data: imageData!)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let timer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.tapAction(_:)), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @IBAction func tapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCategories", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
