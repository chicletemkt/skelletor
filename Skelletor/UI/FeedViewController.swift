//
//  FeedViewController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 22/03/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

public class FeedViewController: UITableViewController {
    @IBInspectable var cellId: String! = "FeedCell"
    @IBInspectable var feedPath: String!

    var feedReader: iTunesFeedReader!
    var feedItems: [iTunesModel] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if feedPath != nil  {
            if let url = URL(string: feedPath) {
                feedReader = iTunesFeedReader(url: url)
            }
        }
        if feedReader != nil {
            feedReader.read { (result) in
                switch result {
                case .success(let items):
                    self.feedItems = items
                    self.tableView.reloadData()
                case .error(_):
                    break
                }
            }
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let itunesItem = feedItems[indexPath.row]
        cell.textLabel?.text = itunesItem.name
        cell.detailTextLabel?.text = itunesItem.summary
        return cell
    }
}
