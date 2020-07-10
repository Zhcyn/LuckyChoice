//
//  OptionViewController.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class OptionViewController: ProjectBaseViewController {
    var dataAry: NSMutableArray = NSMutableArray.init()
    private let footBtn: UIView = {
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 180))
        let btn = UIButton.createButton("Adding Options", .red, 20, target: self, selector: #selector(addCell))
        btn.frame = CGRect(x: 15, y: 10, width: screenWidth - 30, height: 44)
        btn.setBackgroundImage(UIImage.init(named: "edit_bg"), for: .normal)
        footView.addSubview(btn)
        return footView
    }()
    private lazy var tableView = { () -> UITableView in
        let tab = UITableView.init(frame: CGRect(x: 0, y: 50 + statusHeight , width: screenWidth, height: screenHeight - 50 - statusHeight), style: .grouped)
        tab.delegate = self
        tab.dataSource = self
        tab.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        tab.tableFooterView = footBtn
        tab.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
        tab.separatorStyle = .none
        tab.rowHeight = 60
        tab.allowsSelection = false
        tab.backgroundColor = .clear
        return tab
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        headline = title ?? ""
        rightNavBtn.isHidden = false
        rightNavBtn.setTitle("Done", for: .normal)
        rightNavBtn.snp.updateConstraints { (make) in
            make.width.equalTo(50)
        }
        backBtn.transform = CGAffineTransform.init(rotationAngle: -55)
    }
    @objc private func addCell(){
        dataAry.add(TabText)
        tableView.reloadData()
    }
    override func clickRightBtn() {
        view.endEditing(true)
        let ary = NSMutableArray.init(array: dataAry)
        ary.remove(TabText)
        if ary.count < 2 || title?.count ?? 0 <= 0 {
            let cancelAction = UIAlertAction.init(title: "Confirm", style: UIAlertAction.Style.cancel, handler: nil)
            let alert = UIAlertController.init(title: "At least have a title and two options.", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        changeSaveData()
        ThemeName = title ?? ""
        CurrentGameAry = ary as! [String]
        self.navigationController?.viewControllers.first?.dismiss(animated: true, completion: nil)
    }
}
extension OptionViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier) as? OptionTableViewCell
        if cell == nil {
            cell = OptionTableViewCell.init(style: .default, reuseIdentifier: OptionTableViewCell.identifier)
        }
        if indexPath.section == 1 {
            cell?.filedText = dataAry[indexPath.row] as? String ?? ""
        }else{
            cell?.filedText = title ?? ThemeText
        }
        cell?.optionDelegate = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        let label = UILabel.createLabel(title: section == 0 ? "Theme" : "Options", color: UIColor.black.withAlphaComponent(0.8), font: 18, textAlignment: .left)
        label.frame = CGRect(x: 10, y: 5, width: screenWidth, height: 20)
        label.backgroundColor = .clear
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delegate"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            dataAry.removeObject(at: indexPath.row)
            tableView.reloadData()
            changeSaveData()
        }
    }
    fileprivate func changeSaveData(){
        guard title?.count ?? 0 > 0 else {
            return
        }
        let dict = AppConfig.readJsonData()
        let ary = NSMutableArray.init(array: dataAry)
        ary.remove(TabText)
        dict.setValue(ary, forKey: title ?? "")
        AppConfig.writeToData(dict: dict)
    }
}
extension OptionViewController: OptionCellDelegate{
    func textFieldEndEditing(text: String, cell: OptionTableViewCell) {
        guard  let indexPath = tableView.indexPath(for: cell), indexPath.section != 0 else{
            changTitle(titleStr: text)
            return
        }
        dataAry.replaceObject(at: indexPath.row, with: text)
        changeSaveData()
    }
    fileprivate func changTitle(titleStr: String){
        guard let title = title else { return }
        let dict = AppConfig.readJsonData()
        let values = AppConfig.readJsonData()[title]
        dict.setValue(values, forKey: titleStr)
        dict.removeObject(forKey: title)
        self.title = titleStr
        AppConfig.writeToData(dict: dict)
    }
}
