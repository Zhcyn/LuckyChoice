//
//  ViewController.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit

class ViewController: ProjectBaseViewController {
    private lazy var tableView = { () -> UITableView in
        let tab = UITableView.init(frame: CGRect(x: 0, y: 50 + statusHeight , width: screenWidth, height: screenHeight - 50 - statusHeight))
        tab.delegate = self
        tab.dataSource = self
        tab.register(ThemeTableViewCell.self, forCellReuseIdentifier: ThemeTableViewCell.identifier)
        tab.tableFooterView = footBtn
        tab.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
        tab.separatorStyle = .none
        tab.rowHeight = 60
        tab.backgroundColor = .clear
        return tab
    }()
    private let footBtn: UIView = {
        let footView = UIView.init(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 44))
        let btn = UIButton.createButton("Adding themes", .red, 20, target: self, selector: #selector(addSection))
        btn.frame = CGRect(x: 15, y: 10, width: screenWidth - 30, height: 44)
        btn.cuttingView(radius: 5, borWidth: 0, borColor: .clear)
        btn.setBackgroundImage(UIImage.init(named: "edit_bg"), for: .normal)
        footView.addSubview(btn)
        return footView
    }()
   private var dataAry = NSMutableArray.init(array: AppConfig.readJsonData().allKeys)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        headline = "Choosing Theme"
        rightNavBtn.isHidden = false
        rightNavBtn.setBackgroundImage(UIImage.init(named: "edit"), for: .normal)
    }
    override func clickRightBtn() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    @objc private func addSection(){
        let option = OptionViewController.init()
        option.title = changeName()
        print(changeName())
        navigationController?.pushViewController(option, animated: true)
 
    }
    private func changeName() -> String{
        let keys = AppConfig.readJsonData().allKeys as! [String]
        var last = 0
        var theme = ThemeText
        for key in keys {
            guard key.contains(ThemeText),
                  key.last?.isNumber ?? false else {
                    if key.contains(ThemeText) && last == 0{
                        theme = ThemeText + "1"
                    }
                    continue
            }
            let index = key.index(key.startIndex, offsetBy: ThemeText.count)
            let lastString = key[index..<key.endIndex]
            let current = Int(lastString) ?? 0
            if last < current{
                last = current
                theme = ThemeText + "\(last + 1)"
            }
        }
        return theme
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ThemeTableViewCell.identifier) as? ThemeTableViewCell
        if cell == nil {
            cell = ThemeTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: ThemeTableViewCell.identifier)
        }
        cell?.title = "\(dataAry[indexPath.row])"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let key = dataAry[indexPath.row]  as! String
        let values = AppConfig.readJsonData().object(forKey: key)  as! [String]
        let ary = NSMutableArray.init(array: values)
        let option = OptionViewController.init()
        option.title = key
        option.dataAry = ary
        navigationController?.pushViewController(option, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dict = AppConfig.readJsonData()
            dict.removeObject(forKey: dataAry[indexPath.row])
            AppConfig.writeToData(dict: dict)
            dataAry.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
        }
    }
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataAry.exchangeObject(at: (sourceIndexPath as NSIndexPath).row, withObjectAt: (destinationIndexPath as NSIndexPath).row)
        let feed =  UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        feed.impactOccurred()
        let dict: NSMutableDictionary = NSMutableDictionary.init()
        let dict1 = AppConfig.readJsonData()
        for key in dataAry {
            guard let value = dict1.object(forKey: key) else {
                return
            }
            dict.setValue(value, forKey: key as! String)
        }
        AppConfig.writeToData(dict: dict)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
