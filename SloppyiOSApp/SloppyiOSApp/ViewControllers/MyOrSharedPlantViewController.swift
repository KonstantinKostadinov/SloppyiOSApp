//
//  MyOrSharedPlantViewController.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 4.09.21.
//

import UIKit

protocol MyOrSharedPlantDelegate: class {
    func didTapClose(from viewController: MyOrSharedPlantViewController)
    func presentMotherPlant(from viewController: MyOrSharedPlantViewController, presenting vc: MainPlantDescriptionViewController)
}
class MyOrSharedPlantViewController: OverlayView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wateringDaysLabel: UILabel!
    @IBOutlet weak var motherPlantButton: UIButton!
    @IBOutlet weak var wateredButton: UIButton!
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!
    
    var delegate: MyOrSharedPlantDelegate?
    
    override var shouldClearBackground: Bool {
        didSet {
            super.shouldClearBackground = shouldClearBackground
        }
    }
    var plant = Plant()
    var tabBarConstant: CGFloat = 49

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.shouldClearBackground = true
        // Do any additional setup after loading the view.
    }

    private func setupViews() {
        nameLabel.text = plant.name
        if plant.lastTimeWatered < 10 {
            wateringDaysLabel.text = "Last time watered: Unknown "
        } else {
            let calendar = Calendar.current
            let wateredDay = Date(timeIntervalSince1970: plant.lastTimeWatered)
            let components = calendar.dateComponents([.day], from: wateredDay, to: Date())
            if components.day ?? 0 <  1 {
                wateringDaysLabel.text = "Last time watered: Today"
            } else {
                wateringDaysLabel.text = "Last time watered: Before \(components.day ?? 0)"

            }
        }
    }

    override func viewWillLayoutSubviews() {
        bottomContainerViewConstraint.constant = tabBarConstant
    }

    @IBAction func didTapShareButton(_ sender: Any) {
        print("⌲")
        let alert = UIAlertController(title: "Please enter your friend's email", message: nil, preferredStyle: .alert)
        alert.addTextField { (digitcode) in
            digitcode.placeholder = "Email"
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { (_) in
            guard let email = alert.textFields?.first?.text else { return }
            print("userEmail", email)
            let dictionary = ["email" : email,
                              "plantId" : self.plant.id]
            RequestManager.sharePlantViaEmail(dictionary: dictionary) { (message, error) in
                if let error = error {
                    self.view.showError(error: error.localizedDescription)
                } else {
                    self.view.showMessage(message: message)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in }
        alert.addAction(cancelAction)
        alert.addAction(shareAction)
        present(alert, animated: true)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        delegate?.didTapClose(from: self)
    }
    
    @IBAction func didTapMotherPlantButton(_ sender: Any) {
        guard let motherController = UIStoryboard.plant.instantiateViewController(withIdentifier: "MainPlantDescriptionViewController") as? MainPlantDescriptionViewController else { return }
        guard let motherPlant = LocalDataManager.realm.objects(MainPlant.self).filter({($0.name == self.plant.plantMainParent)}).first else { return }
        motherController.mainPlant = motherPlant
        self.delegate?.presentMotherPlant(from: self, presenting: motherController)
    }

    @IBAction func didTapWateredButton(_ sender: Any) {
        let realm = LocalDataManager.realm
        try! realm.write {
            plant.lastTimeWatered = Date().timeIntervalSince1970
            realm.add(plant, update: .all)
        }

        RequestManager.waterPlant(plantId: plant.id) {[weak self] (success, error) in
            if let error = error {
                self?.view.showError(error: error.localizedDescription)
            } else {
                self?.view.showMessage(message: "Success +1")
                NotificationManager.shared.createPushNotificationWithTime(flowerName: self?.plant.name ?? "", dateInterval: self?.plant.daysToWater ?? 1)
                DispatchQueue.main.async {
                    self?.setupViews()
                }
            }
        }
    }
}
