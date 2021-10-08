//
//  ImageCollectionViewCell.swift
//  copybook
//
//  Created by Simonarde Lima on 07/10/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setup(with url: URL) {
        self.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [unowned self] in
                    self.photoImageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
