//
//  ViewController.swift
//  AlarmTable
//
//  Created by 김강현 on 2023/04/24.
//

import UIKit

class ViewController: UIViewController, AlarmDelegate {
    func alarmDelegate(data: String) {
        timePickerData.append(data)
        self.tableView.reloadData()
    }
    
    
    var timePickerData: [String] = []
    
    var isAlertOn = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        let currentTime = formatter.string(from: Date())
        
        if isAlertOn {
            return
        }
        
        for data in timePickerData {
            if data == currentTime {
                self.isAlertOn = true
                
                Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.timerOn), userInfo: nil, repeats: false)
                
                let alert = UIAlertController(title: "알림", message: "설정된 시간입니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default) {UIAlertAction in})
                self.present(alert, animated:true, completion: nil)
            }
        }
        
    }
    
    @objc func timerOn() {
        isAlertOn = false
    }
    
    @IBAction func moveVCButton(_ sender: UIBarButtonItem) {
        guard let addAlarmVC = storyboard?.instantiateViewController(withIdentifier: "AlarmEditViewController") as? AlarmEditViewController else {return}
        addAlarmVC.delegate = self
        self.navigationController?.pushViewController(addAlarmVC, animated: true)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timePickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
        cell.AlarmTableViewCell.text = timePickerData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

