//
//  FootCell.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 25.06.2021.
//

import UIKit

class FootCell: UICollectionViewCell, SelfconfiguringCell {
    
    
    static var reusedId: String = "FootCell"
    
    func configure(with intValue: Int) {
        label.text = String(intValue)
    }
    let friendImageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstrains() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        addSubview(label)
        label.frame = self.bounds
        label.text = "1"
        
    }
  
}

