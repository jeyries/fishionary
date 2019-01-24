//
//  AppFlow.swift
//  Fishionary
//
//  Created by Julien Eyries on 24/01/2019.
//  Copyright © 2019 jeyries. All rights reserved.
//

import UIKit


final class AppFlow {
    
    private let navigationController: UINavigationController
    private var masterViewController: MasterViewController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMaster()
    }
    
    private func showMaster() {
        let controller = MainStoryboard.masterViewController
        self.masterViewController = controller
        navigationController.pushViewController(controller, animated: false)
        controller.callback = { [weak self] action in
            switch action {
            case .showDetail(let fish):
                self?.showDetail(fish: fish)
            case .showMenu:
                self?.showMenu()
            }
        }
    }
    
    private func showDetail(fish: Fish) {
        let controller = MainStoryboard.detailViewController
        controller.vm = DetailViewModel(fish: fish)
        controller.navigationItem.leftItemsSupplementBackButton = true
        navigationController.pushViewController(controller, animated: true)
        controller.callback = { [weak self] action in
            switch action {
            case .showImage(let image):
                self?.showImage(image: image)
            }
        }
    }
    
    private func showImage(image: UIImage) {
        let controller = MainStoryboard.imageViewController
        controller.image = image
        navigationController.present(controller, animated: true, completion: nil)
    }
    
    private func showMenu() {
        let menu = MainMenu() { [weak self] action in
            switch action {
            case .showSettings:
                self?.showSettings()
            case .showGallery:
                self?.showGallery()
            case .showInfo:
                self?.showInfo()
            }
        }
        let controller = menu.alertController
        navigationController.present(controller, animated: true, completion: nil)
    }
 
    private func showSettings() {
        let controller = MainStoryboard.settingsViewController
        navigationController.present(controller, animated: true, completion: nil)
    }
    
    private func showGallery() {
        let controller = WaterfallViewController()
        let navigation = UINavigationController.init(rootViewController: controller)
        navigationController.present(navigation, animated: true, completion: nil)
        controller.didSelect = { [weak self] fish in
            let name = fish.name(target: "scientific")
            print("selected \(name)")
            navigation.dismiss(animated: true) {
                self?.masterViewController.select_fish(scientific: name)
            }
        }
    }
    
    private func showInfo() {
        let requestURL = Bundle.main.bundleURL
            .appendingPathComponent("data/info/index.html")
        
        let controller = WebViewController(requestURL: requestURL)
        controller.title = "Informations"
        
        let navigation = UINavigationController.init(rootViewController: controller)
        navigationController.present(navigation, animated: true, completion: nil)
    }
}



