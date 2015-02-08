//
//  MoviesViewController.swift
//  Rotten Tomatos
//
//  Created by Rose Trujillo on 2/2/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var moviesView: UITableView!
    var movies = []
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        self.title = "Movies"
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        SVProgressHUD.setForegroundColor(UIColor .blueColor())
        SVProgressHUD.show()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        self.loadMovieData()
        
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func loadMovieData() {
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=30&country=us&apikey=dagqdghwaq3e3mxyrp7kmmj5")
        
        var request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:  {
            (response, data, error) in
            var errorPointer: NSError?
            
            if error != nil {
                NSLog("the error is \(error)")
                self.showNetworkError()
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data,
                    options:NSJSONReadingOptions.MutableContainers, error: &errorPointer) as NSDictionary
                
                self.movies = responseDictionary["movies"] as [NSDictionary]
                self.tableView.reloadData()
            }
        })
    }

    func showNetworkError() {
        var errorView: UIView = UIView(frame: CGRectMake(0, 50, 320, 65))
        errorView.backgroundColor = UIColor.grayColor()
        var errorLabel: UILabel = UILabel(frame: CGRectMake(110, 20, 260, 40))
        errorLabel.text = "Network error!"
        errorLabel.textColor = UIColor.whiteColor()
        errorView.addSubview(errorLabel)
        self.view.addSubview(errorView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        if (self.movies.count > 0) {
            var movie = self.movies[indexPath.row] as? NSDictionary
            cell.titleLabel.text = movie?.objectForKey("title") as? String
            cell.synopsisLabel.text = movie?.objectForKey("synopsis") as? String
            var imageString = movie?.valueForKeyPath("posters.profile") as? String
            var photoUrl = NSURL(string: imageString!)
            let urlRequest = NSURLRequest(URL: photoUrl!)
            let placeholder = UIImage(named: "no_photo")
            cell.posterView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: nil, failure: nil)
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var movie = [:]
        var vc = segue.destinationViewController as MovieDetailViewController

        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
        var row = indexPath?.row
        if (row != nil) {
            println(row!)
            var movie = self.movies[row!] as NSDictionary
            vc.movie = movie
        }
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
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
