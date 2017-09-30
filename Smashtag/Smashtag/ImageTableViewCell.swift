//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Егор on 25.09.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var TweetImage: UIImageView!
    
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
                            self.TweetImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
