//
//  Edit_Parse.swift
//  SnapNotes
//
//  Created by james luo on 11/9/19.
//  Copyright © 2019 james luo. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
class Edit_Parse: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var parsedData: UITextView!
    var curText = ""
    var Mytitle = ""
    var myClass = ""
    let ref = Database.database().reference()
    var curImage : UIImage?
    @IBOutlet weak var myImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if curImage != nil{
            myImage.image = curImage
        }
         let textContent = NSMutableAttributedString()
        let allFormattedDescriptions = [
            
            Formatted(heading: Mytitle, descriptionText: curText)
        ]
        for (index, desc) in allFormattedDescriptions.enumerated() {
            let includeLinebreak = index < allFormattedDescriptions.count - 1
            textContent.append(desc.attributeString(includeLineBreak: includeLinebreak))
        }
        parsedData.attributedText = textContent
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func uploadInfo(_ sender: Any) {
        self.pushToDataBase()
    }
    func pushToDataBase(){
        self.ref.child("courses/" + self.myClass + "/"+Mytitle).setValue(curText)
        print(curText)
    }
    struct Formatted {
        var heading: String
        var descriptionText: String
        
        var bodyParagraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            style.paragraphSpacingBefore = 6
            style.paragraphSpacing = 6
            return style
        }()
        
        var headerParagraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.paragraphSpacingBefore = 24
            return style
        }()
        
        var bodyAttributes: [NSAttributedString.Key: Any]
        var headerAttributes: [NSAttributedString.Key: Any]
        
        func attributeString(includeLineBreak: Bool = true) -> NSAttributedString {
            let result = NSMutableAttributedString()
            result.append(NSAttributedString(string: self.heading + "\n", attributes: self.headerAttributes))
            result.append(NSAttributedString(string: self.descriptionText, attributes: self.bodyAttributes))
            if includeLineBreak {
                result.append(NSAttributedString(string: "\n", attributes: self.bodyAttributes))
            }
            
            return result as NSAttributedString
        }
        
        init(heading: String, descriptionText: String) {
            self.heading = heading
            self.descriptionText = descriptionText
            self.bodyAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Hoefler Text", size: 14)!,
                NSAttributedString.Key.paragraphStyle: bodyParagraphStyle
            ]
            self.headerAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                NSAttributedString.Key.paragraphStyle: headerParagraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
        }
    }
}
