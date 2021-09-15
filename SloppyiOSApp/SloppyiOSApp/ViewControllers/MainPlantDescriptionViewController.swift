//
//  MainPlantDescriptionViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 4.09.21.
//

import UIKit

class MainPlantDescriptionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    

    var mainPlant = MainPlant()
    var propertyDictionary = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        propertyDictionary = mainPlant.json
        _ = propertyDictionary.removeValue(forKey: "id")

        tableView.reloadData()
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

}
extension MainPlantDescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return propertyDictionary.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(propertyDictionary.keys)[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let expandableCell = tableView.dequeueReusableCell(withIdentifier: "expandableCell", for: indexPath) as? ExpandableCell else {
            return UITableViewCell()
        }
        expandableCell.informationLabel.text = Array(propertyDictionary.values)[indexPath.section] as? String ?? "hazhjsgkjzdghfkjsdhgfksdjhgfksdjhfgskjdhfgksjdhfgskjdhfgskdjhfgskdjhfgskjdhfgskjdhfgksjdhfgkjshdfgsjdgfjshgfkjshdgfksjdhfgksjdhfgskjdhfgskjhfgskdjhgfsjkdhfgskjhgjkfhsgfkjhsagkha"
        return expandableCell
    }
    
    
}
