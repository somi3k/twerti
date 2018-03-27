//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by somi on 3/26/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage


protocol ComposeViewControllerDelegate {
  func did(post: Tweet)
}


class ComposeViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var tweetTextView: UITextView!
  @IBOutlet var countLabel: UILabel!
  
  var delegate: ComposeViewControllerDelegate?
  
  override func viewDidLoad() {
    tweetTextView.delegate = self
    
    tweetTextView.becomeFirstResponder()
    usernameLabel.text = String("@" + (User.current?.screenName)!)
    nameLabel.text = User.current?.name
    let placeholderImage = #imageLiteral(resourceName: "profile-Icon")
    let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
    profileImageView.af_setImage(withURL: URL(string: (User.current!.profile_image_url_https))!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.1))
    super.viewDidLoad()
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let characterLimit = 280
    let newText = NSString(string: tweetTextView.text!).replacingCharacters(in: range, with: text)
    countLabel.text = String(280 - newText.count)
    return newText.count < characterLimit
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func didTweet(_ sender: Any) {
    APIManager.shared.composeTweet(with: tweetTextView.text) { (tweet, error) in
      if let error = error {
        print("Error composing Tweet: \(error.localizedDescription)")
      } else if let tweet = tweet {
        self.delegate?.did(post: tweet)
        print("Compose Tweet Success!")
      }
    }
    didCancel(self)
  }
  
  
  
  @IBAction func didCancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
