//
//  ViewController.swift
//  AstroChannels
//
//  Created by Candice H on 9/15/17.
//  Copyright © 2017 nhunghuynhthihong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAstroChannelsAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "ChannelsViewController") as! ChannelsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTVGuideAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "TVGuideViewController") as! TVGuideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

