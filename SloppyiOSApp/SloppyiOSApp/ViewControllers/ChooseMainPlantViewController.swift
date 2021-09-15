//
//  ChooseMainPlantViewController.swift
//  ChooseMainPlantViewController
//
//  Created by Konstantin Kostadinov on 10.09.21.
//

import UIKit

class ChooseMainPlantViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allPlants = [MainPlant]()
    let searchController = UISearchController(searchResultsController: nil)
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        self.searchController.searchResultsUpdater = self

        self.navigationItem.hidesSearchBarWhenScrolling = false
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchBar()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func fetchData() {
        allPlants = [MainPlant](LocalDataManager.realm.objects(MainPlant.self))
        user = LocalDataManager.realm.objects(User.self).first!
        tableView.reloadData()
    }

    private func setupSearchBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationController?.definesPresentationContext = true

        self.searchController.searchBar.placeholder = "Name of plant"
        self.navigationItem.searchController = self.searchController
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.barTintColor = UIColor.black
        self.searchController.searchBar.backgroundImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
        
        if #available(iOS 13.0, *) {
            self.searchController.searchBar.setSearchFieldBackgroundColor(UIColor.white)
            self.searchController.searchBar.searchTextField.textColor = UIColor.black
            self.searchController.searchBar.searchTextField.tokenBackgroundColor = UIColor.black
            self.searchController.searchBar.searchTextField.tintColor = UIColor.black
            self.searchController.searchBar.searchTextField.leftView?.tintColor = UIColor.black
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
@available(iOS 13.0, *)
extension UISearchBar {
  /// This solves iOS 13 issue which is a light gray overay covers the textField.
  /// - Parameter color: A color for searchField
  func setSearchFieldBackgroundColor(_ color: UIColor) {
    searchTextField.backgroundColor = color
    setSearchFieldBackgroundImage(UIImage(), for: .normal)
    // Make up the default cornerRadius changed by `setSearchFieldBackgroundImage(_:for:)`
    searchTextField.layer.cornerRadius = 10
    searchTextField.clipsToBounds = true
  }
}

extension ChooseMainPlantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allPlantsCellIdentifier", for: indexPath)
        let plant = allPlants[indexPath.row]
        cell.textLabel?.text = plant.name
        cell.detailTextLabel?.text  = plant.scientificName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPlant = allPlants[indexPath.row]
        let alert = UIAlertController(title: "Please enter name for your plant and time interval for it's watering", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name"
            nameTextField.keyboardType = .default
        }
        alert.addTextField { (daysToWaterTextField) in
            daysToWaterTextField.placeholder = "Days to water"
            daysToWaterTextField.keyboardType = .decimalPad
        }
        let shareAction = UIAlertAction(title: "Create own plant", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text else { return }
            guard let text = alert.textFields?.last?.text else { return }
            let daysToWater = (text as NSString).integerValue
           // RequestManager.
            let dictionary: [String:Any] = ["name" : name,
                                            "notes" : "",
                                            "lastTimeWatered" : Date().timeIntervalSince1970,
                                            "daysToWater" : daysToWater,
                                            "timesPlantIsWatered" : 0,
                                            "plantMainParent" : selectedPlant.name,
                                            "assignedToFriendsWithIds": [UUID](),
                                            "parentId" : self.user.userID
            ]
            
            RequestManager.sendNewPlantInformation(dictionary: dictionary) { success, error in
                print(success, error)
                self.view.showMessage(message: "Success")
                RequestManager.fetchOwnedAndSharedPlaintIds()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.view.dismissProgressHUD()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in }
        alert.addAction(cancelAction)
        alert.addAction(shareAction)
        present(alert, animated: true)
    }
}

extension ChooseMainPlantViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.isEmpty {
            fetchData()
            return
        }

        allPlants = [MainPlant](LocalDataManager.realm.objects(MainPlant.self)).filter({$0.name.lowercased().contains(searchText.lowercased()) ||
            $0.scientificName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
