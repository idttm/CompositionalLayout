//
//  UserCell.swift
//  CompositionalLayout
//
//  Created by Andrew Cheberyako on 25.06.2021.
//

import UIKit

protocol SelfconfiguringCell {
    static var reusedId: String {get}
    func configure(with intValue: Int)
}

class UserCell: UICollectionViewCell, SelfconfiguringCell {
    static var reusedId: String = "UserCell"
    
    func configure(with intValue: Int) {
        print("123")
    }
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstrains() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .blue
        addSubview(friendImageView)
        friendImageView.frame = self.bounds
        backgroundColor = .blue
    }
    
}
