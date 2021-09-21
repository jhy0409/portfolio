//
//  ViewController.swift
//  dasiBom4
//
//  Created by inooph on 2021/07/30.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwTxtFIeld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var logOutBtn_topConstant: NSLayoutConstraint!
    @IBOutlet weak var signUpBtn_topConstant: NSLayoutConstraint!
    lazy var oldValue: CGFloat = 20
    
    lazy var btnArr: [UIButton] = [loginBtn, logOutBtn, signUpBtn]
    static var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutBtn.isHidden = true
        makeBtnBorder(btnArr, nil)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                HomeViewController.currentUser = user // 유저가 있으면 전역변수로
                print("\n\n------> addStateDidChangeListener [user] :  \(HomeViewController.currentUser!.uid)")
                self.updateUI(user)
            } else {
                HomeViewController.currentUser = nil
                self.updateUI(user)
            }
        }
    }
    
    @IBAction func loginBtnTouched(_ sender: Any) {
        self.signIn()
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        signOut()
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: pwTxtFIeld.text!) { (user, error) in
            if user != nil  {
                print("login success")
                guard let tmpUser = Auth.auth().currentUser else { return }
                self.updateUI(tmpUser)
            } else {
                print("login fail")
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        let user = Auth.auth().currentUser
        updateUI(user)
    }
    
    // MARK: - UI관련
    func updateUI(_ user: User?) {
        if let user = user {// 로그인 상태
            logoImgView.isHidden = false
            emailTxtField.isHidden = true
            pwTxtFIeld.isHidden = true
            emailTxtField.text = ""
            pwTxtFIeld.text = ""
            loginBtn.isHidden = true
            logOutBtn.isHidden = false
            signUpBtn.isHidden = true
            
            view.backgroundColor = .systemBlue
            makeBtnBorder(btnArr, user)
            logOutBtn_topConstant.constant = 70
            signUpBtn_topConstant.constant = logOutBtn_topConstant.constant + 20
            
        } else { //미로그인 상태
            logoImgView.isHidden = true
            emailTxtField.isHidden = false
            pwTxtFIeld.isHidden = false
            logOutBtn.isHidden = true
            loginBtn.isHidden = false
            signUpBtn.isHidden = false
            
            view.backgroundColor = .white
            signUpBtn_topConstant.constant = oldValue
            makeBtnBorder(btnArr, nil)
        }
    }
    
    // [ㅇ] 현재사용자 유무에 따른 버튼 UI업데이트 (로그인, 로그아웃, 회원가입)
    func makeBtnBorder(_ btnArr: [UIButton], _ user: User?) {
        let range = 0...btnArr.count - 1
        if user == nil {
            for i in range { // 미로그인 = 파란색
                btnArr[i].layer.borderColor = UIColor.systemBlue.cgColor
                btnArr[i].layer.borderWidth = 2
                btnArr[i].layer.cornerRadius = btnArr[i].frame.height / 2
                btnArr[i].setTitleColor(.systemBlue, for: .normal)
            }
        } else {
            for i in range { // 로그인 = 흰색
                btnArr[i].layer.borderColor = UIColor.white.cgColor
                btnArr[i].layer.borderWidth = 2
                btnArr[i].layer.cornerRadius = btnArr[i].frame.height / 2
                btnArr[i].setTitleColor(.white, for: .normal)
            }
        }
    }
    
    // MARK: - 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.emailTxtField.resignFirstResponder()
        self.pwTxtFIeld.resignFirstResponder()
    }
}




