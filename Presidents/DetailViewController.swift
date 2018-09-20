//
//  DetailViewController.swift
//  Presidents
//
//  Created by Joshua Aaron Flores Stavedahl on 10/31/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var termStartEndDates: UILabel!
    @IBOutlet weak var presidentImageView: UIImageView!
    @IBOutlet weak var nicknameDisplayLabel: UILabel!
    @IBOutlet weak var politicalPartyDisplayLabel: UILabel!

    /// Allows for automatic update of President instances upon change.
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {                          // For all detail items.
            if let label = nameLabel {                        // If the currently selected label is "nameLabel".
                label.text = detail.name                      // Make the label's text the name of the  selected DetailView Item.
            }
            if let label = numberLabel {                      // If the curently selected label holds the "numberLabel" value.
                let presidentLabelConstant = " President of the United States"
                switch detail.number % 10 {                   // Switch on the remainder of the DetailView's "number" member.
                case 1:
                    label.text = ("\(detail.number!)st")      // Where the number is "1" make the label "1" + the place text and so on for the other cases.
                    break
                case 2:
                    label.text = ("\(detail.number!)nd")
                    break
                case 3:
                    label.text = ("\(detail.number!)rd")
                    break
                case 11, 12, 13:
                    label.text = ("\(detail.number!)th")     // A special case for "11", "12", and "13".
                    break
                default:
                    label.text = ("\(detail.number!)th")     // Default case.
                }
                label.text! += presidentLabelConstant
            }
            if let label = termStartEndDates {
                let startParentheses = "("
                let endParentheses = ")"
                // If the current label is the Dates provided make the text on the label the code below.
                label.text = startParentheses + ("\(detail.startDate!) to \(detail.endDate!)") + endParentheses
            }
            if let imageView = self.presidentImageView {
                ImageProvider.sharedInstance.imageWithURLString(detail.url) {
                    (image: UIImage?) in
                    imageView.image = image
                }
            }
            if let label = nicknameDisplayLabel {
                label.text = detail.nickname                 // Make the label's text the "nickname" value on the selected DetailView.
            }
            if let label = politicalPartyDisplayLabel {
                label.text = detail.politicalParty           // Make the label's text the "politicalParty" value on the selected DetailView item.
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: President? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    /** 
     Gets device orientations and allows for 
     appropriate updates on screen, including "upsideDown".
    */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .all
        }
    }
    
}

