//
//  LoginViewController.swift
//  AlarmTable
//
//  Created by 김강현 on 2023/05/06.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class LoginViewController: UIViewController {
    
    @IBOutlet weak var duckImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        duckImageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapImageView() {
        UIView.animate(withDuration: 0.25) {
            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.duckImageView.transform = scale
        } completion: { finished in
            UIView.animate(withDuration: 0.25) {
                self.duckImageView.transform = .identity
            }
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        print("로그인이 필요합니다.")
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.dismiss(animated: true)
                }
            }
        }
        else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    self.dismiss(animated: true)
                    
                    //do something
                    _ = oauthToken
                }
            }
        }
        
    }
}


