//
//  MovieDetailViewController.swift
//  Rotten Tomatos
//
//  Created by Rose Trujillo on 2/5/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movie: NSDictionary? = NSDictionary?()
    @IBOutlet weak var posterLargeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.movie?.objectForKey("title") as? String
        var imageString = self.movie?.valueForKeyPath("posters.profile") as String!
        let hiResImageString = imageString.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil)
        setPosterImage(imageString)
        setPosterImage(hiResImageString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setPosterImage(imageString: String) {
        var photoUrl = NSURL(string: imageString)
        let urlRequest = NSURLRequest(URL: photoUrl!)
        let placeholder = UIImage(named: "no_photo")
        self.posterLargeView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: nil, failure: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
