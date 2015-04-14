//
//  MoviesViewController.swift
//  freshtomato
//
//  Created by Mateo Garcia on 4/8/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // inherited class, followed by interfaces
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [NSDictionary]! = [NSDictionary]() // property; new array of NSDictionary
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setBackgroundColor(UIColor.magentaColor())
        
        // let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        
        refreshData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        var movie = movies[indexPath.row]
        
        // ideally, movie should be moved to cell, so it would be: cell.movie = movie, and then let cell configure itself
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as? String // instead of unpacking nested dictionaries
        
        // var endIndex = advance(url!.endIndex, -7) // omit "tmb.jpg" at end; OLD WORKAROUND
        // var hiresurl = url!.substringToIndex(endIndex) + "ori.jpg"
        
        var range = url!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url!.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        cell.posterView.setImageWithURL(NSURL(string: url!)!)
        
//        cell.titleLabel.text = "Where the Wild Things Are"
//        cell.synopsisLabel.text = "Max (Max Records) is a young boy who feels misunderstood and wants to have fun all the time. He makes an igloo out of snow, but his sister's friends gang up on him and smash it. After making a scene in front of his mother's boyfriend, Max bites his mother and runs away. He keeps running until he stumbles upon a small boat; he climbs aboard and sets sail."
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshData() {
        SVProgressHUD.show()
        
        var clientID = "nxu96vjy2huu9g3vd3kjfd2g"
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=\(clientID)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.errorView.hidden = false
            } else {
                self.errorView.hidden = true
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
                self.movies = json["movies"] as! [NSDictionary]
                self.tableView.reloadData()
            }
        }
        
        SVProgressHUD.dismiss()
    }
    
    func onRefresh() {
        refreshData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
        var cell = sender as! UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        movieDetailViewController.movie = movies[indexPath.row]
    }

}
