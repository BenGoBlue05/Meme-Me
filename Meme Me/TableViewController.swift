//
//  TableViewController.swift
//  Meme Me
//
//  Created by Ben Lewis on 10/6/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var memesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MmSession.sharedInstance.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeRow")!
        let meme = MmSession.sharedInstance.memes[indexPath.row]
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        memesTableView?.reloadData()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }

}
