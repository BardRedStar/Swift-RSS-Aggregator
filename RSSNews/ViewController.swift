//
//  ViewController.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit

/// A main class of application
class ViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    var newsDictionary: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readPropertyList()
        
        newsTableView.dataSource = self
    }

    /// Reads the news from the properties file (.pfile) and put it into global dictionary
    func readPropertyList() {
        
        if let path = Bundle.main.path(forResource: "news", ofType: "plist") {
            newsDictionary = NSDictionary(contentsOfFile: path)
        }
        else {
            fatalError("File is not found!")
        }
    }
}

/// An extension for viewcontroller class to use table view
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDictionary!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RSSUITableViewCell", for: indexPath) as? RSSTableViewCell
            else {
            fatalError("This isn't a RSSUITableViewCell object!")
        }
        
        // Get news by index from dictionary (sorry for that)
        var i = 0
        for (title, content) in newsDictionary! {
            if (i == indexPath.row) {
                cell.titleLabel.text = (title as? String) ?? "Unknown"
                cell.contentLabel.text = (content as? String) ?? "Unknown"
            }
            i += 1
        }
        
        return cell
    }
}
