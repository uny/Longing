//
//  SettingsViewController.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIAlertViewDelegate {
    
    enum Section : Int {
        case Logout = 0
        case Keywords
        case Add
    }
    
    let logoutCellIdentifier = "Logout"
    let keywordCellIdentifier = "Keyword"
    let addCellIdentifier = "Add"
    
    var numberOfSections = Section.Add.toRaw()
    var keywords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        keywords = Keyword.all()
        
        // Removable keywords
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        // Remove keyword text area if keywords over max
        return Keyword.isFull() ? numberOfSections : numberOfSections + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        switch Section.fromRaw(section)! {
        case .Logout:
            return 1
        case .Keywords:
            return Keyword.count()
        case .Add:
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        switch Section.fromRaw(indexPath.section)! {
        case .Logout:
            let cell = tableView.dequeueReusableCellWithIdentifier(logoutCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = User().username
            return cell
        case .Keywords:
            let cell = tableView.dequeueReusableCellWithIdentifier(keywordCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = keywords[indexPath.row]
            return cell
        case .Add:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch Section.fromRaw(indexPath.section)! {
        case .Logout:
            break
        case .Keywords:
            break
        case .Add:
            // Show alert with text field
            let alertView = UIAlertView(title: "Add Keyword", message: "1-\(Keyword.lettersMax()) letters", delegate: self, cancelButtonTitle: "ADD")
            alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
            alertView.show()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section.fromRaw(section)! {
        case .Logout:
            return "Facebook"
        case .Keywords:
            return "Keywords"
        case .Add:
            return ""
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        // Only keywords section can be editted
        return Section.fromRaw(indexPath.section)! == .Keywords
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            Keyword.removeAt(indexPath.row)
            keywords = Keyword.all()

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    // MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let text = alertView.textFieldAtIndex(0)?.text
        Keyword.add(text!)
        // Reload
        keywords = Keyword.all()
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Private functions
}
