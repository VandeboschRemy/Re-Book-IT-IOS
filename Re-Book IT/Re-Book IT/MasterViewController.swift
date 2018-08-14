//
//  MasterViewController.swift
//  Re-Book IT
//
//  Created by Remy vandebosch on 11/07/18.
//  Copyright © 2018 Remy vandebosch. All rights reserved.
//

import UIKit
import SQLite
import NavBarDropdownMenu

class BookCell: UITableViewCell{
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var qualityTag: UIImageView!
    @IBOutlet weak var title: UILabel!
}

class ExpandableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}

class MasterViewController: UITableViewController, UISearchBarDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {

    var detailViewController: DetailViewController? = nil
    var objects = [Row]()
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: 20))
    var leftConstraint: NSLayoutConstraint!
    var query: String = String()
    var searchBy: Expression<String>? = nil
    @IBOutlet weak var spinner: UIPickerView!
    var detail: Row?
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        assert(navigationController != nil)
        
        let expandableView = ExpandableView()
        navigationItem.titleView = expandableView
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        expandableView.addSubview(searchBar)
        expandableView.alpha = 0.0
        leftConstraint = searchBar.leftAnchor.constraint(equalTo: expandableView.leftAnchor)
        leftConstraint.isActive = false
        searchBar.rightAnchor.constraint(equalTo: expandableView.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: expandableView.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor).isActive = true
        
        searchBar.placeholder = "Search a book"
        let leftNavButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggle))
        self.navigationItem.leftBarButtonItem = leftNavButton
        
        let dropDownMenu = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title(Constants.dropDownTitle), items: Constants.dropDown)
        menuView.addSubview(dropDownMenu)
        
        searchBy = Constants.title
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        NotificationCenter.default.addObserver(self, selector: #selector(showData), name: UserDefaults.didChangeNotification, object: nil)
        
        if(tableExists()){
            objects = Array(getDataFromDB())
        }
        
        downloader(url: "https://rebookit.be/search")
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.detailItem = objects[indexPath.row]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookCell

        let object = objects[indexPath.row]
        cell.title!.text = object[Constants.title]
        cell.layoutIfNeeded()
        
        cell.price!.text = "\(object[Constants.price])€"
        
        let quality = Int(object[Constants.quality])
        if(quality! <= 30){
            cell.qualityTag!.image = UIImage(named: "yellow_smiley")
        }
        else if(quality! > 30 && quality! <= 50){
            cell.qualityTag!.image = UIImage(named: "grey_smiley")
        }
        else if(quality! > 50 && quality! <= 70){
            cell.qualityTag!.image = UIImage(named: "red_smiley")
        }
        else if(quality! > 70){
            cell.qualityTag!.image = UIImage(named: "green_smiley")
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    // Download the booklist from the website in async.
    func downloader(url: String){
        self.showToast(msg: " Updating content ")
        
        let group = DispatchGroup()
        group.enter()
        
        let queue = DispatchQueue.main
        
        queue.async(){
            // make a request to the webserver
            let request = NSMutableURLRequest()
            request.url = URL(string: url)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if(error == nil){
                    var text = String(data: data!, encoding: String.Encoding.utf8)
                    text = self.convertToRightFormat(text: text!)
                    saveToDB(dataFromWebsite: text!)
                    self.showData()
                    group.leave()
                }
                else{
                    print(error ?? "")
                }
            })
            task.resume()
        }
        group.notify(queue: queue, execute: {
            self.showToast(msg: " Content updated ")
            self.tableView.reloadData()
        })
    }
    
    
    //Show a toast
    func showToast(msg: String){
        let label = UILabel()
        label.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.width/2, width: 0, height: 0)
        label.text = "\(msg)"
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(1.0)
        label.sizeToFit()
        label.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        label.alpha = 1.0
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 4,
                       animations: {
                        label.alpha = 0.0
        }, completion: {
            (isCompleted) in label.removeFromSuperview()
        })
    }
    
    //Convert the response from the website to the right format.
    func convertToRightFormat(text: String) -> String{
        
        
        let startIndex = indexOf(string: text, subString: "[{");
        let start = text.index(text.startIndex, offsetBy: startIndex)
        
        let endIndex = indexOf(string: text, subString: "}]")
        let end = text.index(text.startIndex, offsetBy: endIndex + "}]".count)
        
        let range = start..<end
        
        if(startIndex == -1 || endIndex == -1){
            return "nil"
        }
        let jsonFormat = text.substring(with: range)
        
        return jsonFormat
    }
    
    //find start index of a substring in a string
    func indexOf(string: String, subString: String) -> Int{
        var index = 0
        
        // Loop through parent string looking for the first character of the substring
        for char in string{
            if (subString.first == char) {
                let startOfFoundCharacter = string.index(string.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = string.index(string.startIndex, offsetBy: subString.count + index)
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                // Grab the substring from the parent string and compare it against substring
                // Essentially, looking for the needle in a haystack
                if string.substring(with: range) == subString {
                    return index
                    break
                }
                
            }
            index += 1
        }
        return -1
    }
    
    @objc func toggle() {
        
        let isOpen = leftConstraint.isActive == true
        
        // Inactivating the left constraint closes the expandable header.
        leftConstraint.isActive = isOpen ? false : true
        
        // Animate change to visible.
        UIView.animate(withDuration: 1, animations: {
            if (isOpen){
                self.navigationItem.titleView?.alpha = 0
                self.spinner.isHidden = true
                self.spinner.selectRow(0, inComponent: 0, animated: false)
                self.searchBy = Constants.title
                self.showData()
            }
            else {
                self.navigationItem.titleView?.alpha = 1
                self.searchBar.becomeFirstResponder()
            }
            
            self.navigationItem.titleView?.layoutIfNeeded()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        query = searchBar.text!
        self.spinner.isHidden = false
        objects = Array(getDataFromDBBySearch(searchQuery: query, searchBy: searchBy!))
        tableView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.searchChoice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Constants.searchChoice[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = Constants.searchChoice[row]
        
        if(selected == Constants.searchChoice[0]){
            searchBy = Constants.title
        }
        else if (selected == Constants.searchChoice[1]){
            searchBy = Constants.authors
        }
        else if (selected == Constants.searchChoice[2]){
            searchBy = Constants.courses
        }
        else if (selected == Constants.searchChoice[3]){
            searchBy = Constants.isbn
        }
        objects = Array(getDataFromDBBySearch(searchQuery: query, searchBy: searchBy!))
        tableView.reloadData()
    }
    
    // update the list with the data
    @objc func showData(){
        self.objects = Array(getDataFromDB())
        self.tableView.reloadData()
    }
}


