//
//  ProfileViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 07/09/2023.
//

import UIKit
import Kingfisher
import Alamofire

class ProfileViewController: UIViewController {
    @IBOutlet weak var bioLb: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPIProfile()
    }
    
    @IBAction func updateProfileAction(_ sender: Any) {
        pushUpdateProfileViewController()
    }
    
    func callAPIProfile() {
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/profile",
                   method: .get,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken )"
                   ])
        .validate(statusCode: 200..<299)
        .cURLDescription(calling: { cURL in
            print("DUCHV")
            print(cURL)
        })
        .responseDecodable(of: ObjectResponse<ProfileEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                print(data)

                self.bioLb.text = data.data?.profile?.bio

//                if let avatar = data.data?.profile?.avatar {
//                    self.avatarImage.kf.setImage(with: URL(string: avatar))
//                }

                break
            case .failure(let err):
                print(err.errorDescription ?? "")
                break
            }
        }
    }
    
    func pushUpdateProfileViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyboard.instantiateViewController(withIdentifier: "UpdateProfilesViewController") as! UpdateProfilesViewController
        
        registerViewController.updateProfileInformationCallbackCach1 = { [weak self] data in
//            guard let strongSelf = self else {
//                return
//            }
            
            self?.bioLb.text = data.bio
            
            if let avatar = data.avatar {
                self?.avatarImage.kf.setImage(with: URL(string: avatar))
            }
        }
        
        registerViewController.updateProfileInformationCallbackCach2 = { [weak self] in
            guard let self = self else {
                return
            }
            self.callAPIProfile()
        }
        
        navigationController?.pushViewController(registerViewController, animated: true )
    }
}
