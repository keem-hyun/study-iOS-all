//
//  AlarmEditViewController.swift
//  AlarmTable
//
//  Created by 김강현 on 2023/04/24.
//

import UIKit
import Toast_Swift

protocol AlarmDelegate: AnyObject {
    func alarmDelegate(data: String, alert: Bool)
}

class AlarmEditViewController: UIViewController {
    
    @IBOutlet weak var dismissLabel: UILabel!
    weak var delegate: AlarmDelegate?
    var alarmData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissClicked))
        dismissLabel.addGestureRecognizer(dismissTapGesture)
        dismissLabel.isUserInteractionEnabled = true
        
        
    }
    
    @objc func dismissClicked(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        guard let alarmData = alarmData else { return }
        self.delegate?.alarmDelegate(data: alarmData, alert: true)
        print("저장버튼: \(alarmData)")
        print("delegate: \(delegate!)")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func timePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        alarmData = formatter.string(from: sender.date)
        print("alarmData: \(alarmData!)")
        
    }
}
