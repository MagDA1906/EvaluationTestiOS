//
//  TrackTableViewCell.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 17.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseId = String(describing: TrackTableViewCell.self)
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = label.font.withSize(14.0)
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9019607843, blue: 0.937254902, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.backgroundView?.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        let frame = self.bounds
        backView.frame = frame

        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true

        addSubview(backView)
        addSubview(trackNameLabel)
        
        // backView constraints
        backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        // trackNameLabel constraints
        trackNameLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        trackNameLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16).isActive = true
        trackNameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
