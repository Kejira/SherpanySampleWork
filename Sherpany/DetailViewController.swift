//
//  DetailViewController.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var openedSections = [Int:Bool]()

    var detailItem: Post? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let _ = self.detailDescriptionLabel {
                detailTitleLabel.text = detail.title
                detailDescriptionLabel.text = detail.body
                collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        let flowLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionHeadersPinToVisibleBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.detailItem?.user?.albums?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = openedSections[section],
            let album = self.detailItem?.user?.sortedAlbums() {
            return album[section].photos?.count ?? 0
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? PhotoCollectionCell,
            let photos = self.detailItem?.user?.sortedAlbums()[indexPath.section].sortedPhotos() {
            
            let photo = photos[indexPath.row]
            
            
            if let thumbnail = photo.thumbnail,
                let thumbnailImage = UIImage(contentsOfFile: ImageDownloader.sharedInstance.fileInCachesDirectory(thumbnail)) {
                cell.thumbnailImage.image = thumbnailImage
                cell.activityIndicator.hidden = true
            }
            else {
                cell.thumbnailImage.image = nil
                cell.activityIndicator.hidden = false
                
                let url = photo.thumbnailUrl
                // donwload image now
                ImageDownloader.sharedInstance.loadImage(url, completion: { [weak self] (image) in
                    guard let _ = self else {
                        return
                    }
                    
                    cell.thumbnailImage.image = image
                    cell.activityIndicator.hidden = true
                })
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerView", forIndexPath: indexPath)
        configureHeaderView(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureHeaderView(cell: UICollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? CollectionHeaderView,
            let album = self.detailItem?.user?.sortedAlbums()[indexPath.section] {
            cell.sectionButton.tag = indexPath.section
            cell.sectionButton.addTarget(self, action: #selector(DetailViewController.displaySection), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.titleLabel.text = album.name
            
            if let _ = openedSections[indexPath.section] {
                cell.sectionButton.setTitle("Hide", forState: UIControlState.Normal)
            }
            else {
                cell.sectionButton.setTitle("Show", forState: UIControlState.Normal)
            }
        }
    }
    
    func displaySection(button: UIButton) {
        let section = button.tag
        if let _ = openedSections[section] {
            openedSections[section] = nil
        }
        else {
            openedSections[section] = true
        }
        collectionView.reloadSections(NSIndexSet(index: section))
    }

}
