//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by somi on 3/25/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import DateToolsSwift

class DetailViewController: UIViewController {

  var tweet: Tweet!
  
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var tweetTextView: UITextView!
  @IBOutlet var retweetCount: UILabel!
  @IBOutlet var favoriteCount: UILabel!
  @IBOutlet var retweetButton: UIButton!
  @IBOutlet var favoriteButton: UIButton!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
