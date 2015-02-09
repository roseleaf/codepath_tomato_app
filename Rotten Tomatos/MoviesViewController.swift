//
//  MoviesViewController.swift
//  Rotten Tomatos
//
//  Created by Rose Trujillo on 2/2/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var moviesView: UITableView!
    var movies = [Movie]()
    var refreshControl: UIRefreshControl!
    var filteredMovies = [Movie]()

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
        self.searchDisplayController?.searchResultsTableView.registerClass(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        let nibName = UINib(nibName: "MovieCell", bundle:nil)

        self.searchDisplayController?.searchResultsTableView.registerNib(nibName, forCellReuseIdentifier: "MovieCell")
        
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
                var moviesAr: Array = responseDictionary["movies"] as NSArray
                self.movies = moviesAr.map({ (m) -> Movie in
                    return Movie(
                        title: m.valueForKeyPath("title") as String,
                        synopsis: m.valueForKeyPath("synopsis") as String,
                        runtime: m.valueForKeyPath("runtime") as Int,
                        year: m.valueForKeyPath("year") as Int,
                        imageURL: m.valueForKeyPath("posters.profile") as String,
                        audienceScore: m.valueForKeyPath("ratings.audience_score") as Int)
                    })

                NSLog("\(self.movies[0])")
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
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredMovies.count
        } else {
            return self.movies.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        if (self.movies.count > 0) {
            var movie : Movie!
            if tableView == self.searchDisplayController!.searchResultsTableView {
                movie = self.filteredMovies[indexPath.row]
            } else {
                movie = self.movies[indexPath.row]
            }
            cell.titleLabel.text = movie.title
            cell.synopsisLabel.text = movie.synopsis
            var imageString = movie.imageURL
            var photoUrl = NSURL(string: imageString)
            let urlRequest = NSURLRequest(URL: photoUrl!)
            let placeholder = UIImage(named: "no_photo")
            cell.posterView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: nil, failure: nil)
        }
        let cellBGView = UIView()
        cellBGView.backgroundColor = UIColor(red: 0, green: 20, blue: 250, alpha: 0.2)
        cell.selectedBackgroundView = cellBGView
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var movie = [:]
        var vc = segue.destinationViewController as MovieDetailViewController

        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
        var row = indexPath?.row
        if (row != nil) {
            println(row!)
            var movie = self.movies[row!]
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
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredMovies = self.movies.filter({( movie: Movie) -> Bool in
            let stringMatch = movie.title.rangeOfString(searchText)
            return stringMatch != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
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
