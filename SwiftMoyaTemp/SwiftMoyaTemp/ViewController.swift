//
//  ViewController.swift
//  SwiftMoyaTemp
//
//  Created by 郑建文 on 16/8/10.
//  Copyright © 2016年 Zheng. All rights reserved.
//

import Cocoa
import AppKit

class ViewController: NSViewController {
    @IBOutlet weak var jsonText: NSTextField!
    @IBOutlet weak var swiftCode: NSTextField!
    @IBOutlet weak var ifCode: NSComboBox!
    @IBOutlet weak var languageType: NSComboBox!
    @IBOutlet weak var Model: NSTextField!
    @IBAction func tranAction(sender: AnyObject) {
        if languageType.indexOfSelectedItem == 1 {
            genericOC()
        }else{
            genericSwift()
        }
    }
    
    func genericOC()  {
        let json =  jsonText.stringValue
        do {
            let dic = try NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
            let dict = dic as! [String:AnyObject]
            swiftCode.stringValue = "@interface \(Model.stringValue) : JSONModel{\n"
            for (key,value) in dict {
                switch value {
                case is NSNumber,is NSInteger:
                    swiftCode.stringValue += "@property (assign, nonatomic) int \(key);\n"
                case is NSString:
                    swiftCode.stringValue += "@property (strong, nonatomic) NSString* \(key);\n"
                case is Bool:
                    swiftCode.stringValue += "@property (assign, nonatomic) Bool \(key);\n"
                default:
                    swiftCode.stringValue += "@property (strong, nonatomic) \(value.classForCoder)* \(key);\n"
                }
            }
            swiftCode.stringValue += "@end\n"
            
            swiftCode.stringValue += "@implementation \(Model.stringValue) \n@end"
        }
        catch{
            
        }
    }
    
    func genericSwift() {
        let json =  jsonText.stringValue
        do {
            let dic = try NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
            let dict = dic as! [String:AnyObject]
            let coderString =  isCoder() == true ? ",NSCoding" :  ""
            swiftCode.stringValue = "class \(Model.stringValue):NSObject,Mappable \(coderString){\n"
            for (key,value) in dict {
                switch value {
                case is NSNumber,is NSInteger:
                    swiftCode.stringValue += "\tvar \(key):Int?\n"
                case is NSString:
                    swiftCode.stringValue += "\tvar \(key):String?\n"
                default:
                    swiftCode.stringValue += "\tvar \(key):\(value.classForCoder)?\n"
                }
            }
            swiftCode.stringValue += "\trequired init?(_ map: Map) { \n\n\t}\n\n"
            swiftCode.stringValue += "\tfunc mapping(map: Map) {\n"
            for key in dict.keys {
                swiftCode.stringValue += "\t\t\(key) <- map[\"\(key)\"]\n"
            }
            swiftCode.stringValue += "\t}\n"
            
            if ifCode.indexOfSelectedItem == 1 {
                swiftCode.stringValue += "\trequired init?(coder aDecoder: NSCoder){ \n"
                swiftCode.stringValue += "\t\tsuper.init()\n"
                for (key,value) in dict {
                    swiftCode.stringValue += "\t\t\(key) = aDecoder.decodeObjectForKey(\"\(key)\") as? \(getType(value)) \n"
                }
                swiftCode.stringValue += "\t}\n\n"
                swiftCode.stringValue += "\tfunc encodeWithCoder(aCoder: NSCoder) { \n"
                for (key,_) in dict {
                    //aCoder.encodeObject(total_private_repos, forKey:UserKey.totalPrivateReposKey)
                    swiftCode.stringValue += "\t\taCoder.encodeObject(\(key), forKey:\"\(key)\") \n"
                }
                swiftCode.stringValue += "\t}\n\n"
            }
            swiftCode.stringValue += "}"
        }
        catch{
            
        }
    }
    func getType(value:AnyObject) -> String {
        switch value {
        case is NSNumber,is NSInteger:
            return "Int"
        case is NSString:
            return "String"
        default:
            return "\(value.classForCoder)"
        }
    }
    
    func isCoder() -> Bool {
        return ifCode.indexOfSelectedItem == 1 ? true : false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: AnyObject? {
        didSet {
        }
    }


}

