//
//  SettingViewController.swift
//  LuckyChoice
//
//  Created by WinterOS on 2020/7/9.
//  Copyright © 2020 WinterOS. All rights reserved.
//

import UIKit
import MessageUI
enum SettingType {
    case music(String,Bool)
    case touch(String,Bool)
    case random(String,Bool)
    case vip(String)
    case closeAd(String)
    case evaluation(String)
}

class SettingViewController: ProjectBaseViewController {
    private lazy var tableView = { () -> UITableView in
        let tab = UITableView.init(frame:CGRect(x: 0, y: 50 + statusHeight , width: screenWidth, height: screenHeight - 50 - statusHeight), style: .grouped)
        tab.delegate = self
        tab.dataSource = self
        tab.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tab.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
        tab.separatorStyle = .none
        tab.rowHeight = 60
        tab.backgroundColor = .clear
        return tab
    }()
//    SettingType.music("Voice", AppConfig.makeAppConfig().isOpenMusic),
    private let dataAry = [[
                            SettingType.touch("Touch", AppConfig.makeAppConfig().isOpenTouch),
                            SettingType.random("Random content", AppConfig.makeAppConfig().isOpenRandom)],
                           [SettingType.vip("Contact Us")],
                           [SettingType.closeAd("Share"),
                            SettingType.evaluation("Comment")]]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        headline = "Setting"
    }
}
extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:SettingCell.identifier) as! SettingCell
        cell.cellType = dataAry[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = dataAry[indexPath.section][indexPath.row]
        switch type {
        case .music(_,_):
            break;
        case .touch(_,_):
            break;
        case .random(_,_):
            break;
        case .vip(_):
            if !MFMailComposeViewController.canSendMail() {
                self.showSendMailErrorAlert()
                return
            }
            else
            {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = (self as! MFMailComposeViewControllerDelegate)
                composeVC.setToRecipients(["teasteewljja@hotmail.com"])
                composeVC.setSubject("LuckyChoice - Contact Us")
                composeVC.setMessageBody("Please message us your feedback and questions", isHTML: true)
                self.present(composeVC, animated: true, completion: nil)
            }
            break;
        case .closeAd(_):
            let message = "Check out this app!! "
            let url = "http://itunes.apple.com/app/id" + "1472958080"
            if let link = NSURL(string: url)
            {
                let objectsToShare = [message,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: self.view.bounds.width, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(activityVC, animated: true, completion: nil)
            }
            break;
        case .evaluation(_):
            let openUrl = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1472958080"
            UIApplication.shared.open(NSURL.init(string: openUrl)! as URL, options: [:], completionHandler: nil)
            break;
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let actionForAlert = UIAlertAction(title: "OK", style: .default)
        sendMailErrorAlert.addAction(actionForAlert)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
