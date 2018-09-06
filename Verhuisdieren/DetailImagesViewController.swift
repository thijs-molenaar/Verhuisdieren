//
//  DetailImagesViewController.swift
//  Verhuisdieren
//
//  Created by Thijs on 02/09/2018.
//  Copyright © 2018 Thijs Molenaar. All rights reserved.
//

import UIKit

class DetailImagesViewController : UIViewController {
    
    weak var selectedCat : Cat?
    
    @IBOutlet weak var imageHolder: UIImageView!
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .left {
            print("swiped left")
        }
        
        if sender.direction == .right {
            print("swiped right")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(_:)))
        
        imageHolder.isUserInteractionEnabled = true
        imageHolder.addGestureRecognizer(swipeRecognizer)
        
        print(selectedCat?.detailUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSwipeAction( _ recognizer : UISwipeGestureRecognizer){
        
        if recognizer.direction == .right{
            print("Right Swiped")
        } else if recognizer.direction == .left {
            print("Left Swiped")
        }
    }
}
