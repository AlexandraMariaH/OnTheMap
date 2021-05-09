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
    
    @IBAction func refreshTapped(_ sender: UIButton) {
        // OTMClient.getStudentLocation(completion: self.handleGetLocation(success:error:))
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        OTMClient.logout {
            DispatchQueue.main.async {
              self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    

}
