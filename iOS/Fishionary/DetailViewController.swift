//
//  DetailViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import DownPicker
import SafariServices


final class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var detailConcernTextView: UITextView!
    
    var targetPicker: DownPicker!
    var translationsController: TranslationsViewController!
    
    var vm: DetailViewModel!
    
    enum Action {
        case showImage(image: UIImage)
    }
    
    var callback: ((Action) -> ())?

    func configureView() {
        // Update the user interface for the detail item.
        self.title = vm.title

        detailImage.contentMode = .scaleAspectFit
        //detailImage.image = vm.image
        detailImage.image = nil
        ImageLoader.shared.load(path: vm.imagePath) { [weak self] image in
            self?.detailImage.image = image
        }
        
        detailConcernTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        detailConcernTextView.attributedText = vm.concern
        detailConcernTextView.isHidden = !vm.hasConcern
        detailConcernTextView.isUserInteractionEnabled = true
        detailConcernTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapConcern)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = [] // no overlap with navigation bar

        self.configureView()
        
        targetTextField.text = vm.target
        targetPicker = DownPicker.init(textField: targetTextField, withData: vm.targetTexts)
        targetPicker.addTarget(self, action: #selector(targetSelected), for: .valueChanged)
        
         //setup UITapGestureRecognizer to detect when the user click on the fish ( UIImageView )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showImageOnClick))
        detailImage.isUserInteractionEnabled = true
        detailImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTranslations" {
            
            translationsController = segue.destination as? TranslationsViewController
            prepareTranslations()
            
        }
    }
    
    // other stuff
    
    func prepareTranslations() {
        let names = vm.names
        translationsController.objects = names
        
        containerHeight.constant = CGFloat(names.count) * translationsController.tableView.rowHeight
        view.setNeedsUpdateConstraints()
    }
    
    @objc func targetSelected(_ sender: AnyObject) {
        //print("targetSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getView().selectedRow(inComponent: 0)
        let value = vm.props[row].name
        print("target = \(value)")
        ConfigManager.shared.target = value
        prepareTranslations()
    }

    @IBAction func actionView(_ sender: Any) {
        showImageOnClick()
    }
    
    @objc func showImageOnClick() {
        ImageLoader.shared.load(path: vm.imagePath) { [weak self] image in
            guard let image = image else { return }
            self?.callback?(.showImage(image: image))
        }
    }
    
    @objc func tapConcern() {
        let attributedString = detailConcernTextView.attributedText!
        guard let link = attributedString.links.first else { return }
        let safariVC = SFSafariViewController(url: link)
        present(safariVC, animated: true, completion: nil)
    }
}

private extension NSAttributedString {
    var links: [URL] {
        var links = [URL]()
        self.enumerateAttribute(.link, in: NSRange(0..<self.length), options: []) { value, range, stop in
            if let value = value as? URL {
                links.append(value)
            }
        }
        return links
    }
}


