//
//  KeywordsViewController.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import UIKit

class KeywordsViewController: UICollectionViewController, CommunicateDelegate {
    
    let keywordCellIdentifier = "Keyword"
    let labelTag = 10
    var communicate : Communicate?
    
    var keywords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        communicate = Communicate()
        communicate?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        keywords = Keyword.all()
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User().authenticated() {
            // If not signed in, open login view as modal
            navigationController?.performSegueWithIdentifier("Login", sender: navigationController)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(keywordCellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        let label = cell.contentView.viewWithTag(labelTag) as UILabel
        
        // Configure the cell
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 1.0
        label.text = keywords[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    
    */
    // MARK: CommunicateDelegate
    func communicate(communicate: Communicate!, matched user: User, keywords: [String]) {
        // Matched
        let alertView = UIAlertView(title: "Matched", message: "\(keywords)", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        // Open
        let appURL = NSURL(string: "fb:profile/\(user.uid)")
        let browserURL = NSURL(string: "https://facebook.com/\(user.username)")
        let application = UIApplication.sharedApplication()
        if application.canOpenURL(appURL) {
            application.openURL(appURL)
        } else {
            application.openURL(browserURL)
        }
    }
    
    // MARK: - Events

    @IBAction func search(sender: UIBarButtonItem) {
        let alertView = UIAlertView(title: "Started searching", message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
        communicate!.search()
    }
}
