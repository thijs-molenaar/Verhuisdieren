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
    }
}

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrapeSite(url: Constants.SearchViewControllerConstants.verhuisDierenScrapeUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
