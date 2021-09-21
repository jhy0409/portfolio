//
//  ViewResultController.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/04.
//

import UIKit
import Firebase

//Todo
//[ㅇ] 결과조회 탭 - 검사결과, 두뇌훈련게임
//[ㅇ] 실시간 서버 데이터 연동
class ViewResultController: UIViewController {
    var currentUser: User?
    var uID: String?
    var dbForGame: DatabaseReference?
    var dbForTest: DatabaseReference?
    
    var getUserGameInfoArr: [userGameResult] = []
    var getUserTestInfoArr: [userTestResult] = []
    
    @IBOutlet weak var toptableVIew: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{
                self.currentUser = user // 사용자가 있으면 전역변수로 할당
                self.loadDataFromFirebase() // 서버에서 데이터 받아오기
            } else {
                self.currentUser = nil
            }
        }
        checkUserNil()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toptableVIew.tableFooterView = UIView(frame: .zero)
        toptableVIew.register(UINib(nibName: "ViewResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewResultTableViewCell")
        bottomTableView.tableFooterView = UIView(frame: .zero)
        bottomTableView.register(UINib(nibName: "ViewResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewResultTableViewCell")
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil{
                self.currentUser = user // 사용자가 있으면 전역변수로 할당
                self.loadDataFromFirebase() // 서버에서 데이터 받아오기
            } else {
                self.currentUser = nil
            }
        }
        checkUserNil()
    }
    
    func checkUserNil() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.currentUser == nil {
                self.showAlert("알림", "로그인 후 이력을 조회할 수 있습니다.")
            }
        }
    }
    
    func loadDataFromFirebase() {
        uID = currentUser?.uid
        if uID != nil {
            print("\n\n------------> ViewResultController uID : \(uID)")
            dbForGame = Database.database().reference().child("users").child("\(uID!)").child("game")
            dbForTest = Database.database().reference().child("users").child("\(uID!)").child("selfTest")
            
            // [ㅇ] 게임이력을 받아 옴
            dbForGame?.observeSingleEvent(of: .value) { (snapshot) in
                guard let gameHistory = snapshot.value as? [String: Any] else { print("\n\n\n -----> error dbForGame"); self.getUserGameInfoArr = [] ; return }
                let data = try! JSONSerialization.data(withJSONObject: Array(gameHistory.values), options: [])
                let decoder = JSONDecoder()
                let gameTmp = try! decoder.decode([userGameResult].self, from: data)
                self.getUserGameInfoArr = gameTmp.sorted(by: { (term1, term2) in
                    return term1.timestamp < term2.timestamp
                })
            }
            
            // [ㅇ] 자가진단 이력을 받아 옴
            dbForTest?.observeSingleEvent(of: .value) { (snapshot) in
                guard let testHistory = snapshot.value as? [String: Any] else { print("\n\n\n -----> error dbForTest"); self.getUserTestInfoArr = []; return }
                let data = try! JSONSerialization.data(withJSONObject: Array(testHistory.values), options: [])
                let decoder = JSONDecoder()
                let testTmp = try! decoder.decode([userTestResult].self, from: data)
                self.getUserTestInfoArr = testTmp.sorted(by: { (term1, term2) in
                    return term1.timestamp < term2.timestamp
                })
            }
            self.toptableVIew.reloadData()
            self.bottomTableView.reloadData()
        }
        toptableVIew.estimatedRowHeight = 60.0
        toptableVIew.dataSource = self
        toptableVIew.delegate = self
        
        bottomTableView.estimatedRowHeight = 60.0
        bottomTableView.dataSource = self
        bottomTableView.delegate = self
    }
}

extension ViewResultController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount: Int
        if tableView == toptableVIew {
            rowCount =  getUserGameInfoArr.count
            return rowCount
        } else {
            rowCount =  getUserTestInfoArr.count
            return rowCount
        }
    }
    
    func showAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 셀에 데이터 세팅 (getUserGameInfoArr, getUserTestInfoArr)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewResultTableViewCell") as! ViewResultTableViewCell
        var contentStr: String
        if tableView == toptableVIew {
            contentStr = getUserGameInfoArr[indexPath.row].getAllString()
            cell.setResult(contentStr)
        }
        
        if tableView == bottomTableView {
            contentStr = getUserTestInfoArr[indexPath.row].getAllString()
            cell.setResult(contentStr)
        }
        return cell
    }
    
    //MARK: - For Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 50.0))
        
        view.backgroundColor = .systemBlue
        let titleLabel = UILabel(frame: CGRect(x: 15.0, y: 0, width: view.frame.size.width, height: 50.0))
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        if tableView == toptableVIew { titleLabel.text = "게임이력" }
        if tableView == bottomTableView { titleLabel.text = "자가진단 내역" }
        
        view.addSubview(titleLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}

extension ViewResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
