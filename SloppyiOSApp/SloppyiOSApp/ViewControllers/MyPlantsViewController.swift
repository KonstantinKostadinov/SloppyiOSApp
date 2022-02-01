//
//  SomeViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 1.09.21.
//

import UIKit

class MyPlantsViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPlantBarButton: UIBarButtonItem!
    
    var screenConfig: Config = .owned {
        didSet {
            fetchData()
            tableView.reloadData()
        }
    }

    var plants: [Plant] = [Plant]() {
        didSet {
            tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
        NotificationManager.shared.requestNotificationAuthorization()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        RequestManager.fetchOwnedAndSharedPlaintIds { [self] _, _ in
//            fetchData()
//        }
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func fetchData() {
        guard let user = LocalDataManager.realm.objects(User.self).first else { return }
        switch screenConfig {
        case .owned:
            plants = [Plant](LocalDataManager.realm.objects(Plant.self)).filter({user.plantIds.contains($0.id)})
        case .sharedToMe:
            plants = [Plant](LocalDataManager.realm.objects(Plant.self)).filter({user.sharedPlantsIds.contains($0.id)})
        }
    }
    @IBAction func didTapAddPlant(_ sender: Any) {
        self.performSegue(withIdentifier: "chooseMainPlantIdentifier", sender: nil)
    }
    
    @IBAction func didTapSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            screenConfig = .owned
        case 1:
            screenConfig = .sharedToMe
        default:
            return
        }
    }

    func waterMeAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
//            RequestManager.waterPlant(plantId: self.plants[indexPath.row].id) { (success, error) in
//                if let error = error {
//                    self.view.showError(error: error.localizedDescription)
//                } else {
//                    self.view.showMessage(message: "Success +1")
//                    NotificationManager.shared.createPushNotificationWithTime(flowerName: self.plants[indexPath.row].name, dateInterval: self.plants[indexPath.row].daysToWater)
//                }
//            }
        }
        
        action.image = UIImage(named: "water_refresh")
        action.backgroundColor = .white
        return action
    }
}


extension MyPlantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let waterMeAction = waterMeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [waterMeAction])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if plants.isEmpty {
            return 1
        }
        return plants.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if plants.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noPlantCellIdentifier", for: indexPath)
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = "You have not added a plant yet."
            default:
                cell.textLabel?.text = "You do not have shared plant with you."
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userPlantCellIdentifier", for: indexPath) as? UserPlantTableViewCell else {
            return UITableViewCell()
        }
        cell.plantNameLabel.text = plants[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if plants.isEmpty {
            return
        }
        guard let myOrSharedPlantViewController = UIStoryboard.plant.instantiateViewController(withIdentifier: "MyOrSharedPlantViewController") as? MyOrSharedPlantViewController else { return }
        myOrSharedPlantViewController.modalPresentationStyle = .overCurrentContext
        myOrSharedPlantViewController.plant = plants[indexPath.row]
        myOrSharedPlantViewController.tabBarConstant = tabBarController?.tabBar.frame.size.height ?? 49
        myOrSharedPlantViewController.delegate = self
        self.present(myOrSharedPlantViewController, animated: true, completion: nil)
    }
}

extension MyPlantsViewController: MyOrSharedPlantDelegate {
    func presentMotherPlant(from viewController: MyOrSharedPlantViewController, presenting vc: MainPlantDescriptionViewController) {
        viewController.dismiss(animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapClose(from viewController: MyOrSharedPlantViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

enum Config {
    case owned
    case sharedToMe
}
