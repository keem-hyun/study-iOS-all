//
//  ViewController.swift
//  AlarmTable
//
//  Created by 김강현 on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    var timePickerData: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func moveVCButton(_ sender: UIBarButtonItem) {
        guard let addAlarmVC = storyboard?.instantiateViewController(withIdentifier: "AlarmEditViewController") as? AlarmEditViewController else {return}
        addAlarmVC.delegate = self
        self.navigationController?.pushViewController(addAlarmVC, animated: true)
    }
}

extension ViewController: AlarmDelegate {
    func alarmDelegate(data: String) {
        timePickerData.append(data)
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
}

