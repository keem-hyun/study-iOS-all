//
//  ViewController.swift
//  AlarmClock
//
//  Created by 김강현 on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var alarmText: UILabel!
    
    var isAlertOn = false
    
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentTime = formatter.string(from: Date())
        print("currentTime : \(currentTime)")
        
        if isAlertOn {
            return
        }
        
        guard let selectedDate = selectedDate else {return}
        
        if currentTime == selectedDate {
            self.isAlertOn = true
            
            Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.timerOn), userInfo: nil, repeats: false)
            
            let alert = UIAlertController(title: "알림", message: "설정된 시간입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default) {UIAlertAction in})
            self.present(alert, animated:true, completion: nil)
        }
        
    }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        alarmText.text = formatter.string(from: sender.date)
        selectedDate = formatter.string(from: sender.date)
        print("selectedDate: \(selectedDate!)")
        
    }
    
    @objc func timerOn() {
        isAlertOn = false
    }
}


