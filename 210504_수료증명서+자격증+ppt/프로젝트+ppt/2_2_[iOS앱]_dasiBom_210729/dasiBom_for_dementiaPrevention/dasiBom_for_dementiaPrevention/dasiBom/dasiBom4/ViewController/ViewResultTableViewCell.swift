//
//  ViewResultTableViewCell.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/04.
//

import UIKit

class ViewResultTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - set Results (게임 & 자가진단 이력)
    func setResult(_ contentStr: String) {
        self.lbName.text = contentStr
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
