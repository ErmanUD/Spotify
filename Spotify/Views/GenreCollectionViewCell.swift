//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Erman Ufuk Demirci on 27.10.2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .red
        imageView.image = UIImage(systemName: "music.quarternote.3")
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width - 20,
            height: contentView.height/2
        )
        imageView.frame = CGRect(
            x: contentView.height/2,
            y: 0,
            width: contentView.width/2,
            height: contentView.height/2
        )
    }
    
    func configure(with title: String) {
        label.text = title
        contentView.backgroundColor = .systemMint
    }
}
