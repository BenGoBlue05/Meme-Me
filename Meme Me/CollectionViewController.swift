//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Ben Lewis on 10/6/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//
import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var memeCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeCollectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MmSession.sharedInstance.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as!  MemeCollectionViewCell
        cell.image.image = MmSession.sharedInstance.memes[indexPath.row].memeImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard!.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = MmSession.sharedInstance.memes[indexPath.row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
}
