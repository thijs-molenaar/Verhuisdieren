//
//  DetailImagesViewController.swift
//  Verhuisdieren
//
//  Created by Thijs on 02/09/2018.
//  Copyright © 2018 Thijs Molenaar. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import Kingfisher

class DetailImagesViewController : UIViewController {
    
    weak var selectedCat : Cat?
    var imageUrls : [String] = []
    var images : [UIImage] = []
    var imageIndex = 0
    
    // TODO: code cleanup, layout, create images+text view
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBAction func closeView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "searchCats")
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if imageIndex >= imageUrls.count - 1 {
            return
        }
        
        let placeholder = UIImage(named: "cat_placeholder")
        
        if sender.direction == .right {
            if imageIndex == 0 {
                return
            }
            imageIndex -= 1
            let url = URL(string: imageUrls[imageIndex])
            imageHolder.kf.setImage(with: url, placeholder: placeholder)
        }
        
        if sender.direction == .left {
            if imageIndex == imageUrls.count - 2 {
                return
            }
            imageIndex += 1
            let url = URL(string: imageUrls[imageIndex])
            imageHolder.kf.setImage(with: url, placeholder: placeholder)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftSwipeRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(_:)))
        leftSwipeRecognizer.direction = .left
        
        var rightSwipeRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(_:)))
        rightSwipeRecognizer.direction = .right
        
        imageHolder.isUserInteractionEnabled = true
        imageHolder.addGestureRecognizer(leftSwipeRecognizer)
        imageHolder.addGestureRecognizer(rightSwipeRecognizer)
        
        print(selectedCat?.detailUrl)
        scrapeSite(url: (selectedCat?.detailUrl)!)
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
            
            for swiperWrapper in doc.css("div.swiper-wrapper") {
                
                for swiperSlide in swiperWrapper.css("div.swiper-slide") {
                    
                    for img in swiperSlide.css("img") {
                        print(img["src"])
                        imageUrls.append(img["src"]!)
                    }
                    
                }
                
            }
            
            if imageUrls.count > 0 {
                let placeholder = UIImage(named: "cat_placeholder")
                let url = URL(string: imageUrls[0])
                imageHolder.kf.setImage(with: url, placeholder: placeholder)
                // TODO: set spinner while loading
            }
            
        }
        
    }
}
