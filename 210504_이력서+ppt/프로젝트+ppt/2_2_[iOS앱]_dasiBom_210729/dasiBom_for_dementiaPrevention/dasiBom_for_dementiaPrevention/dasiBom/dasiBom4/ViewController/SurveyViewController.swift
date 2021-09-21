//
//  SurveyViewController.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/01.
//

import UIKit
import Firebase
/*
 Todo
 
 [ㅇ] 검사 제출버튼 클릭 시 파이어베이스 연동
    - [ㅇ] 예외처리 : 서버와 연동여부
        - 함수이름 : submitBtn_Tapped
        - 동작    : 미로그인 시 알림창만 뜸
 */
class SurveyViewController: UIViewController {
    let viewModel = QuestionViewModel.shared
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    let db = Database.database().reference().child("users")
    var user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        submitBtn.layer.cornerRadius = 10
    }
    
    // MARK: - 검사결과 서버 제출
    @IBAction func submitBtn_Tapped(_ sender: Any) {
        showAlert("검사결과", checkTrue())
        
        guard let user = user, checkTrue().0 == true else { return } // 서버와 연동 - 로그인된 사용자가 있고, 누락항목이 없을 떄
        let uID = user.uid
        let timestamp: Int = Int(Date().timeIntervalSince1970.rounded()) // 등록일자
        
        let today = BrainGameViewController.makeDate_YYYYMMDD(Date())
        let riskType: String =  checkTrue().1 <= 5 ? "정상" : "위험"
        let resultScore: Int =  checkTrue().1
        db.child("\(uID)").child("selfTest").childByAutoId().setValue(["timestamp": timestamp,"today": today, "resultScore": resultScore, "riskType": riskType])
    }
    
    func checkTrue() -> (Bool, Int) {
        let tmpRange = 0...13 // 자가진단 문항 개수
        let queArr = viewModel.getQueArr()
        var totalSum: Int = 0 // 검사점수 합계 저장용 임시변수
        
        for i in tmpRange {
            guard let tmpScore = queArr[i].score, let tmpChecked = queArr[i].checked
            else {
                showAlert("알림창", "누락된 항목이 있습니다.")
                return (false, 0)
            }
            totalSum += queArr[i].score! // cell에서 체크시 점수를 주므로 강제추출 가능
        }
        return (true, totalSum)
    }
    
    // MARK: - 알림창 메소드 showAlert
    func showAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String, _ msg: (Bool, Int)) {
        guard msg.0 == true else { return } // [Survey]의 체크여부, 해당항목에 점수가 없을 시 return

        var tmpStr = "당신의 검사결과는 \(msg.1)점 입니다.\n\n"
        if msg.1 <= 5 {
            tmpStr.append("1~5점 운동과 외부 사회 활동을 유지하시고 \n치매예방 수칙 3·3·3을 잘 실천하셔서 치매를 에방하세요.")
        } else {
            tmpStr.append("6~14점 가까운 보건소나 치매안심센터를 방문하셔서 더 정확한 치매검진을 받아보시기 바랍니다")
        }

        let alert = UIAlertController(title: title, message: tmpStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - 테이블뷰 프로토콜 준수
extension SurveyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? QuestionTableViewCell else {
            return UITableViewCell()
        }
        let survey = viewModel.questionArr[indexPath.row]
        cell.update(info: survey, index: indexPath.row)
        return cell
    }
}
