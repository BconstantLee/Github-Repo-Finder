//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Bconsatnt on 3/2/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController {

    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    weak var delegate: SettingsPresentingViewControllerDelegate?
    var settings: GithubRepoSearchSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starSlider.value = Float((settings?.minStars)!)
        starLabel.text = "\(Int((settings?.minStars)!))"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.delegate?.didCancelSettings()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSave(_ sender: UIBarButtonItem) {
        settings?.minStars = Int(starSlider.value)
        self.delegate?.didSaveSettings(settings: settings!)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changeSlider(_ sender: AnyObject) {
        starLabel.text = "\(Int(starSlider.value))"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
