//
//  ViewController.swift
//  YouPlayer
//
//  Created by Elisabet Massó on 07/11/2020.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let vc = UIStoryboard(name: "VideoListView", bundle: Bundle(for: type(of: self))).instantiateViewController(identifier: "VideoListViewId") as? VideoListViewController else { return }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isModalInPresentation = true
        nvc.modalPresentationStyle = .overFullScreen
        
        present(nvc, animated: true)
    }
    
}

