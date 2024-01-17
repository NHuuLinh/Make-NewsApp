//
//  CategoriesTableViewCell.swift
//  Newsapp
//
//  Created by LinhMAC on 29/08/2023.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    /// Truyền xuống từ HomeViewController sau khi call API ở HomeViewController
    private var categories = [String]()
    
    /// Sử dụng closure để call back click vào 1 category cho HomeViewController
    private var onClickCategory: ((IndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        // Setting collection view
        if let flowLayout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            
            flowLayout.minimumLineSpacing = 0 // Do có 1 dòng nên cái này cho về 0 hoặc nếu không muốn cách nhau giữa các dòng/cột thì cũng cho về 0
            flowLayout.minimumInteritemSpacing = 10 // Cách đều các item là 10 pixel
        }
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
    
    /**
     Truyền data và closure call từ HomeViewController xuống đây
     */
    func bindData(categories: [String], onClickCategory: ((IndexPath) -> Void)?) {
        self.categories = categories
        self.onClickCategory = onClickCategory
        self.categoriesCollectionView.reloadData()
    }
}

extension CategoriesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// Số items của collectionview sẽ hiển thị sao số phần tử của mảng categories định nghĩa
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// Lôi ra collection view cell đã define để thực hiện hiển thị cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        
        /// Lấy ra category title ở item thứ indexPath.row
        /// Ví dụ: item có index = 0 => All
        /// item có index = 1 => Sports.....
        let category = categories[indexPath.row]
        
        /// Truyền text category vào trong class để set category label để hiển thị lên màn hình
        cell.bindData(category: category)
        
        return cell
    }
}

extension CategoriesTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    /**
     Tính toán kích thước của items để hiển thị
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// Lấy ra category title ở item thứ indexPath.row
        /// Ví dụ: item có index = 0 => All
        /// item có index = 1 => Sports.....
        let category = categories[indexPath.row]
        
        /// Tính chiều rộng của text (All, sport, tech,...)
        let font = UIFont(name: "Poppins-Regular", size: 16) ?? .systemFont(ofSize: 16)
        let titleWidth = category.width(withConstrainedHeight: 30, font: font)
        
        print("Category có title là \(category) sẽ có width bằng \(titleWidth)")
        
        /// Định nghĩa lại size cho item
        return CGSize(width: titleWidth, height: collectionView.bounds.height)
    }
    
    /// Margin 2 bên trái phải
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    /// Khi user chọn vào 1 category thì call closure để truyền action về HomeViewController để call lại API
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onClickCategory?(indexPath)
    }
}
