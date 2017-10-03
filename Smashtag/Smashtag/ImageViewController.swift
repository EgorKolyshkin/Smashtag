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
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = detailImage.frame.size
            scrollView.addSubview(detailImage)
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
    
    fileprivate var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ImageViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailImage
    }
}
