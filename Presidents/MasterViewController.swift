//
//  MasterViewController.swift
//  Presidents
//
//  Created by Joshua Aaron Flores Stavedahl on 10/31/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    /**
     A "nil" DetailViewController instance.
    */
    var detailViewController: DetailViewController? = nil
    /// Holds an empty array of "President" instances.
    var presidentObjects = [President]()
    /// Holds an empty array of "President" instances.
    var filteredPresidentObjects = [President]()
    /// Constant for the instance of a "UISearchController".
    let searchController = UISearchController(searchResultsController: nil)
    /// Constant for the instance of a "UISearchFooter" with appropriate measures located at the top.
    let searchFooter = SearchFooter(frame: CGRect(x: 0, y: 0, width: 414, height: 44 ))
    
    /**
     Overriden function allows for all supported orientations including "upsideDown" in the MasterView Controller.
    */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .all
        }
    }
    
    /// Overriden function viewDidLoad().
    override func viewDidLoad() {
        // Calls the original Father viewDidLoad() method.
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Initializes and holds the value for the Edit button.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // If we let the constant hold the value of the splitViewController.
        if let split = splitViewController {
            // Constant holds the value for the UIViewController split.
            let controllers = split.viewControllers
            // An unwrapped DetailViewController shows the count of the sview controllers on screen.
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Sets the searchController's searchResultsUpdater to the current
        searchController.searchResultsUpdater = self
        // Keeps background the same color during presentation.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        // Array of String titles for the scope searchBar.
        searchController.searchBar.scopeButtonTitles = ["All", "Democrat", "Republican", "Whig", "None"]
        // Use searchBar within that particular context.
        searchController.searchBar.delegate = self
        tableView.tableFooterView = searchFooter
        
        
        // Read the property list
        downloadJSONData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        ImageProvider.sharedInstance.clearCache()
    }
    
    /// Returns a Boolean determining whether the "searchBar" is empty.
    func searchBarISEmpty( ) -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Returns a Boolean determining whether the "searchBar" is filtering.
    func isFiltering() -> Bool {
        /// Holds value for a "searchBar"'s "slectedScopeButtonIndex" when the value is not equal to zero.
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        // If the "searchController" "is active" AND the "searchBar" is "not empty" OR the "searchBarScopeIsFiltering" also known as, not equal to zero, return the value.
        return searchController.isActive && ( !searchBarISEmpty() || searchBarScopeIsFiltering )
    }
    
    /// Returns a Boolean value for the President's instance party.
    /// 
    /// - Parameter searchText: The string to search on.
    /// - Parameter scope: The string that returns `All` of the "politicalParty" categories for a President.
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPresidentObjects = presidentObjects.filter { president in
            /// Holds Boolean value where scope = "All" OR "poloticalParty = an element of scope.
            let partyDoesMatch = ( scope == "All") || (president.politicalParty == scope )
            
            if searchBarISEmpty() {
                return partyDoesMatch
            }
                // Allows for the "searchText" to be lowercase.
            else {
                return partyDoesMatch && president.name.lowercased().contains( searchText.lowercased() )
            }
            
        }
        // Reloads the data on the TableView once returned.
        tableView.reloadData()
    }

    
    // MARK: - Segues

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                /// Create a consant of type "President"
                let presObject : President
                // if isFilreing() is true
                if isFiltering() {
                    // Initialize the constant to the selected filtered values.
                    presObject = filteredPresidentObjects[indexPath.row]
                }
                else{
                    // Otherwise, the displayed values are the entire array of President objects.
                    presObject = presidentObjects[indexPath.row]
                }
                // The constant holds the value of the DetailViewController.
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                // The DetailViewController holds the value of the objects in the array determined previously determined.
                controller.detailItem = presObject
                // Creates the button for the splitView controller to make full screen and go back as well.
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                // Creates the button to go back to the TableViewController called "Master"
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func unwindToCancel(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToSave(_ segue: UIStoryboardSegue) {
        if let addPresidentViewController = segue.source as? AddPresidentViewController {
            if let president = addPresidentViewController.president {
                //objects.append(character)
                tableView.reloadData()
                president.number = presidentObjects.count + 1
                var index = presidentObjects.index(where: {$0.number > president.number})
                if index == nil {
                    index = presidentObjects.count 
                }
                
                presidentObjects.insert(president, at: index!)
            
                let indexPath = IndexPath(row: index!, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }

    // MARK: - Table View

    /// Override function For UITableView that returns an Int.
    /// 
    /// - Parameter tableView: The UITableView that will hold sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Override function for UITableView that returns an Int.
    ///
    /// - Parameter tableView: The UITableView that will hold sections.
    /// - Parameter section: Ineteger used for the section number in the TableView.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the TableView is filtering content get initialize the searchFooter to the count President 
        // objects that have been filtered from the entire President object array and return that Integer
        // value.
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredPresidentObjects.count, of: presidentObjects.count )
            return filteredPresidentObjects.count
        }
        // Return the original President array count since it is not filtering.
        else {
            // searchFooter is not filtering return the count of the original, full president objects array. 
            searchFooter.setNotFiltering()
            return presidentObjects.count
        }
    }
    
    /// Override function for UITableView that retuns a cell.
    ///
    /// - Parameter tableView: The UITableView's current state.
    /// - Parameter indexPath: The IndexPath location of the cell or index value.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PresidentCell
        /// Create instance of "President" type.
        let presidentObject : President
        // If the searchBar is filtering initialize the President object with the filtered President array.
        if isFiltering() {
            presidentObject = filteredPresidentObjects[indexPath.row]
        }
        
        // Else, initialize it with the complete President array.
        else {
            presidentObject = presidentObjects[indexPath.row]
        }
        ImageProvider.sharedInstance.imageWithURLString(presidentObject.url) {
            (image: UIImage?) in
            cell.presidentImageView!.image = image
        }
        /// Holds the President "name".
        cell.nameLabel!.text = presidentObject.name
        /// Holds the President "politicalParty".
        cell.politicalPartyLabel!.text = presidentObject.politicalParty
        
        return cell
    }

    /// Override function for the UITableView that returns a Boolean.
    /// 
    /// - Parameter tableView: The current UITableView's state.
    /// - Parameter indexPath: The UITableView's indexPath or location in the current instance.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /// Override function for the UITableView that returns nothing.
    /// 
    /// - Parameter tableView: The current UITableView's instance.
    /// - Parameter editingStyle: UITableViewCellEditingStyle that deletes the unused instance.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            presidentObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func downloadJSONData() {
        
        let session = URLSession.shared
        
        guard let url = URL(string: "https://www.prismnet.com/~mcmahon/CS321/presidents.json") else {
            // Handle invalid URL error
            showAlert("Invalid URL for JSON data")
            return
        }
        
            weak var weakSelf = self
        
            
            let task = session.dataTask(with: url) {
                
                (data, response, error) in
                
                let httpResponse =  response as? HTTPURLResponse
                
                if httpResponse!.statusCode != 200 {
                    
                    weakSelf!.showAlert("HTTP Error: status code \(httpResponse!.statusCode).")
                }
                else if ( data == nil && error != nil ) {
                    weakSelf!.showAlert("No data downloaded.")
                }
                    
                else {
                    
                    let array : [AnyObject]
                    
                    do {
                        array = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    }
                    catch _ {
                        weakSelf!.showAlert("Unable to parse JSON data.")
                        return
                    }
                    
                    for dictionary in array {
                        let name = dictionary["Name"] as! String
                        let number = dictionary["Number"] as! Int
                        let startDate = dictionary["Start Date"] as! String
                        let endDate = dictionary["End Date"] as! String
                        let nickname = dictionary["Nickname"] as! String
                        let politicalParty = dictionary["Political Party"] as! String
                        let url = dictionary["URL"] as! String
                        
                        weakSelf!.presidentObjects.append(President(name: name, number: number, startDate: startDate, endDate: endDate, nickname: nickname, politicalParty: politicalParty, url: url))
                    }
                    
                    weakSelf!.presidentObjects.sort {
                        let min = $0.number
                        let max = $1.number
                        return min! < max!
                        
                    }
                    DispatchQueue.main.async {
                        weakSelf!.tableView!.reloadData()
                    }
                }
            }

        task.resume()
    }
    
    func showAlert(_ message: String!) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// Does not return anything.
    ///
    /// - Parameter searchController: The "UISearchController" that displays the content info for the text search.
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        // Filters the text search with the searchBar  or the scope buttons
        filterContentForSearchText( searchController.searchBar.text!, scope: scope )
    }
    
    /// Does not return anything.
    /// 
    /// - Parameter searchBar: The "UISearchBar" used to filter text content.
    /// - Parameter selectedScope: The Int number of President objects in the scope.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
