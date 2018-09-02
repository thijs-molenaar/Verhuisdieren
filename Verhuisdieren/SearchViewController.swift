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
import Kingfisher

struct Constants {
    struct SearchViewControllerConstants {
        static let verhuisDierenScrapeUrl = "https://www.verhuisdieren.nl/alle-dieren/adoptiedieren/kat"
        static let catCellIdentifier = "catCell"
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var catsTableView: UITableView!
    
    // TODO: make cat data class with: name / place / thumburl / detailurl etc.
    var cats: [String] = [
        "moos",
        "suki"
    ]
    
    var catsDetail: [String:String] = [
        "moos" : "https://www.verhuisdieren.nl/images/small-thumb/cropped-1535824165-sqf4Yf6B1W.jpg",
        "suki" : "https://www.verhuisdieren.nl/images/small-thumb/cropped-1535878005-pVe42hkYHL.jpg"
    ]
    
    var retrievedCats: [Cat] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrapeSite(url: Constants.SearchViewControllerConstants.verhuisDierenScrapeUrl)
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
        
        let placeholder = UIImage(named: "cat_placeholder")
        let url = URL(string: catsDetail[cats[row]]!)
        cell.imageView?.kf.setImage(with: url, placeholder: placeholder, completionHandler: {
            (image, error, cacheType, imageUrl) in
            // image: Image? `nil` means failed
            // error: NSError? non-`nil` means failed
            // cacheType: CacheType
            //                  .none - Just downloaded
            //                  .memory - Got from memory cache
            //                  .disk - Got from disk cache
            // imageUrl: URL of the image
            
        })
        
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
            
            for node in doc.css("div.items--all-animals div.row ") {
                
                for figure in node.css("figure") {
                    //print(figure.text)
                    var cat = Cat()
                    
                    // set name
                    for name in figure.css("h3") {
                        print(name.text)
                        cat.name = name.text
                    }
                    
                    // set thumbnailUrl
                    for thumbnail in figure.css("img") {
                        cat.thumbnailUrl = thumbnail["src"]
                    }
                    
                    // set city
                    for city in figure.css("p") {
                        cat.city = city.text
                    }
                    
                    // set date
                    for date in figure.css("span.date") {
                        cat.date = date.text
                    }
                    
                    // set detailUrl
                    for detail in figure.css("a") {
                        cat.detailUrl = detail["href"]
                    }
                    
                    retrievedCats.append(cat)
                    
                }
                
            }
        }
        
    }
}
