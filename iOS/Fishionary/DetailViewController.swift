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
    
    let props = DataManager.shared.filter_props()

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var detailConcernLabel: UILabel!
    
    
    var targetPicker : DownPicker!
    var translationsController : TranslationsViewController!
    
    var detailItem: Fish? 

    func configureView() {
        // Update the user interface for the detail item.
        guard let fish = self.detailItem else {
            preconditionFailure("no fish available")
        }
            
        let source = ConfigManager.shared.source
        let name = fish.name(target: source)
        let source_prop = DataManager.shared.search_prop(name: source)
        
        self.title = String(format: "%@ (%@)"
            ,name
            ,source_prop!.header)
        
        let target = ConfigManager.shared.target
        
        if let label = self.detailDescriptionLabel {
            label.text = fish.name(target: target)
        }
        
        if let imageView = self.detailImage {
            let content = fish.imageContent()
            imageView.contentMode = .scaleAspectFit
            imageView.image = content
        }
        
        let concern = fish.concern ?? ""
        let rendering = SimpleRenderer.render(concern: concern)
        let htmlData = rendering.data(using: .utf8)!
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try! NSMutableAttributedString(data: htmlData,
                                                              options: options,
                                                              documentAttributes: nil)
        
        detailConcernLabel.attributedText = attributedString
        detailConcernLabel.isHidden = concern.isEmpty
        detailConcernLabel.isUserInteractionEnabled = true
        detailConcernLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapConcern)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = [] // no overlap with navigation bar
        if detailItem == nil {
            let objects = DataManager.shared.database
            let index = DataManager.search_fish(scientific: "SPARUS AURATA", fishes: objects)
            if index >= 0 {
                self.detailItem = objects[index]
            }
        }
        self.configureView()
        
        let props = DataManager.shared.filter_props()
        let texts = props.map() {
            return $0.header
        }
        
        let target = ConfigManager.shared.target
        let prop = DataManager.shared.search_prop(name: target)
        targetTextField.text = prop?.header
        
        targetPicker = DownPicker.init(textField: targetTextField, withData: texts)
        targetPicker.addTarget(self, action: #selector(targetSelected), for: .valueChanged)
        
         //setup UITapGestureRecognizer to detect when the user click on the fish ( UIImageView )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showImageOnClick))
        detailImage.isUserInteractionEnabled = true
        detailImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            
            let controller = segue.destination as! ImageViewController
            let image = detailItem?.imageContent()
            controller.image = image
        
        } else if segue.identifier == "showTranslations" {
            
            translationsController = segue.destination as? TranslationsViewController
            prepareTranslations()
            
        }
    }
    
    // other stuff
    
    func prepareTranslations() {
        guard let fish = self.detailItem else { return }
        let names = fish.names(target: ConfigManager.shared.target)
        translationsController.objects = names
        
        containerHeight.constant = CGFloat(names.count * 44)
        view.layoutIfNeeded()
    }
    
    @objc func targetSelected(_ sender: AnyObject) {
        //print("targetSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getView().selectedRow(inComponent: 0)
        let value = props[row].name
        print("target = \(value)")
        ConfigManager.shared.target = value
        prepareTranslations()
    }

    
    @objc func showImageOnClick(_ img: AnyObject) {
        performSegue(withIdentifier: "showImage", sender: nil)
    }
    
    @objc func tapConcern() {
        let attributedString = detailConcernLabel.attributedText!
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

private struct SimpleRenderer {
    static func render(concern: String) -> String {
        return """
<html>
<style type="text/css">
body {
    font-family: "-apple-system", "sans-serif";
    font-size: 14px;
}
h2 {
    font-size: 17px;
}
</style>
<body>
    <hr>
    <h2>Concern :</h2>
    <p>\(concern)</p>
</body>
</html>
"""
    }
}
