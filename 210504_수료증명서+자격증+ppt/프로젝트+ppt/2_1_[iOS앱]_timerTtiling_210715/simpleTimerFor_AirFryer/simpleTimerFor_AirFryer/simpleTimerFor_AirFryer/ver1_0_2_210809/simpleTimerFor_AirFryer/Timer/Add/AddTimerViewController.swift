//
//  AddTimerViewController.swift
//  simpleTimerFor_AirFryer
//
//  Created by inooph on 2021/07/16.
//

import UIKit

class AddTimerViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var foodNameTxt: UITextField!
    @IBOutlet weak var ondoTxt: UITextField!
    @IBOutlet weak var hourTxt: UITextField!
    @IBOutlet weak var minTxt: UITextField!
    @IBOutlet weak var turnTimeTxt: UITextField!
    
    @IBOutlet weak var gogiButton: UIButton!
    @IBOutlet weak var snackButton: UIButton!
    @IBOutlet weak var ganpeyonButton: UIButton!
    @IBOutlet weak var breadButton: UIButton!
    @IBOutlet weak var chesoButton: UIButton!
    @IBOutlet weak var hesanmulButton: UIButton!
    @IBOutlet weak var etcFoodButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var foodBtnType: (() -> String)?
    var uiButton = [UIButton]()
    static let uiLabelColorArr = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.2), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0.2), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.2), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.2), #colorLiteral(red: 0.2196078449, green: 0.2030190556, blue: 0.8549019694, alpha: 0.2), #colorLiteral(red: 0.5, green: 0.007843137719, blue: 0.4200693323, alpha: 0.2)]
    var uiTxtFields = [UITextField]()
    let foodViewModel = FoodViewModel.shared
    var btnSenderTxt = ""
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        uiButton = [gogiButton, snackButton, ganpeyonButton, breadButton, chesoButton, hesanmulButton, etcFoodButton]
        tintBtn(uiButton)
        uiTxtFields = [foodNameTxt, ondoTxt, hourTxt, minTxt, turnTimeTxt ]
        
        addButton.backgroundColor = UIColor.systemBlue
        addButton.layer.cornerRadius = 15
        btnSenderTxt = "NONE" // 초기값설정
    }
    
    @IBAction func addButtonTap(_ sender: Any) {
        // [ㅇ] 기본값 세팅
        let ondo = ondoTxt.text == "" ? "0" : String(ondoTxt.text!) // 온도
        let turn = turnTimeTxt.text == "" ? "0" : String(turnTimeTxt.text!) // 뒤집는 횟수
        var hour = hourTxt.text == "" ? "0" : String(hourTxt.text!) // 시간
        var min = minTxt.text == "" ? "0" : String(minTxt.text!) // 분
        let foodName = foodNameTxt.text == "" ? "" : String(foodNameTxt.text!) // 음식이름
        
        // [ㅇ] 유효값 확인목록 튜플로 저장
        let (if1_hourNMinZero, if2_hourZero, if3_foodNameEmpty, if4_ondoZero, if5_minToH_T) =
            ((hour == "0" && min == "0"), (hour != "0" && Int(min)! > 60 ), foodName.isEmpty, ondo == "0", (hour == "0" && Int(min)! > 60 ))
        // [ㅇ] 유효값 검사 후 반환값이 true일 때만 아래코드 실행
        let tOrF = showAlert(if1_hourNMinZero, if2_hourZero, if3_foodNameEmpty, if4_ondoZero)
        if tOrF == true {
            // [ㅇ] 분으로 세팅 ex) 80분 -> 1h 20min, 조건 : 시간이 0이고 분이 60분 이상일 때
                if let minIf = Int(min), if5_minToH_T == true {
                let h = minIf / 60 // 60으로 나눈 몫
                let m = minIf % 60 // 60으로 나눈 나머지
                hour = String(h); min = String(m)
            }
            
            let foodType: String = btnSenderTxt == "NONE" ? "기타" : btnSenderTxt
            let food: Food = FoodManager.shared.createFood(ondo: Int(ondo)!, hour: Int(hour)!, min: Int(min)!, turn: Int(turn)!, foodType: foodType, isTimerOn: false, foodName: foodName)
            foodViewModel.addFood(food) // 음식 배열에 추가
            txtField_makeEmpty(txtFields: uiTxtFields) // 문자입력 창 초기화
            btnSenderTxt = "NONE"
            showAlert("타이머 추가 완료")
        }
    }
}

extension AddTimerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 다른곳 터치시 키보드 내리기
        self.foodNameTxt.resignFirstResponder()
        self.ondoTxt.resignFirstResponder()
        self.hourTxt.resignFirstResponder()
        self.minTxt.resignFirstResponder()
        self.turnTimeTxt.resignFirstResponder()
    }
    
    // MARK: - [ㅇ] 각 버튼 클릭시 음식분류 내용 전달
    @IBAction func gogiBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    @IBAction func snackBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    @IBAction func ganpeyonBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    @IBAction func breadBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    @IBAction func chesoBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    @IBAction func hesanmulBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    @IBAction func etcFoodBtn_Clicked(_ sender: Any) {
        guard let str = sender as? UIButton else { return }
        btnSenderTxt = str.titleLabel?.text ?? "NONE"
    }
    
    func tintBtn(_ uiBtn: [UIButton]) { // 음식유형 버튼 초기화
        var i: Int = 0
        for item in uiBtn {
            item.backgroundColor = AddTimerViewController.uiLabelColorArr[i]
            item.layer.cornerRadius = 5
            i += 1
        }
    }
    
    func txtField_makeEmpty(txtFields: [UITextField]) { // 글자입력칸 초기화
        for item in txtFields {
            item.text = ""
        }
    }
}

extension AddTimerViewController {
    // MARK: - [ㅇ] 유효성 검사 후 경고창 실행
    func showAlert(_ if1_hourNMinZero: Bool, _ if2_hourZero: Bool, _ if3_foodNameEmpty: Bool, _ if4_ondoZero: Bool) -> Bool {
        if (if1_hourNMinZero == true || if2_hourZero == true || if3_foodNameEmpty == true || if4_ondoZero == true ) {
            var str = String()
            if if1_hourNMinZero == true { str.append("- 시간, 분이 둘 다 0일 수 없습니다.\n") }
            if if2_hourZero == true { str.append("- 분으로 설정시 시간 값을 비우십시오.\n") }
            if if3_foodNameEmpty == true { str.append("- 음식이름은 필수항목입니다.\n") }
            if if4_ondoZero == true { str.append("- 온도를 0 이상의 값으로 설정하십시오.\n") }
            
            let alertController = UIAlertController(title: "확인", message: str, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else { return true }
    }
    
    // MARK: - [ㅇ] 단순 알림창
    func showAlert(_ strMsg: String) {
        let alertController = UIAlertController(title: "확인", message: strMsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
