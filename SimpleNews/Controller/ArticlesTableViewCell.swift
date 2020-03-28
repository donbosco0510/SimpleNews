//
//  ArticlesTableViewCell.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
        
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var articleLinkURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with articleData: Article?) {
        let newsDataManager = NewsDataManager()
        self.titleLabel.text = articleData?.title ?? "Untitled"
        self.authorLabel.text = "By: \(articleData?.author ?? "N/A")"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatterGet.date(from: articleData?.publishedAt! ?? "") {
            self.dateLabel.text = "Published on: \(dateFormatterPrint.string(from: date))"
        } else {
           self.dateLabel.text = ""
        }
        self.contentTextView.text = articleData?.content
        if let imageURL = URL(string: articleData?.urlToImage ?? "") {
            self.indicatorView.startAnimating()
            newsDataManager.downloadImage(from: imageURL, cell: self)
        } else {
            self.indicatorView.startAnimating()
            self.articleImage.image = UIImage(named: "no_image_available", in: Bundle.main, compatibleWith: nil)
        }
        self.indicatorView.hidesWhenStopped = true
        self.articleImage.clipsToBounds = true
        self.articleLinkURL = articleData?.url
        self.contentTextView.backgroundColor = .none
    }}
