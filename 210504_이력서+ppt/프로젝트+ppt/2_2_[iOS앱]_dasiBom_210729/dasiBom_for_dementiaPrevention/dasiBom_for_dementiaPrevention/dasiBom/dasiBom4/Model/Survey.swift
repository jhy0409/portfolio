//
//  File.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/01.
//

import UIKit

struct Survey {
    let questionTxt: String
    var score: Int?
    var checked: Bool?
}

class QuestionViewModel {
    static let shared: QuestionViewModel = QuestionViewModel()
    var questionArr: [Survey] = [
        Survey(questionTxt: "1. 자신의 기억력에 문제가 있다고 생각하십니까?", score: nil, checked: false),
        Survey(questionTxt: "2. 자신의 기억력이 10년 전보다 나빠졌다고 생각하십니까?", score: nil, checked: false),
        Survey(questionTxt: "3. 자신의 기억력이 같은 또래의 다른 사람들에 비해 나쁘다고 생각하십니까?", score: nil, checked: false),
        Survey(questionTxt: "4. 기억력 저하로 인해 일상생활에 불편을 느끼십니까?", score: nil, checked: false),
        Survey(questionTxt: "5. 최근에 일어난 일을 기억하는 것이 어렵습니까?", score: nil, checked: false),
        
        Survey(questionTxt: "6. 며칠 전에 나눈 대화 내용을 기억하기 어렵습니까?", score: nil, checked: false),
        Survey(questionTxt: "7. 며칠 전에 한 약속을 기억하기 어렵습니까?", score: nil, checked: false),
        Survey(questionTxt: "8. 친한 사람의 이름을 기억하기 어렵습니까?", score: nil, checked: false),
        Survey(questionTxt: "9. 물건 둔 곳을 기억하기 어렵습니까?", score: nil, checked: false),
        Survey(questionTxt: "10. 이전에 비해 물건을 자주 잃어버립니까?", score: nil, checked: false),
        
        Survey(questionTxt: "11. 집 근처에서 길을 잃은 적이 있습니까?", score: nil, checked: false),
        Survey(questionTxt: "12. 가게에서 2-3가지 물건을 사려고 할 때 물건이름을 기억하기 어렵습니까?", score: nil, checked: false),
        Survey(questionTxt: "13. 가스불이나 전기불 끄는 것을 기억하기 어렵습니까?", score: nil, checked: false),
        Survey(questionTxt: "14. 자주 사용하는 전화번호(자신 혹은 자녀의 집)를 기억하기 어렵습니까?", score: nil, checked: false)
    ]
    
    func getQueArr() -> [Survey] {
        return questionArr
    }
    
    func setQueArr(_ tmpQue: [Survey]) {
        self.questionArr = tmpQue
    }
    
    func updateSurvey(_ index: Int, _ score: Int, _ checked: Bool) {
        self.questionArr[index].checked = checked
        self.questionArr[index].score = score
    }
}
