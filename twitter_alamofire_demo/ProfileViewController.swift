//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by somi on 3/26/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
  
  var currentUser: User!
  
  @IBOutlet var profileImage: UIImageView!
  @IBOutlet var profileBanner: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var followingCountLabel: UILabel!
  @IBOutlet var tweetCountLabel: UILabel!
  @IBOutlet var followersCountLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //currentUser = APIManager.shared.get
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    nameLabel.text = String("@" + (User.current?.screenName)!)
    usernameLabel.text = User.current?.name
    followingCountLabel.text = String(User.current!.friends_count)
    followersCountLabel.text = String(User.current!.followers_count)
    tweetCountLabel.text = String(User.current!.statuses_count)
    print(User.current!.name)
    print(User.current!.profile_banner_url)
    print(User.current!.profile_background_image_url)
    print(User.current!.profile_image_url_https)

    let placeholderImage = #imageLiteral(resourceName: "profile-Icon")
    let bannerFilter = AspectScaledToFillSizeFilter(size: profileBanner.frame.size)
    
   // if (User.current?.profile_background_image_url_https) != nil {
  // profileBanner.af_setImage(withURL: URL(string: (User.current!.profile_background_image_url_https))!, placeholderImage: placeholderImage, filter: bannerFilter, imageTransition: .crossDissolve(0.1))
   // }
    
    let profileFilter = AspectScaledToFillSizeFilter(size: profileImage.frame.size)
    profileImage.af_setImage(withURL: URL(string: (User.current!.profile_image_url_https))!, placeholderImage: placeholderImage, filter: profileFilter, imageTransition: .crossDissolve(0.1))
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
