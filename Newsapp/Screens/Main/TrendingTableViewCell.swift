//
//  TrendingTableViewCell.swift
//  Newsapp
//
//  Created by LinhMAC on 26/08/2023.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var avatarAuthor: UIImageView!
    @IBOutlet weak var authorLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var createdAtLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsImage.layer.cornerRadius = 6
        newsImage.clipsToBounds = true
        
        avatarAuthor.layer.cornerRadius = 10
        avatarAuthor.clipsToBounds = true
        
        resetView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    private func resetView() {
        titleLb.text = nil
        createdAtLb.text = nil
        newsImage.image = nil
        avatarAuthor.image = nil
        authorLb.text = nil
        
    }
    
    func bindData(news: NewsEntity) {
        titleLb.text = news.title
        createdAtLb.text = news.created_at
        
        authorLb.text = news.author?.name
        
        if let newsImageString = news.image {
            let newsImageUrl = URL(string: newsImageString)
            if let imageUrlString = newsImageUrl?.absoluteString {
                print("Địa chỉ URL của hình ảnh: \(imageUrlString)")
            }
            
            newsImage.kf.setImage(with: newsImageUrl)
        } else {
            newsImage.image = UIImage(named: "warning")
        }
        
        if let avatarString = news.author?.avatar {
            let avatarUrl = URL(string: avatarString)
            avatarAuthor.kf.setImage(with: avatarUrl)
        } else {
            avatarAuthor.image = UIImage(named: "warning")
        }
        
        /// https://nsdateformatter.com/
        if let createdAtString = news.created_at {
            let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let createdAtDate = dateFormatter.date(from: createdAtString) {
                let now = Date()
                let createdAtDisplay = createdAtDate.timeSinceDate(fromDate: now)
                createdAtLb.text = createdAtDisplay
            } else {
                createdAtLb.text = nil
            }
        } else {
            createdAtLb.text = nil
        }
    }
}
