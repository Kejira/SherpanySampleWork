//
//  MainViewController.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var masterViewController: MasterViewController?
    var detailViewController: DetailViewController?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMaster" {
            masterViewController = segue.destinationViewController as? MasterViewController
            masterViewController?.delegate = self
        }
        if segue.identifier == "showDetail" {
            detailViewController = segue.destinationViewController as? DetailViewController
        }
    }
    
}

extension MainViewController: MasterViewControllerDelegate {
    func showDetail(object: Post) {
        detailViewController?.detailItem = object
    }
}