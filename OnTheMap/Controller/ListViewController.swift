//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 03.05.21.
//

import UIKit

class ListViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var addPin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
          
    }

}
