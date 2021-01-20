//
//  AlbumsCollectionViewCell.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.

import UIKit
import SDWebImage

class AlbumsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let nibName = String(describing: AlbumsCollectionViewCell.self)
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionName: UILabel!
    @IBOutlet private weak var artistName: UILabel!
    @IBOutlet private weak var collectionImage: UIImageView!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSelf()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionName.text = ""
        artistName.text = ""
        collectionImage.image = nil
    }
    
    
}

// MARK: - Public Functions

extension AlbumsCollectionViewCell {
    
    func configureSelfUsingModel(_ model: Album) {
        
        spinner.startAnimating()
        collectionName.text = model.collectionName
        artistName.text = model.artistName
        
        guard let url = URL(string: model.artworkUrl100) else { return }
        
        collectionImage.sd_setImage(with: url) { (image, error, imageCachType, url) in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
    }
}

// MARK: - Private Functions

private extension AlbumsCollectionViewCell {
    
    func configureSelf() {
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        self.contentView.frame = contentView.frame.insetBy(dx: 4, dy: 4)
        
        configureBackView()
        configureShadowView()
    }
    
    func configureBackView() {
        
        backView.layer.cornerRadius = 8
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.black.cgColor
        backView.layer.masksToBounds = true
    }
    
    func configureShadowView() {
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
}
