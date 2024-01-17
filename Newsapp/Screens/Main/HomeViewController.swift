//
//  HomeViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 27/08/2023.
//

import UIKit
import Alamofire
import MBProgressHUD



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var homeTableView: UITableView!
    
    private var customQueue = DispatchQueue(label: "test dispath queuer", attributes: .concurrent)
    
    private var dispathGroup = DispatchGroup()
    
    enum HomeNewsSection: Int {
        case trendingNews = 0
        case categories
        case latestNews
    }
    private var sections = [HomeNewsSection]()
    private var trendingNews = [NewsEntity]()
    private var latestNews = [NewsEntity]()
    private var categories = [CategoryEntity]()
    private var categoriesString = [String]()
    private var latestNewsCurrentPage = 1
    private var lastestNewsIsCanLoadMore = false
    private var pullRefresh = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Khởi tạo mảng sections
        sections = [.trendingNews, .categories, .latestNews]
        homeTableView.reloadData()
        
        /// Seting pull Refresh
        homeTableView.refreshControl = pullRefresh
        pullRefresh.addTarget(self, action: #selector(onHandleRefreshData), for: .valueChanged)
        
        callAPI()
        customQueue.async {
            print("Hello")
            
            /// Code đang chạy ở 1 thread không phải là MainThread
            /// Đẩy tác vụ trở lại mainThread để reload lại UI
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
    }
    @objc func onHandleRefreshData(_ sender: AnyObject) {
        refreshLatetestNews()
        // Code to refresh table view
     }
    private func callAPI() {
        print("viewDidLoad")
        showLoading(isShow: true)
        
        getTrendingNews()
        getLatetestNews()
        getCategories()
        dispathGroup.notify(queue: .main) {
            self.homeTableView.reloadData()
            self.showLoading(isShow: false)
        }
        
    }
    private func setupTableView() {
        homeTableView.dataSource = self // self chính instance  của HomeViewController
        
        homeTableView.delegate = self
        
        homeTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LatestNewsTableViewCell", bundle: nil)
        homeTableView.register(nib, forCellReuseIdentifier: "LatestNewsTableViewCell")
        
        let nib2 = UINib(nibName: "Demo2TableViewCell", bundle: nil)
        homeTableView.register(nib2, forCellReuseIdentifier: "Demo2TableViewCell")
        
        let trendingCell = UINib(nibName: "TrendingTableViewCell", bundle: nil)
        homeTableView.register(trendingCell, forCellReuseIdentifier: "TrendingTableViewCell")
//        CustomHeaderTableViewCell
        let customHeaderCell = UINib(nibName: "CustomHeaderTableViewCell", bundle: nil)
        homeTableView.register(customHeaderCell, forCellReuseIdentifier: "CustomHeaderTableViewCell")
        let categoriesCell = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
        homeTableView.register(categoriesCell, forCellReuseIdentifier: "CategoriesTableViewCell")
        
        /// Có thể đăng ký nhiều
    }
    private func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func getTrendingNews() {
        self.dispathGroup.enter()
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/posts",
                   method: .get,
                   parameters: [
                        "is_trending": 1,
                        "page": 1,
                        "pageSize": 20
                    ],
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken)"
                   ])
        .validate(statusCode: 200..<299)
        .responseDecodable(of: ArrayResponse<NewsEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let newsList = data.data {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.trendingNews = newsList
                        
//                        self.homeTableView.reloadData()
                        self.dispathGroup.leave()

                    }
                } else {
                    self.dispathGroup.leave()
                }
                break
            case .failure(let err):
                print(err.errorDescription as Any)
                self.dispathGroup.leave()
                break
            }
        }
    }
    
    private func getLatetestNews(categoryId: String? = nil) {
        dispathGroup.enter()
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("getLatetestNews reload data")
                        self.latestNews = newsList
//                        self.homeTableView.reloadData()
                        self.lastestNewsIsCanLoadMore = newsList.count == (data.pageSize ?? 40)
                        self.dispathGroup.leave()
                    }
                    
                } else {
                    self.dispathGroup.leave()
                }
                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                self.dispathGroup.leave()
                break
            }
        }
    }
    private func refreshLatetestNews(categoryId: String? = nil) {
        
        /// Set lại page = 1
        /// Set lai cờ isCanLoadMore = false
        
        latestNewsCurrentPage = 1
        lastestNewsIsCanLoadMore = false
        
        
        var param: [String: Any] = [
            "page": 1,
            "pageSize": 40,
        ]
        
        if let cateId = categoryId {
            param["category_id"] = "\(cateId)"
        }
        
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/posts",
                   method: .get,
                   parameters: param,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken)"
                   ])
        .validate(statusCode: 200..<299)
        .cURLDescription(calling: { cURL in
            print("DUCHV")
            print(cURL)
        })
        .responseDecodable(of: ArrayResponse<NewsEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let newsList = data.data {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("getLatetestNews reload data")
                        self.latestNews = newsList
                        self.homeTableView.reloadData()
                        
                        self.lastestNewsIsCanLoadMore = newsList.count == (data.pageSize ?? 40)
                        
                    }
                    
                }
                self.pullRefresh.endRefreshing()
                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                self.pullRefresh.endRefreshing()
                break
            }
        }
    }
    private func getLatetestNewsLoadMore(categoryId: String? = nil) {
        guard lastestNewsIsCanLoadMore else {
            print("Không thể loadmore được nữa")
            return
        }
        
        /// lastestNewsIsCanLoadMore: true
        
        lastestNewsIsCanLoadMore = false
        latestNewsCurrentPage += 1
            
        var param: [String: Any] = [
            "page": latestNewsCurrentPage,
            "pageSize": 40,
        ]
        
        if let cateId = categoryId {
            param["category_id"] = "\(cateId)"
        }
        
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/posts",
                   method: .get,
                   parameters: param,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken)"
                   ])
        .validate(statusCode: 200..<299)
        .cURLDescription(calling: { cURL in
            print("DUCHV")
            print(cURL)
        })
        .responseDecodable(of: ArrayResponse<NewsEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let newsList = data.data {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("getLatetestNews reload data")
                        self.latestNews.append(contentsOf: newsList)
                        self.homeTableView.reloadData()
                        
                        self.lastestNewsIsCanLoadMore = newsList.count == (data.pageSize ?? 40)
                    }
                }
                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                break
            }
        }
    }

    private func getCategories() {
        dispathGroup.enter()
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
                    self.homeTableView.reloadData()
                }
                self.dispathGroup.leave()
                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                self.dispathGroup.leave()
                break
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        AuthService.share.clearAll()

        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let loginNavigation = UINavigationController(rootViewController: loginVC)
            uwWindow.rootViewController = loginNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
    @IBAction func onAvatarUpdate(_ sender: Any) {

        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let avatarVC = storyboard.instantiateViewController(withIdentifier: "UpdateProfilesViewController")
            let avatarNavigation = UINavigationController(rootViewController: avatarVC)
            uwWindow.rootViewController = avatarNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
    
    func getKeyWindowC1() -> UIWindow? {
        let keyWindow = (UIApplication.shared.delegate as? AppDelegate)?.window
        return keyWindow
    }
    
    func getKeyWindowC2() -> UIWindow? {
        let keyWindow = UIApplication.shared
            .connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return keyWindow
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /// Section với index là 0 thì là section cho trending news
        /// Section với index là 1 thì là section cho latest news
        return sections.count
    }
    
    /// Chỉ đinh số lượng items trong 1 sections
    /// 1 tableview có thể có nhiều section
    /// Section cơ bản là 1 group các item giống nhau.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = HomeNewsSection(rawValue: section)
        
        switch homeSection {
        case .trendingNews:
            return trendingNews.count // return theo design
        case .categories:
            return 1 /// Chỉ có 1 cái cell là list categories
        case .latestNews:
            return latestNews.count
        default:
            return 0
        }
    }
    
    /// cellForRowAt
    /// Mn define ra 1 đối tượng của UITableViewCell để hiển thị lên data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeSection = HomeNewsSection(rawValue: indexPath.section)
        switch homeSection {
        case .trendingNews:
            /// Sử dụng custom view cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as! TrendingTableViewCell
            
            let news = trendingNews[indexPath.row]
            cell.bindData(news: news)
            
            return cell
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
        case .trendingNews:
            headerCell.bindData(title: "Trending") {
                print("See all trending")
                self.TreadingNewsPageViewController()
            }
            return headerCell
        case .categories:
            headerCell.bindData(title: "Latest") {
                self.gotoLatestNewsPageViewController()

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
        case .trendingNews:
            return 40
        case .categories:
            return 40
        default:
            return 0.1 // Những section nào mà k có Header thì cho về 0.1. Nếu để 0 thì header vẫn hiện.
        }
    }
    func gotoLatestNewsPageViewController() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let LatestNewsPageVC = storyboard.instantiateViewController(withIdentifier: "LatestNewsPageViewController")
            let LatestNewsPageNavigation = UINavigationController(rootViewController: LatestNewsPageVC)
            uwWindow.rootViewController = LatestNewsPageNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
    func TreadingNewsPageViewController() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let TreadingNewsPageVC = storyboard.instantiateViewController(withIdentifier: "TreadingNewsPageViewController")
            let TreadingNewsPageNavigation = UINavigationController(rootViewController: TreadingNewsPageVC)
            uwWindow.rootViewController = TreadingNewsPageNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay \(indexPath.row)")
        
        /// Chỉ check section cuối cùng là latest news để loadmore
        if indexPath.section == HomeNewsSection.latestNews.rawValue {
            if latestNews.count - 1 == indexPath.row {
                print("Call API Loadmore")
                self.getLatetestNewsLoadMore()
                // Cần 1 cờ để check xem còn có thể loadmore được nữa hay không?
            }
        }
    }
    @IBAction func GMSMapViewBtn(_ sender: Any) {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MapsVC = storyboard.instantiateViewController(withIdentifier: "GGMapsViewController")
            let GGMapsViewControllerNavigation = UINavigationController(rootViewController: MapsVC)
            uwWindow.rootViewController = GGMapsViewControllerNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
}


