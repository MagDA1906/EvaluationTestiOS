//
//  HeaderAlbumTableViewCell.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 17.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class HeaderAlbumTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let nibName = String(describing: HeaderAlbumTableViewCell.self)
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionName: UILabel!
    @IBOutlet private weak var artistName: UILabel!
    @IBOutlet private weak var primaryGenreName: UILabel!
    @IBOutlet private weak var collectionImage: UIImageView!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var copyright: UILabel!
    @IBOutlet private weak var country: UILabel!
    @IBOutlet private weak var track: UILabel!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var trackCount: UILabel!
    @IBOutlet private weak var released: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var listOfTracks: UILabel!
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSelf()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionName.text = ""
        artistName.text = ""
        primaryGenreName.text = ""
        collectionImage.image = nil
        releaseDate.text = ""
        copyright.text = ""
        country.text = ""
        trackCount.text = ""
        track.text = ""
        released.text = ""
        listOfTracks.text = ""
    }
}

// MARK: - Public Functions

extension HeaderAlbumTableViewCell {
    
    func configureSelfUsingModel(_ model: Album, _ albumDate: String) {
        
        spinner.startAnimating()
        
        collectionName.text = model.collectionName
        artistName.text = model.artistName
        primaryGenreName.text = model.primaryGenreName
        releaseDate.text = albumDate //StorageManager.shared.getDateFrom(model)
        copyright.text = model.copyright
        country.text = model.country
        trackCount.text = String(model.trackCount)
        track.text = "Tracks:"
        released.text = "Release:"
        listOfTracks.text = "Tracks"
        
        guard let url = URL(string: model.artworkUrl100) else { return }
        collectionImage.sd_setImage(with: url) { (image, error, imageCachType, url) in
            self.spinner.stopAnimating()
        }
    }
}

// MARK: - Private Functions

private extension HeaderAlbumTableViewCell {
    
    func configureSelf() {
        
        self.backgroundColor = UIColor.clear
        self.contentView.frame = contentView.frame.insetBy(dx: 4, dy: 4)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
    }
}
