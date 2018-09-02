//
//  SearchViewController.swift
//  Verhuisdieren
//
//  Created by Thijs on 01/09/2018.
//  Copyright © 2018 Thijs Molenaar. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

struct Constants {
    struct SearchViewControllerConstants {
        static let verhuisDierenScrapeUrl = "https://www.verhuisdieren.nl/alle-dieren/adoptiedieren/kat"
        static let catCellIdentifier = "catCell"
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var catsTableView: UITableView!
    
    var cats: [String] = ["barry", "alpha"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //scrapeSite(url: Constants.SearchViewControllerConstants.verhuisDierenScrapeUrl)
        catsTableView.dataSource = self
        catsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SearchViewControllerConstants.catCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = cats[row]
        
        var imageName = UIImage(named: "cat_placeholder")
        cell.imageView?.image = imageName
        
        return cell
    }
    
    func scrapeSite(url: String) {
        Alamofire.request(url).responseString { response in
            if response.result.isSuccess {
                if let html = response.result.value {
                    self.parseAdoptieKatHtml(html: html)
                }
            }
            else {
                NSLog("Request to site unsuccessful");
            }
        }
    }
    
    func parseAdoptieKatHtml(html: String) {
        if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
            print(doc.title)
        }
    }
}
