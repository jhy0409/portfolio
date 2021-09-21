//
//  QuestionTableViewCell.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/01.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    let viewModel = QuestionViewModel.shared
    lazy var queArr = viewModel.getQueArr()
    var tmpIndex: Int?
    
    func update(info: Survey, index: Int) {
        questionLabel.text = info.questionTxt
        tmpIndex = index
    }
    
    @IBAction func yesBtnTapped(_ sender: Any) {
        yesBtn.isSelected = true
        noBtn.isSelected = false
        
        var survey = queArr[tmpIndex!]
        survey.score = 1
        survey.checked = true
        
        viewModel.updateSurvey(tmpIndex!, 1, true)
        print("\n------> \(survey.questionTxt) - \(survey.score!) & - \(survey.checked!)")
    }
    
    @IBAction func noBtnTapped(_ sender: Any) {
        noBtn.isSelected = true
        yesBtn.isSelected = false
        
        var survey = queArr[tmpIndex!]
        survey.score = 0
        survey.checked = true
        
        viewModel.updateSurvey(tmpIndex!, 0, true)
        print("\n------> \(survey.questionTxt) - \(survey.score!) & - \(survey.checked!)")
    }
}
