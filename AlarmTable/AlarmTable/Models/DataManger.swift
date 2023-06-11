//
//  DataManger.swift
//  AlarmTable
//
//  Created by 김강현 on 2023/05/13.
//

import UIKit

class DataManager {
    var timePickerData: [String] = []
    var lastId = 0
    
    func addTimePickerData(data: String) {
        timePickerData.append(data)
    }
    
    func getTimePickerData() -> [String] {
        return timePickerData
    }
    
}
