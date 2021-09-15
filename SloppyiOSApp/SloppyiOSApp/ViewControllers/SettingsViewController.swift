//
//  SettingsViewController.swift
//  SettingsViewController
//
//  Created by Konstantin Kostadinov on 11.09.21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let logoutQueue = DispatchQueue(label: "logout queue")
    var tableViewData = ["Email","Times you watered your plants", "Times you watered shared flowers","Change Password", "Logout"]
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         user = LocalDataManager.realm.objects(User.self).first ?? User()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let index = indexPath.row
        cell.textLabel?.text = tableViewData[index]
        switch index {
        case 0:
            guard let user = LocalDataManager.realm.objects(User.self).first else { return cell}
            cell.detailTextLabel?.text = user.email
        case 1:
            let ownedPlants = [Plant](LocalDataManager.realm.objects(Plant.self)).filter({user.plantIds.contains($0.id)})
            var timesWatered = 0
            for plant in ownedPlants {
                timesWatered += plant.timesPlantIsWatered
            }
            cell.detailTextLabel?.text = "\(timesWatered)"
        case 2:
            let sharedPlants = [Plant](LocalDataManager.realm.objects(Plant.self)).filter({user.sharedPlantsIds.contains($0.id)})
            var timesWatered = 0
            for plant in sharedPlants {
                timesWatered += plant.timesPlantIsWatered
            }
            cell.detailTextLabel?.text = "\(timesWatered)"
        default:
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 3:
            let alert = UIAlertController(title: "Please enter new password", message: nil, preferredStyle: .alert)
            alert.addTextField { (digitcode) in
                digitcode.placeholder = "New password"
            }
            let shareAction = UIAlertAction(title: "Change password", style: .default) { (_) in
                guard let password = alert.textFields?.first?.text else { return }
                return
                //TODO: Change pass functionality
//                RequestManager.sharePlantViaEmail(dictionary: dictionary) { (message, error) in
//                    if let error = error {
//                        self.view.showError(error: error.localizedDescription)
//                    } else {
//                        self.view.showMessage(message: message)
//                    }
//                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in }
            alert.addAction(shareAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        case 4:
            let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
            let shareAction = UIAlertAction(title: "Log Out", style: .destructive) { [self] (_) in
                logoutQueue.async {
                    let realm = LocalDataManager.backgroundRealm(queue: self.logoutQueue)
                    try? realm.write {
                        realm.deleteAll()
                    }
                    UserDefaultsData.isUserLoggedIn = false
                    UserDefaultsData.token = ""
                    UserDefaultsData.userEmail = ""
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "fromSettingsToLoginSegue", sender: nil)
                    }
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in }
            alert.addAction(shareAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        default:
            return
        }
    }
}
