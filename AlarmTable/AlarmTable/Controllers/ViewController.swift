//
//  ViewController.swift
//  AlarmTable
//
//  Created by 김강현 on 2023/04/24.
//

import UIKit
import KakaoSDKUser

class ViewController: UIViewController, AlarmDelegate {
    
    func alarmDelegate(data: String, alert: Bool) {
        let nextId = alarmDataManager.lastId + 1
        alarmDataManager.addTimePickerData(data: data)
        alarmDataManager.lastId = nextId
        self.tableView.reloadData()
        alert == true ? self.view.makeToast("저장되었습니다.", duration: 3.0, position: .top) : print("alert이 전달되지 않음.")
        UserDefaults.standard.set(alarmDataManager.timePickerData, forKey: "savedAlarm")
        UserDefaults.standard.set(alarmDataManager.lastId, forKey: "lastId")
    }
    
    var alarmDataManager = DataManager()
    
    var isAlertOn = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let LoginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        LoginVC.modalPresentationStyle = .fullScreen
        present(LoginVC, animated: true)
        
        alarmDataManager.timePickerData = UserDefaults.standard.array(forKey: "savedAlarm") as? [String] ?? [] // 저장된 값 불러오기
        alarmDataManager.lastId = UserDefaults.standard.integer(forKey: "lastId") //저장된 값 불러오기
        
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
        
        for data in alarmDataManager.timePickerData {
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
    
    @IBAction func logoutButton(_ sender: UIButton) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                guard let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
                LoginVC.modalPresentationStyle = .fullScreen
                self.present(LoginVC, animated: true)
                
                
            }
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmDataManager.timePickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
        cell.AlarmTableViewCell.text = alarmDataManager.timePickerData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            alarmDataManager.timePickerData.remove(at: indexPath.row)
            UserDefaults.standard.set(alarmDataManager.timePickerData, forKey: "savedAlarm")
            UserDefaults.standard.set(alarmDataManager.lastId, forKey: "lastId")
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
    }
}

