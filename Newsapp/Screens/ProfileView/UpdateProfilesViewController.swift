//
//  UpdateProfilesViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 07/09/2023.
//

import UIKit
import Alamofire
import MBProgressHUD

struct UpdateProfileResponse {
    var bio: String
    var avatar: String?
    var gender: String
}

class UpdateProfilesViewController: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    private var imagePicker = UIImagePickerController()

    /**
     Cách 1: Truyền data sau khi update xong ở màn Update về lại màn profile rồi gán lại data cho biến và cho outlet
        - Ưu điểm: Không phải call lại API
        - Nhược: Phải truyền data và update đủ các case có thể xảy ra.
     
     Cách 2: Call back lại và call lại API get profile ở màn hình Profile
        - Ưu điểm: Tự động reload thông tin mới nhất thông qua API
        - Nhược: Phải call lại API
     */
    var updateProfileInformationCallbackCach2: (() -> Void)?
    
    var updateProfileInformationCallbackCach1: ((UpdateProfileResponse) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAvatarTapGesture()
        title = "Update profile"
        
        // Do any additional setup after loading the view.
    }

    @objc func avatarhandleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("asd")
        self.showAlert()
    }
    @IBAction func UpdateProfilesViewController(_ sender: Any) {
        callAPIUpdateProfileInformation(gender: "male", bio: "Hello from news app")
    }
}
extension UpdateProfilesViewController {
    private func setupAvatarImage() {
        isAvatarTapGesture()
        avatarImage.layer.cornerRadius = 150/2
        avatarImage.clipsToBounds = true
    }
    private func isAvatarTapGesture() {
        let AvatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.avatarhandleTap(_:)))
        avatarImage.isUserInteractionEnabled = true
        
        avatarImage.addGestureRecognizer(AvatarTapGesture)
    }
}
extension UpdateProfilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //    //This is the tap gesture added on my UIImageView.
    //    @IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
    //        //call Alert function
    //        self.showAlert()
    //    }
    
    //Show alert to selected the media source type.
    private func showAlert() {
        
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            self?.avatarImage.image = image
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                print("update image")
//                callAPIUpdateAvatar(imageData: imageData)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
extension UpdateProfilesViewController {
    private func callAPIUpdateProfileInformation(gender: String, bio: String) {
        let url = URL(string: "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/profile")!
        
        let param = [
            "gender": gender,
            "bio": bio
        ]
        
        AF.request(url,
                   method: .put,
                   parameters: param,
                   headers: [
                    "Authorization": "Bearer \(AuthService.share.accessToken)"
                   ])
        .validate(statusCode: 200..<299)
        .cURLDescription(calling: { cURL in
            print("DUCHV")
            print(cURL)
        })
        .responseData { response in
            switch response.result {
            case .success(let data):
                print(response.result)
                /// Back trở về màn hình Profile và reload lại data
            
                let result = UpdateProfileResponse(bio: bio, gender: gender)
//                self.updateProfileInformationCallbackCach1?(result)
                // trở về màn hình trước
                self.updateProfileInformationCallbackCach2?()
            
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                print(error.errorDescription)
                /// Show alert lỗi
            }
            
        }
    }
}
extension UpdateProfilesViewController {
    private func callAPIUpdateAvatar(imageData: Data) {
        let url = URL(string: "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/users/avatar")!
        
        let parameters: [String: String] = ["name": "duchv", "age": "10"]
        
        AF.upload(multipartFormData: { formData in
            formData.append(imageData,
                            withName: "avatar",
                            fileName: "avatar_\(Date().timeIntervalSince1970).jpg",
                            mimeType: "image/jpg")
            
            parameters.forEach { key, value in
                formData.append(Data(value.utf8), withName: key)
            }
        }, to: url, headers: [
             "Authorization": "Bearer \(AuthService.share.accessToken)"
        ])
        .cURLDescription { description in
            print(description)
        }
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success(let data):
                print(response.result)
                /// Back trở về màn hình Profile và reload lại data
            case .failure(let error):
                print(error.errorDescription)
                /// Show alert lỗi
            }
            
        }
    }
}



