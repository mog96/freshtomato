//
//  MovieDetailViewController.swift
//  freshtomato
//
//  Created by Mateo Garcia on 4/8/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: NSDictionary!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
//        var url = movie.valueForKeyPath("posters.thumbnail") as? String // instead of unpacking nested dictionaries
//        var endIndex = advance(url!.endIndex, -7) // omit "tmb.jpg" at end
//        var hiresurl = url!.substringToIndex(endIndex) + "ori.jpg"
//        cell.posterView.setImageWithURL(NSURL(string: hiresurl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
