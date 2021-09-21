//
//  SignUpViewController.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/01.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.layer.cornerRadius = 10
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        doSignUp()
    }
}

extension SignUpViewController {
    
    func showAlert(_ bool: Bool, message:String){
        // [ㅇ] 회원가입 실패
        if bool == false {
            let alert = UIAlertController(title: "회원가입 실패",message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
        }
        // [ㅇ] 회원가입 성공
        else {
            let alert = UIAlertController(title: "회원가입 성공",message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { [self] _ in
                self.updateUI()
                dismissSelf() // [ㅇ] 가입성공 확인버튼 누른 뒤 동작
            }))
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    
    // [ㅇ] 로그인성공, 로그인버튼 누른 뒤 텍스트필드 초기화
    func updateUI() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func doSignUp(){
        if emailTextField.text! == ""{
            showAlert(false, message: "이메일을 입력해주세요")
            return
        }
        
        if passwordTextField.text! == ""{
            showAlert(false, message: "비밀번호를 입력해주세요")
            return
        }
        
        signUp(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func signUp(email:String,password:String){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(false, message: "유효하지 않은 이메일 입니다")
                    case AuthErrorCode.emailAlreadyInUse:
                        
                        self.showAlert(false, message: "이미 가입한 회원 입니다")
                    case AuthErrorCode.weakPassword:
                        
                        self.showAlert(false, message: "비밀번호는 6자리 이상이여야해요")
                    default:
                        print(ErrorCode)
                    }
                }
                
            } else {
                print("회원가입 성공")
                // dump(user)
                self.showAlert(true, message: "회원가입이 완료되었습니다.")
            }
        })
    }
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}

