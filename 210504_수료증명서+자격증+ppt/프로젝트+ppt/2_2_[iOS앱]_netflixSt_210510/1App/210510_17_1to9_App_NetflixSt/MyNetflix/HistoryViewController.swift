//
//  HistoryViewController.swift
//  MyNetflix
//
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    
    let db = Database.database().reference().child("searchHistory")
    var searchTerms: [SearchTerm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let searchHistory = snapshot.value as? [String: Any] else { return }
//            [String: [String: Any]
            let data = try! JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
            
            let decoder = JSONDecoder()
            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
            self.searchTerms = searchTerms.sorted(by: { (term1, term2) in
                return term1.timestamp > term2.timestamp
            })
            
            // s s s s s
            self.TableView.reloadData()
            print("\n---> snapshot: \(data)+ \(searchTerms)++")
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    // 몇개, 어떻게 보여줄지
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        cell.searchTerm.text = searchTerms[indexPath.row].term
        return cell
    }
}

class HistoryCell: UITableViewCell {
    @IBOutlet weak var searchTerm: UILabel!
}


struct SearchTerm: Codable {
    let term: String
    let timestamp: TimeInterval
}
