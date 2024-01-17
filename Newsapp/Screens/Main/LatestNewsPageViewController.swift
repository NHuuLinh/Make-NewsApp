//
//  LatestNewsPageViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 05/09/2023.
//

import UIKit
import Alamofire

class LatestNewsPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum HomeNewsSection: Int {
        case categories = 0
        case latestNews
    }
    private var sections = [HomeNewsSection]()
    private var latestNews = [NewsEntity]()
    
    private var categories = [CategoryEntity]()
    private var categoriesString = [String]()
    
    @IBOutlet weak var LatestNewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Khởi tạo mảng sections
        sections = [ .categories, .latestNews]
        LatestNewTableView.reloadData()
        
        getLatetestNews()
        getCategories()
    }
    
    private func setupTableView() {
        LatestNewTableView.dataSource = self // self chính instance  của HomeViewController
        
        LatestNewTableView.delegate = self
        
        LatestNewTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LatestNewsTableViewCell", bundle: nil)
        LatestNewTableView.register(nib, forCellReuseIdentifier: "LatestNewsTableViewCell")
        
        
        let customHeaderCell = UINib(nibName: "CustomHeaderTableViewCell", bundle: nil)
        LatestNewTableView.register(customHeaderCell, forCellReuseIdentifier: "CustomHeaderTableViewCell")
        let categoriesCell = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
        LatestNewTableView.register(categoriesCell, forCellReuseIdentifier: "CategoriesTableViewCell")
    }
    private func getLatetestNews(categoryId: String? = nil) {
        var param: [String: Any] = [
            "page": 1,
            "pageSize": 20,
        ]
        
        if let cateId = categoryId {
            param["category_id"] = "\(cateId)"
        }
        
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/posts",
                   method: .get,
                   parameters: param,
//                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken)"
                   ])
        .validate(statusCode: 200..<299)
        .responseDecodable(of: ArrayResponse<NewsEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let newsList = data.data {
                    self.latestNews = newsList
                    self.LatestNewTableView.reloadData()
                }
                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                break
            }
        }
    }
    private func getCategories() {
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/categories",
                   method: .get,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken)"
                   ])
        .validate(statusCode: 200..<299)
        .responseDecodable(of: ArrayResponse<CategoryEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let categories = data.data {
                    /// Lưu lại categories lấy đươc từ API để xử lý click
                    self.categories = categories
                    
                    /// Chuyển từ mảng categories lấy được từ API sang 1 mảng string để xử lý hiển thị
                    self.categoriesString = categories.map({ category in
                        return category.title ?? ""
                    })
                    
                    /// Do trong design có 1 tab là "All" nên sẽ add thêm 1 item là "All" vào vị trí đầu tiên của mảng
                    self.categoriesString.insert("All", at: 0)
                    
                    /// Reload lại toàn bộ data của tableview
                    self.LatestNewTableView.reloadData()
                }
                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                break
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        /// Section với index là 0 thì là section cho trending news
        /// Section với index là 1 thì là section cho latest news
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = HomeNewsSection(rawValue: section)
        
        switch homeSection {
        case .categories:
            return 1 /// Chỉ có 1 cái cell là list categories
        case .latestNews:
            return latestNews.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeSection = HomeNewsSection(rawValue: indexPath.section)
        switch homeSection {
        case .categories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
            
            /// Truyền categories lấy được từ API xuống table view cell để làm dataSource cho collection view hiển thị và xử lý callback action chọn vào 1 category lên đây để call API get list latest news
            cell.bindData(categories: categoriesString, onClickCategory: { indexPath in
                print("Click to category \(indexPath)")
                if indexPath.row == 0 {
                    print("ALL")
                    /// Get lại toàn bộ list news latest
                    self.getLatetestNews()
                } else {
                    /// Get lại  list news latest theo category id
                    let row = indexPath.row
                    
                    /// Do đã add thủ công 1 phần từ là "All" vào trong mảng items của collectionView nên cần trừ đi 1 để lấy đúng index của mảng categories lấy từ API về
                    let categorySelect = self.categories[row - 1]
                    if let categoryId = categorySelect.id {
                        self.getLatetestNews(categoryId: categoryId)
                    }
                }
                /// Call API get news theo catogory
            })
            
            return cell
        case .latestNews:
            /// Sử dụng custom view cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "LatestNewsTableViewCell", for: indexPath) as! LatestNewsTableViewCell
            let news = latestNews[indexPath.row]
            cell.bindData(news: news)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TAP vào cell ở vị trí thứ: \(indexPath.row + 1)")
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let homeSection = HomeNewsSection(rawValue: section)
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderTableViewCell") as! CustomHeaderTableViewCell
        
        switch homeSection {
//        case .trendingNews:
//            headerCell.bindData(title: "Trending") {
//                print("See all trending")
//            }
//            return headerCell
        case .categories:
            headerCell.bindData(title: "Latest") {
                print("See all Latest")
            }
            return headerCell
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let homeSection = HomeNewsSection(rawValue: section)
        switch homeSection {
//        case .trendingNews:
//            return 40
        case .categories:
            return 40
        default:
            return 0.1 // Những section nào mà k có Header thì cho về 0.1. Nếu để 0 thì header vẫn hiện.
        }
    }

    
}
