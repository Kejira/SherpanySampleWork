//
//  DetailViewController.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var titleBackgroundView: UIView!
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
                titleBackgroundView.hidden = false
                detailTitleLabel.text = detail.title
                detailDescriptionLabel.text = detail.body
                collectionView.reloadData()
            }
        }
        else {
            titleBackgroundView.hidden = true
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
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var defaultSize = CGSizeMake(50, 40)
        
        if let album = self.detailItem?.user?.sortedAlbums()[section] {
            // width of label should be collectionview width - button width - 20 leading - 5 trailing - 10 button trailing but its false...
            let width = self.collectionView.frame.size.width - 100
            let maxSize = CGSizeMake(width, CGFloat.max)
            let titleFont = UIFont.boldSystemFontOfSize(15.0)
            
            
            let albumTitle = album.name! as NSString
            let titleSize = albumTitle.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: titleFont], context: nil)
            defaultSize = CGSizeMake(50, titleSize.size.height + 10)
        }
        
        return defaultSize
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
            print("width of label:", cell.titleLabel.frame.size.width)
            
            if let _ = openedSections[indexPath.section] {
                cell.sectionButton.setTitle("Hide", forState: UIControlState.Normal)
            }
            else {
                cell.sectionButton.setTitle("Show", forState: UIControlState.Normal)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        print("supplementary view width", view.frame.size.width)
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

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let spaceForCells = collectionView.frame.size.width - 30
        let amountOfCells = floor(spaceForCells / 150)
        let space = spaceForCells % 150
        let minimumSpace = space / (amountOfCells - 1)
        return minimumSpace
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let spaceForCells = collectionView.frame.size.width - 30
        let amountOfCells = floor(spaceForCells / 150)
        let space = spaceForCells % 150
        let minimumSpace = space / (amountOfCells - 1)
        return minimumSpace
    }
}
