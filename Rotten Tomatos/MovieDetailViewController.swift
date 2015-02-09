//
//  MovieDetailViewController.swift
//  Rotten Tomatos
//
//  Created by Rose Trujillo on 2/5/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movie: Movie!
    @IBOutlet weak var posterLargeView: UIImageView!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.movie.title
        self.synopsisTextView.text = self.movie.synopsis
        self.titleLabel.text = self.movie.title
        var imageString = self.movie.imageURL
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

    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if (714 > recognizer.view!.center.y + translation.y  && recognizer.view!.center.y + translation.y > 450) {
            recognizer.view!.center = CGPoint(x:recognizer.view!.center.x,
                y:recognizer.view!.center.y + translation.y)
            recognizer.setTranslation(CGPointZero, inView: self.view)
        }
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
