//
//  AddPresidentViewController.swift
//  NetworkingPresidents
//
//  Created by Joshua Aaron Flores Stavedahl on 11/20/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import UIKit

class AddPresidentViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var politicalPartySegmentedControl: UISegmentedControl!
    
    var president: President?
    var politicalParty = "Independent"
    var nickName = "None"
    var startDate = ""
    var endDate = ""
    
    
    @IBAction func saveAction(_ sender: UIBarButtonItem ) {
        //startDatePicker.maximumDate = endDatePicker.date
        if ( nameTextField.text == "" ) {
            showAlert("Please enter a name.")
        }
        else if ( startDatePicker.date > endDatePicker.date )
        {
            
            showAlert( "Selected start date is greater than end date." )
        }
        else {
            
            if ( nicknameTextField.text?.isEmpty )!
            {
                nickName = "None"
            }
            else
            {
                nickName = nicknameTextField.text!
            }
            
            if ( startDatePicker.date > endDatePicker.date )
            {
                showAlert( "Selected start date is greater than end date." )
                
            }
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            startDate = formatter.string(from: startDatePicker.date as Date)
            endDate = formatter.string(from: endDatePicker.date as Date)
            
            president = President( name: nameTextField.text!, number: 0, startDate: startDate, endDate: endDate, nickname: nickName, politicalParty: politicalParty, url: "None" )
            
            self.performSegue(withIdentifier: "saveAction", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        startDatePicker.maximumDate = endDatePicker.date
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddPresidentViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        //startDatePicker.addGestureRecognizer(tap)
        //endDatePicker.addGestureRecognizer(tap)
        //politicalPartySegmentedControl.addGestureRecognizer(tap)
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    func dismissKeyboard () {
        view.endEditing(true)
    }
    
    func selectItem() {
        nameTextField.endEditing(true)
        startDatePicker.endEditing(true)
        endDatePicker.endEditing(true)
        politicalPartySegmentedControl.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
        else if indexPath.section == 1 {
            startDatePicker.becomeFirstResponder()
        }
        else if indexPath.section == 2 {
            endDatePicker.becomeFirstResponder()
        }
        else if indexPath.section == 3 {
            nicknameTextField.becomeFirstResponder()
        }
        else if indexPath.section == 4 {
            politicalPartySegmentedControl.becomeFirstResponder()
        }
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        if ( segue.identifier == "Save" && nameTextField.text != nil && String( describing: startDatePicker ) < String( describing: endDatePicker ) && nicknameTextField.text != nil ) {
            
            president = President( name: nameTextField.text!, number: 0, startDate: String( describing: startDatePicker ), endDate: String( describing: endDatePicker ) , nickname: nicknameTextField.text!, politicalParty: politicalParty!, url: "None" )
        }
        
        else if ( segue.identifier == "Save" && nameTextField.text == nil ) || ( segue.identifier == "Save" && nameTextField.text == nil && String( describing: startDatePicker ) < String( describing: endDatePicker ) && nicknameTextField.text != nil ) {
            showAlert("Please enter a name")
        }
        else if( segue.identifier == "Save" && nameTextField.text != nil && String(describing: startDatePicker) < String(describing: endDatePicker) && nicknameTextField.text == nil ) || ( segue.identifier == "Save" && nicknameTextField == nil ){
            president = President( name: nameTextField.text!, number: 0, startDate: String( describing: startDatePicker ), endDate: String( describing: endDatePicker ) , nickname: "None", politicalParty: politicalParty!, url: "None" )
        }
        */
    }
    
    @IBAction func selectPoliticalParty(_ sender: UISegmentedControl) {
        
        // Assigns a "politicalParty" value through the selected segment index, dafult is "Independent" if nothing gets selected.
        switch politicalPartySegmentedControl.selectedSegmentIndex {
         case 0:
         politicalParty = "Democrat"
         break
         case 1:
         politicalParty = "Republican"
         break
         case 2:
         politicalParty = "Libertarian"
         break
         case 3:
         politicalParty = "Green"
         break
         default:
         politicalParty = "Independent"
         
         
         }
    }
    
    
    func showAlert(_ message: String!) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
     Gets device orientations and allows for
     appropriate updates on screen, including "upsideDown".
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return [.portrait, .portraitUpsideDown]
        }
    }
    
}

