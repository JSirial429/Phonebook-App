//
//  ViewController.swift
//  SearchBarInTable
//
//  Created by Luismel Rosquete on 07/15/2019.
//  Copyright © 2019 Luismel Rosquete. All rights reserved.
//

import UIKit
import Foundation

//Global variables that store contact information chosen by the user at the contact list
var cnName: String?
var cnPhone: String?
var cnExt: String?
var uIndex: Int = 0
let avayaNum: String = "3052706604," //This number used to make call to non DID by appending extension


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var table: UITableView! // Connecting the table video with ViewController.swift as an outlet
    @IBOutlet var searchBar: UISearchBar! // Connecting the search bar with ViewController.swift as an outlet
    

    
    //@IBOutlet var cnLabel1: UILabel!
    
    var EmployeeArray = [Employee]() // creates an array for the Employee Class
    var currentEmployeeArray = [Employee]() //updated array with current Employees based on search parameters
    
    override func viewDidLoad() { // Sets up the viewDidLoad() function
        super.viewDidLoad()
        setUpEmployees()
        setUpSearchBar()
        alterLayout()
        
        //EXPERIMENTAL
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter Extension or Name"
        //Experimental
        
        
        //EXPERIMENTAL
        /*var counter: Int = 0
        
        var empName = "", empExt = "", empPhone: String = ""
        
        if let filePath = Bundle.main.path(forResource: "data", ofType: "txt")
        {
              do{
                
                //Loads content of files into single string
                let contents = try! String(contentsOfFile: filePath)
                
                //splits the contents by comma
                let csv = contents.split(separator: ",")
                
                for value in csv
                {
                    if(counter >= 3)
                    {
                        EmployeeArray.append(Employee(name: "\(empName)!", ext: "\(empExt)!", phone: "\(empPhone)!"))
                        counter = 0
                    }
                    
                    switch counter
                    {
                     
                    case 0:
                        empName = String(value)
                    case 1:
                        empExt = String(value)
                    case 2:
                        empPhone = String(value)
                    default:
                        print("Error")
                        
                    }
                    
                    counter += 1
                    
                    
                }
                
              }catch{
                print("Error")
              }
            
        }*/
        
        
    }
    
    private func setUpEmployees() { // List of Employees (table values). HARDCODED. COUD BE SUBSTITUTED WITH CSV FILE
        // EMPLOYEES LIST
        
        //var counter: Int = 0
        
        //var empName = "", empExt = "", empPhone: String = ""
        
        if let filePath = Bundle.main.path(forResource: "Data1", ofType: "txt")
        {
              do{
                
                //Loads content of files into single string
                let contents = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                
                //splits the contents by comma
                let csv = contents.split(separator: "\n")
                
                //let csv = contents.split(separator: ",")
                
                for value in csv
                {
                    /*if(counter >= 3)
                    {
                        EmployeeArray.append(Employee(name: "\(empName)", ext: "\(empExt)", phone: "\(empPhone)"))
                        counter = 0
                    }
                    
                    switch counter
                    {
                     
                    case 0:
                        empName = String(value)
                    case 1:
                        empPhone = String(value)
                    case 2:
                        empExt = String(value)
                    default:
                        print("Error")
                        
                    }*/
                    
                    //counter += 1
                    
                    parseInfo(String(value))
                    
                    EmployeeArray.append(Employee(name: "\(cnName!)", ext: "\(cnExt!)", phone: "\(cnPhone!)"))
                    
                    
                }
                
              }catch{
                print("Error")
              }
            
        }
        
        currentEmployeeArray = EmployeeArray // It updates the EmployeeArray with the new one
    }
    
    private func setUpSearchBar() { // The function for setting up the Search Bar
        searchBar.delegate = self // It delegates  the Search Bar a "self" to be used later on the code
    }
    
    func alterLayout() { // This alterates the layout in order to meet all the data load.
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on the layout
        searchBar.placeholder = "Search Employees by Name" // Placeholder of Search Bar
        searchBar.showsCancelButton = true //Hide X button
    }
        
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEmployeeArray.count // It will return a number of cells based on the number of Employees
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell() // it calls the cells of the table view "Cell" (can be found on the identifier for the cells) in order for cell text be edited down in the code below (for naming the cells) --> IMAGE to be deleted updated: 07/15/2019
        }
        cell.nameLbl.text = currentEmployeeArray[indexPath.row].name
        cell.categoryLbl.text = currentEmployeeArray[indexPath.row].ext
        cell.phoneLbl.text = currentEmployeeArray[indexPath.row].phone
        
        return cell // This would be the return to the cell content
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //Allows user to click on a row and call the selected person
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Hold the last 4 digits of the selected telephone number
        //var temp4Digits: String
        
        //returns index of the current row that user clicked
        uIndex = indexPath.row
        
        cnName = currentEmployeeArray[uIndex].name
        cnPhone = currentEmployeeArray[uIndex].phone
        cnExt = currentEmployeeArray[uIndex].ext
        
        //Removes dashes and spaces from telephone
        cnPhone = parseTel(cnPhone!)
        
        //If else statement to decide if call is placed via a DID or using AVAYA number with extension appended to it
        //temp4Digits = last4Digits(cnPhone!)
        
        if( (cnExt == "") && (cnPhone == "") )
        {
             //If entry has no number then display error dialog box
             let alert = UIAlertController(title: "Error", message: "The following object has incurred an error. Please choose a different contact.", preferredStyle: .alert)
                       
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
             self.present(alert, animated: true)
        }
        else if( (cnExt == "") && (cnPhone != "") )
        {
          //Places call to directly if there is no extension available
          placeCall(cnPhone!)
        }
        else{
            
            //Call method to place call to exension using the Avaya Number
            placeExtCall(cnExt!)
        }
        

    }
    
    //Fucntion that makes a call to a non DID
    func placeExtCall(_ extNum: String)
    {
        guard let number = URL(string:"tel://\(avayaNum)\(extNum)") else {return}
        UIApplication.shared.open(number)
        
    }
    
    //Function that makes a call
    func placeCall(_ numPhone: String)
    {
        guard let number = URL(string:"tel://\(numPhone)") else {return}
        UIApplication.shared.open(number)
    }
    
    //Helper method that parses a telephone number to remove dashes, and parentheses from a telephone number
    //Returns just the number ex:3051234567
    func parseTel(_ Tel: String) -> String
    {
        
        var oldStr: String  //Variable that holds a copy of the telephone of the currently selected contact
        var newStr: String = "" //Variable used to hold new telephone without spaces and dashes
        //var char: Character //Used in the for loop below to store the current nth element in oldStr
        
        oldStr = Tel
        
        //Enhanced for loop that iterates over oldStr
        for c in oldStr
        {
            
            //If the current nth element in oldStr is not a space or a dash then place 
            if( (c != " ") && (c != "-") )
            {
                newStr += [c]
            }
        }
        
        return newStr //Retunrs new string wich is just the telephone number without dashes and spaces
        
    }
    
    //Method that parses line of text from txt file and gets information relevant to the
    //contact's name, telephone and extension.
    func parseInfo(_ line: String)  // -> Sting
    {
        
        var tempName = "", tempPhone = "", tempExt: String = ""
        var count: Int = 0
        
        for csv in line
        {
            
            if( csv == "\"")
            {
                
                continue
                
            }
            else if( (csv != ",") && (csv != "\n") )
            {
                switch count
                {
                    
                case 0:
                    tempName += [csv]
                    
                case 1:
                    tempPhone += [csv]
                    
                case 2:
                    tempExt += [csv]
                    
                default:
                    print("Error!")
                
                }
                
            }
            else
            {
            
              count += 1
                
            }
        
        }
        
        //return tempName
        cnName  = tempName
        cnPhone = tempPhone
        cnExt   = tempExt
        
    }
    
    //Method that returns that last 4 digits of a phone number
    func last4Digits(_ last4: String) -> String
    {
        
        return String(last4.suffix(4))
        
    }
    
    //Checks whether a number is a DID or not
    func isItDID(_ num: String) -> Bool
    {
        let dec: Int = Int(num)!
        
        //If the number in question does not fall within these ranges then is it not a DID
        if( ( ((dec > 5200) && (dec < 5299 ) ) || ( (dec > 6580) && (dec < 6599) ) || ( ( dec > 6660 ) && (dec < 6699) ) ) )
        {

            return true
            
        }
        else{ return false }
        
    }
    
    
    // This two functions can be used if you want to show the search bar in the section header
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return searchBar
//    }
    
//    // search bar in section header
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    //Function that returns a boolen value if user provided string has numbers in the search bar
    func hasNum(_ strInput: String) -> Bool
    {
        
        let strRange = NSRange(location: 0, length: strInput.utf16.count)
        let regexExt = try! NSRegularExpression(pattern: "[0-9]{1,3}")

        //If the string to be parsed has numbers then return true otherwise return false
        if(regexExt.firstMatch(in: strInput, options: [], range: strRange) == nil)
        {
            return false
        }
        else
        {
            return true
        }
        
        
    }
    
//    //Functions that checks if string input is a telephone
//    func isTel(_ strInput: String) -> Bool
//    {
//
//        let strRange = NSRange(location: 0, length: strInput.utf16.count)
//
//    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentEmployeeArray = EmployeeArray
            table.reloadData()
            return
            
        }
        
        
        
        //If user looks up via extension then deiplay relevant search
        //Otherwise display by name
        if(hasNum(searchText) == true)
        {
          currentEmployeeArray = EmployeeArray.filter({ Employee -> Bool in
            Employee.ext.lowercased().contains(searchText.lowercased())
            })
            table.reloadData()
        }
        else
        {
            currentEmployeeArray = EmployeeArray.filter({ Employee -> Bool in
                Employee.name.lowercased().contains(searchText.lowercased())
            })
            table.reloadData()
        }
            
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
            currentEmployeeArray = EmployeeArray
            table.reloadData()

        
            }
        
    





class Employee { // Main part of the program
    let name: String
    let ext: String
    let phone: String
    
    init(name: String, ext: String, phone: String) {
        self.name = name
        self.ext = ext
        self.phone = phone
    }
    
    
}

}
