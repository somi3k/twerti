//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var retweetCount: UILabel!
  @IBOutlet var favoriteCount: UILabel!
  
  
  var tweet: Tweet! {
    didSet {
      tweetTextLabel.text = tweet.text
      createdAtLabel.text = tweet.createdAtString
      nameLabel.text = tweet.user?.name
      usernameLabel.text = String("@" + (tweet.user?.screenName)!)
      retweetCount.text = String(describing: tweet.retweet_count)
      favoriteCount.text = String(describing: tweet.favorite_count)
      
      let placeholderImage = #imageLiteral(resourceName: "profile-Icon")
      
      // specify animation technique for image transition
      let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)

      profileImageView.af_setImage(withURL: URL(string: (self.tweet.user?.profile_image_url_https)!)!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.1))
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
