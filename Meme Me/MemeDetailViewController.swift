//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Ben Lewis on 10/7/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memeImage
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
