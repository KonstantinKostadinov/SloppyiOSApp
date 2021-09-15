//
//  MainPlantsViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 3.09.21.
//

import UIKit

class MainPlantsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    

    var mainPlants: [MainPlant] = [MainPlant]()
    var selectedRow: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchAllMainPlants()
        // Do any additional setup after loading the view.
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func fetchAllMainPlants() {
        mainPlants = [MainPlant](LocalDataManager.realm.objects(MainPlant.self))
        tableView.reloadData()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainPlantInformationSegue" {
            guard let destinationVC = segue.destination as? MainPlantDescriptionViewController else { return }
            destinationVC.mainPlant = mainPlants[selectedRow]
        }
    }

}

extension MainPlantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPlants.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userPlantCellIdentifier", for: indexPath) as? UserPlantTableViewCell else {
            return UITableViewCell()
        }
        cell.plantNameLabel.text = mainPlants[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "toMainPlantInformationSegue", sender: nil)
    }
}
