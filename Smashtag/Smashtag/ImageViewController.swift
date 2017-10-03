//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Егор on 03.10.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var detailImage: UIImageView!
    
    var URL: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let imageURl = URL {
            DispatchQueue.global(qos: .userInitiated).async {
                let contentOfUrl = try? Data(contentsOf: imageURl)
                DispatchQueue.main.async {
                    if imageURl == self.URL {
                        if let data = contentOfUrl {
                            self.detailImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
