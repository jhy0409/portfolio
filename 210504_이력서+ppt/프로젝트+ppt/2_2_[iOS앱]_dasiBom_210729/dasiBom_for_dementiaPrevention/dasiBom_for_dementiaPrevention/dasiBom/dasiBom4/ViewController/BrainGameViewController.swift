//
//  BrainGameViewController.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/02.
//

import UIKit
import Firebase

class BrainGameViewController: UIViewController {
    
    let db = Database.database().reference().child("users")
    
    @IBOutlet weak var questionLabel: UILabel!
    var answer: String? // 사용자 제출답안 전역변수
    
    lazy var btnArr: [UIButton] = []
    lazy var rainbowUIColorArr: [UIColor] = [ UIColor(hex: "#ea58aa"), UIColor(hex: "#f59acc"),
                                              UIColor(hex: "#f9c455"), UIColor(hex: "#7ce9dd"),
                                              UIColor(hex: "#15cc94"), UIColor(hex: "#a59ddd")]
    
    var user = Auth.auth().currentUser
    
    var tryNum: Int = 0
    var gameStartTime: Date?
    var gameEndTime: Date?
    var totalTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBtn4()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIButton(btnArr) // 오토 레이아웃
        submitUser(btnArr) // 버튼탭 할 때 동작
        makeLabelTxt() // 간단 문제 라벨 세팅, 정답버튼 내용 랜덤배치
    }
}

// MARK: - 파이어베이스 업로드를 위한 메소드
extension BrainGameViewController {
    // [ㅇ] 게임 시도회수 갱신 - 전역변수
    func updateTryNum(_ str: String) -> Bool {
        if str != answer {
            tryNum += 1
            return false
        } else {
            tryNum += 1
            return true
        }
    }
    
    // [ㅇ] 서버 업로드 - 게임결과
    func recordGameHistory(_ canUpdate: Bool) {
        if canUpdate == true {
            guard let user = user else { print("\n---> func recordGameHistory user is nil"); return }
            let uID = user.uid

            let timestamp: Int = Int(Date().timeIntervalSince1970.rounded()) // 등록일자
            let today: String = BrainGameViewController.makeDate_YYYYMMDD(Date()) // 오늘날짜
            gameEndTime = Date() // 게임 종료시간
            let soyoSigan = calcTotalTime(now: gameStartTime!, later: gameEndTime!) // 소요시간 계산
            let percent = 1.0/Double(tryNum)
            db.child("\(uID)").child("game").childByAutoId().setValue(["timestamp": timestamp, "today": today, "tryNum": tryNum, "totalTime": soyoSigan, "correctPercentage": percent])
            tryNum = 0 // 초기화
        }
    }
    
    // [ㅇ] 소요시간 계산
    func calcTotalTime(now: Date, later: Date) -> Int {
        let startTodouble = now.timeIntervalSince1970
        let endTodouble = later.timeIntervalSince1970
        
        return Int(endTodouble-startTodouble)
    }
    
    // [ㅇ] 서버등록 일자 생성
    static func makeDate_YYYYMMDD(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        let currentDateToString = formatter.string(from: date)
        return currentDateToString
    }

    // [ㅇ] 메소드 - 문제에 대한 답 연산 후 전역변수 answer에 값 업데이트
    func calcResult(_ n1: Int, _ n2: Int, _ n3: Int, _ oper1: String, _ oper2: String) -> String{
        var result1: Int
        switch oper2 { // 괄호로 묶인 두번째 항부터 연산
        case "+":
            result1 = n2 + n3
        case "-":
            result1 = n2 - n3
        default:
            result1 = n2 * n3
        }
        
        var result2: Int
        switch oper1 { // 두번째 항 계산이 끝난 뒤 전체연산
        case "+":
            result2 = n1 + result1
        case "-":
            result2 = n1 - result1
        default:
            result2 = n1 * result1
        }
        print("\n------> result is \(result2)")
        return "\(result2)"
    }
}

// MARK: - UI 및 오토레이아웃 관련 메소드
extension BrainGameViewController {
    // [ㅇ] 버튼 오토 레이아웃 및 버튼숫자 랜덤생성
    func setUIButton(_ btnArr: [UIButton]) {
        let itemSpacing: CGFloat = 18
        let margin: CGFloat = 40
        let fromTop: CGFloat = 200
        
        let width = (view.bounds.width - itemSpacing - (margin * 2)) / 2
        let tmpRange = 0...3
        for i in tmpRange {
            btnArr[i].backgroundColor = rainbowUIColorArr.randomElement()
            btnArr[i].layer.cornerRadius = 10
            btnArr[i].titleLabel?.font = UIFont.systemFont(ofSize: 55)
            switch i {
            case 0:
                btnArr[i].frame = CGRect(x: margin, y: fromTop, width: width, height: width)
                btnArr[i].setTitle("\(Int.random(in: 10...30))", for: .normal)
            case 1:
                btnArr[i].frame = CGRect(x: margin + width + itemSpacing, y: fromTop, width: width, height: width)
                btnArr[i].setTitle("\(Int.random(in: 10...30))", for: .normal)
            case 2:
                btnArr[i].frame = CGRect(x: margin, y: fromTop + width + itemSpacing, width: width, height: width)
                btnArr[i].setTitle("\(Int.random(in: 10...30))", for: .normal)
            default:
                btnArr[i].frame = CGRect(x: margin + width + itemSpacing, y: fromTop + width + itemSpacing, width: width, height: width)
                btnArr[i].setTitle("\(Int.random(in: 10...30))", for: .normal)
            }
            self.view.addSubview(btnArr[i])
        }
    }
    
    // [ㅇ] 문제라벨 생성 메소드 - 숫자세개와 연산자 2개를 랜덤으로 생성
    func makeLabelTxt() {
        let tmpN1 = Int.random(in: 1...10)
        let tmpN2 = Int.random(in: 1...10)
        let tmpN3 = Int.random(in: 1...10)
        
        let oper: [String] = ["+", "-", "*"]
        let oper1: String = oper.randomElement()!
        let oper2: String = oper.randomElement()!
        let tmpStr: String = "\(tmpN1) \(oper1) (\(tmpN2) \(oper2) \(tmpN3))"
        print("\n----> \(tmpStr)")
        questionLabel.text = "문제 : \(tmpStr)"
        answer = calcResult(tmpN1, tmpN2, tmpN3, oper1, oper2) // 연산결과를 전역변수에 저장
        btnArr.randomElement()?.setTitle(answer, for: .normal) // 버튼 중 하나를 정답으로 교체
        gameStartTime = Date() // 게임 시작시간
    }
    
    // [ㅇ] 뷰 로드시 버튼생성 및 버튼배열에 추가
    func makeBtn4() {
        let range = 0...3
        for _ in range {
            let btn = UIButton()
            btnArr.append(btn)
        }
    }
    
    // [ㅇ] 버튼배열을 받아와서 각 버튼 클릭시 연결할 동일한 함수를 연결 - buttonAction
    func submitUser(_ btnArr: [UIButton]) {
        for i in btnArr {
            i.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        }
    }
    
    // [ㅇ] 버튼클릭시 동작, uibutton에서 보내는 내용을 알림창으로 띄울 매개변수로 전달.
    @objc func buttonAction(_ sender: UIButton!) {
        guard let str = sender.titleLabel?.text else { return }
        print("Button tapped \(str)")
        showAlert(str, "알림")
        let canUpdate = updateTryNum(str)
        recordGameHistory(canUpdate)
    }
    
    // [ㅇ] 정답여부에 따른 알림창띄우기
    func showAlert(_ userResult: String, _ title: String?) {
        var msg = "" // 임시변수
        var tmpBool: Bool // 임시 bool값
        if userResult == answer { // 조건 : 유저가 클릭한 버튼의 내용(답)과 전역변수에서 계산한 식의 답이 같으면
            msg = "정답입니다."
            tmpBool = true
        } else {
            msg = "틀렸습니다."
            tmpBool = false
        }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        // [ㅇ] 코드분기 - 유저가 클릭한 버튼이 정답과 오답여부
        if tmpBool == false { // 오답일 때
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
        } else { // 정답일 때
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.setUIButton(self.btnArr) // 버튼내용 새로 갱신
                self.makeLabelTxt() // 정답버튼으로 갱신 - 4개버튼 중 랜덤
            }
            alert.addAction(ok)
        }
        present(alert, animated: true, completion: nil)
    }
}
