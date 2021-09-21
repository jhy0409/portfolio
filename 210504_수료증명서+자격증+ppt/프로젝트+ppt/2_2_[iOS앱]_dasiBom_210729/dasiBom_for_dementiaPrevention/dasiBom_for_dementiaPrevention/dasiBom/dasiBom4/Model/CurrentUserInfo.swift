//
//  CurrentUserInfo.swift
//  dasiBom4
//
//  Created by inooph on 2021/08/04.
//

import UIKit

// MARK: - for game 
struct userGameResult: Codable {
    let correctPercentage: Double
    let timestamp: Int
    let today: String
    let totalTime: Int
    let tryNum: Int
    
    func getAllString() -> String {
        let DateFormatter = DateFormatter()
        DateFormatter.dateFormat = "yyyy.M.d - a h시 m분 s초"
        DateFormatter.locale = Locale(identifier:"ko_KR")
        
        let date = "\(DateFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
        var tmpStr = ""
        tmpStr += "게임일시 : \(date)\n"
        tmpStr += "시도횟수 : \(tryNum)\n"
        tmpStr += "소요시간 : \(totalTime)\n"
        tmpStr += "정답확률 : \(Int(correctPercentage * 100))%"
        return tmpStr
    }
    
}

// MARK: - for test
struct userTestResult: Codable {
    let resultScore: Int
    let riskType: String
    let timestamp: Int
    let today: String
    
    func getAllString() -> String {
        var tmpStr = ""
        
        let DateFormatter = DateFormatter()
        DateFormatter.dateFormat = "yyyy.M.d - a h시 m분 s초"
        DateFormatter.locale = Locale(identifier:"ko_KR")
        
        let date = "\(DateFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
        
        tmpStr += "검사일자 : \(date)\n"
        tmpStr += "검사결과 : \(resultScore)\n"
        tmpStr += "위험여부 : \(riskType)"
        
        return tmpStr
    }
}
