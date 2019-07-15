//
//  ViewController.swift
//  TypeType
//
//  Created by Muhammad Abduh on 06/07/19.
//  Copyright © 2019 Muhammad Abduh. All rights reserved.
//

import Cocoa
import SwiftSoup
class ViewController: NSViewController {

    @IBOutlet weak var preDelayText: NSTextFieldCell!
    @IBOutlet weak var secText: NSTextFieldCell!
    @IBOutlet weak var editText: NSTextFieldCell!
    @IBOutlet weak var labelText: NSTextFieldCell!
    
    @IBAction func parseButton(_ sender: Any) {
        let text = parseHTML()
        labelText.stringValue = text
    }
    
    @IBAction func runButton(_ sender: NSButton) {
        
        do {
            let secValue = secText.stringValue
            let preDelayValue = preDelayText.stringValue
            let text = parseHTML()
            labelText.stringValue = text
            
            runAppleScript(theText: text, preDelayValue: preDelayValue, secValue: secValue)
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func parseHTML() -> String {
        let htmlText = editText.stringValue
        var text = "Error Parsing HTML Text. Make sure you include <div class=\"\"></div> tag"
        do {
            let doc: Document = try SwiftSoup.parse(htmlText)
            text = try doc.body()!.text();
            
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        return text
    }
    
    func runAppleScript(theText: String, preDelayValue: String, secValue: String){
 
        let taskScript = """
            tell application "System Events"
                delay \(preDelayValue)
                set chars to text items of "\(theText)"
                repeat with i from 1 to (length of chars)
                    set thechar to item i of chars
                    keystroke thechar
                    delay \(secValue)
                end repeat
            end tell
            """
        
        var out: NSAppleEventDescriptor?

        if let scriptObject = NSAppleScript(source: taskScript) {
            var errorDict: NSDictionary? = nil
            out = scriptObject.executeAndReturnError(&errorDict)
            print(out)
            if let error = errorDict {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

