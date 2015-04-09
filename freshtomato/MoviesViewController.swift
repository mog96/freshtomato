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
    
    var movies: [NSDictionary]! = [NSDictionary]() // property; new array of NSDictionary
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=nxu96vjy2huu9g3vd3kjfd2g")!
        var request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            self.movies = json["movies"] as [NSDictionary]
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /* START HERE!!! */
        
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
//        scrollView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieCell
        
        var movie = movies[indexPath.row]
        
        // should be: cell.movie = movie, and then let cell configure itself
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as? String // instead of unpacking nested dictionaries
        var endIndex = advance(url!.endIndex, -7) // omit "tmb.jpg" at end
        var hiresurl = url!.substringToIndex(endIndex) + "ori.jpg"
        cell.posterView.setImageWithURL(NSURL(string: hiresurl)!)
        
//        cell.titleLabel.text = "Where the Wild Things Are"
//        cell.synopsisLabel.text = "Max (Max Records) is a young boy who feels misunderstood and wants to have fun all the time. He makes an igloo out of snow, but his sister's friends gang up on him and smash it. After making a scene in front of his mother's boyfriend, Max bites his mother and runs away. He keeps running until he stumbles upon a small boat; he climbs aboard and sets sail."
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieDetailViewController = segue.destinationViewController as MovieDetailViewController
        var cell = sender as UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        movieDetailViewController.movie = movies[indexPath.row]
    }

}
