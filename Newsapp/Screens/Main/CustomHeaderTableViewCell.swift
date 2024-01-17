//
//  CustomHeaderTableViewCell.swift
//  Newsapp
//
//  Created by LinhMAC on 29/08/2023.
//

import UIKit

class CustomHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var LastedNewLB: UILabel!
    @IBOutlet weak var onSeeAllButton: UIButton!
    private var seeAllCallBack: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSeeAllButton(_ sender: Any) {
        seeAllCallBack?()
    }
    func bindData(title : String, seeAllCallBack: (()-> Void)?) {
        self.seeAllCallBack = seeAllCallBack
        self.LastedNewLB.text = title
//        gotoLatestNewsPageViewController()
        
    }
//    func gotoLatestNewsPageViewController() {
//        let storybroad = UIStoryboard(name: "Main", bundle: nil)
//        let LatestNewsPageVC = storybroad.instantiateViewController(withIdentifier: "LatestNewsPageViewController")
//        let LatestNewsPageNavigation = UINavigationController(rootViewController: LatestNewsPageVC)
//        window?.rootViewController = LatestNewsPageVC
//        window!.makeKeyAndVisible()
//    }
}
