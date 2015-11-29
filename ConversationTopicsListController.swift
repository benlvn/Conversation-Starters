//
//  ConversationTopicsListController.swift
//  Conversation Starters
//
//  Created by Ben Levine on 11/28/15.
//  Copyright © 2015 Bennett Levine. All rights reserved.
//

import UIKit

class ConversationTopicsListController: UITableViewController {
    
    var conversationTopics:[String:Bool] = [:]
    
    let fileNames = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSBundle.mainBundle().pathForResource("Conversation Topics", ofType: nil)!)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        for name in fileNames!{
            var tempName = name
            if let range = tempName.rangeOfString(".txt"){
                tempName.removeRange(range)
                conversationTopics[tempName] = false
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if conversationTopics[cell.textLabel!.text!]!{
            conversationTopics[cell.textLabel!.text!] = false
        } else {
            conversationTopics[cell.textLabel!.text!] = true
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationTopics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Topic", forIndexPath: indexPath)
        
        cell.textLabel!.text = conversationTopics.keys[conversationTopics.startIndex.advancedBy(indexPath.row)]
        
        if conversationTopics[cell.textLabel!.text!]!{
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        for key in conversationTopics.keys{
            conversationTopics[key] = true
        }
        tableView.reloadData()
    }
    
    func presentConversationStarter(starters:[String]){
        let randomIndex = Int(arc4random_uniform(UInt32(starters.count)))
        let ac=UIAlertController(title: nil, message: starters[randomIndex], preferredStyle: .Alert)
        let newStarter = UIAlertAction(title: "New conversation starter", style: .Default, handler: {(action:UIAlertAction) -> Void in
            self.presentConversationStarter(starters)
        })
        let done = UIAlertAction(title: "Done", style: .Cancel, handler: nil)
        ac.addAction(newStarter)
        ac.addAction(done)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func presentZeroTopicWarning(){
        let ac = UIAlertController(title: nil, message: "Please select one or more conversation category", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func conversationStarter(sender: AnyObject){
        var chosenTopics:[String] = []
        for key in conversationTopics.keys{
            if conversationTopics[key]!{
                chosenTopics.append(key)
            }
        }
        var conversationStarters:[String] = []
        for item in chosenTopics{
            
            if let starterFile = NSBundle.mainBundle().pathForResource("Conversation Topics/\(item)", ofType: "txt"){
                if let starters = try? String(contentsOfFile: starterFile){
                    conversationStarters.appendContentsOf(starters.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "\n")))
                }
            }
        }
        if conversationStarters.count == 0 {
            presentZeroTopicWarning()
        } else {
            presentConversationStarter(conversationStarters)
        }
        
    }
    
}
