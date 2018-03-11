//
//  BugReportViewController.swift
//  NovelSpeaker
//
//  Created by 飯村卓司 on 2018/02/26.
//  Copyright © 2018年 IIMURA Takuji. All rights reserved.
//

import UIKit
import MessageUI
import Eureka

struct BugReportViewInputData {
    var TimeOfOccurence = Date.init(timeIntervalSinceNow: 60*60*24) // 1日後にしておく(DatePickerで日付を一回戻すだけでいいので)
    var DescriptionOfTheProblem = ""
    var ProblemOccurenceProcedure = ""
    var IsNeedResponse = false
}

class BugReportViewController: FormViewController, MFMailComposeViewControllerDelegate {
    static var value = BugReportViewInputData();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BehaviorLogger.AddLog(description: "BugReportViewController viewDidLoad", data: [:])

        // 日付は ViewDidLoad のたびに上書きで不正な値にしておきます。
        BugReportViewController.value.TimeOfOccurence = Date.init(timeIntervalSinceNow: 60*60*24) // 1日後にしておく(DatePickerで日付を一回戻すだけでいいので)

        // Do any additional setup after loading the view.
        form +++ Section(NSLocalizedString("BugReportViewController_SectionHeader", comment: "不都合の報告"))
            <<< LabelRow() {
                $0.title = NSLocalizedString("BugReportViewController_BugReportTitle", comment:"不都合がある場合にはこのフォームから入力して報告できます。")
                $0.cell.textLabel?.numberOfLines = 0
            } <<< DateTimeRow() {
                $0.title = NSLocalizedString("BugReportViewController_TimeOfOccurrence", comment: "問題発生日時")
                $0.value = BugReportViewController.value.TimeOfOccurence
            }.onChange({ (row) in
                if let value = row.value {
                    BugReportViewController.value.TimeOfOccurence = value
                }
            })
            <<< LabelRow() {
                $0.title = NSLocalizedString("BugReportViewController_DescriptionOfTheProblem", comment: "問題の説明")
            } <<< TextAreaRow() {
                $0.add(rule: RuleRequired())
                $0.placeholder = NSLocalizedString("BugReportViewController_DescriptionOfTheProblemPlaceHolder", comment: "起こっている問題を説明してください")
                $0.value = BugReportViewController.value.DescriptionOfTheProblem
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }.onChange({ (row) in
                if let value = row.value {
                    BugReportViewController.value.DescriptionOfTheProblem = value
                }
            })
            <<< LabelRow() {
                $0.title = NSLocalizedString("BugReportViewController_ProblemOccurrenceProcedure", comment: "問題発生手順")
            } <<< TextAreaRow() {
                $0.placeholder = NSLocalizedString("BugReportViewController_ProblemOccurrenceProcedurePlaceHolder", comment: "問題が発生するまでの操作手順を書いてください")
                $0.value = BugReportViewController.value.ProblemOccurenceProcedure
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }.onChange({ (row) in
                if let value = row.value {
                    BugReportViewController.value.ProblemOccurenceProcedure = value
                }
            })
            <<< SwitchRow() {
                $0.title = NSLocalizedString("BugReportViewController_IsNeedResponse", comment: "この報告への返事が欲しい")
                $0.value = BugReportViewController.value.IsNeedResponse
            }.onChange({ (row) in
                if let value = row.value {
                    BugReportViewController.value.IsNeedResponse = value
                }
            }) <<< LabelRow() {
                $0.title = NSLocalizedString("BugReportViewController_InformationForIsNeedResponse", comment: "返事が欲しいと設定されている場合には開発者から送信元のメールアドレスへ返信を行います。返信は遅くなる可能性があります。また、@gmail.com からのメールを受け取れるようにしていない場合など、返信が届かない場合があります。")
                $0.cell.textLabel?.font = .systemFont(ofSize: 12.0)
                $0.cell.textLabel?.numberOfLines = 0
            } <<< ButtonRow() {
            $0.title = NSLocalizedString("BugReportViewController_SendBugReportButtonTitle", comment: "不都合報告mailを作成する")
            }.onCellSelection({ (butonCellof, buttonRow) in
                var warningMessage = ""
                if BugReportViewController.value.TimeOfOccurence > Date.init(timeIntervalSinceNow: 0) {
                    warningMessage += NSLocalizedString("BugReportViewController_InvalidTimeOfOccurence", comment: "できるだけ正確な日時を指定してください。なお、未来の日時は指定できません。")
                }
                if BugReportViewController.value.DescriptionOfTheProblem == "" {
                    if warningMessage.count > 0 {
                        warningMessage += "\n"
                    }
                    warningMessage += NSLocalizedString("BugReportViewController_NoDescriptonOfTheProblem", comment: "問題の説明欄が空欄になっています。")
                }
                if warningMessage.count > 0 {
                    EasyDialog.Builder(self)
                        .title(title: NSLocalizedString("BugReportViewController_ErrorDialog", comment: "問題のある入力項目があります"))
                        .label(text: warningMessage, textAlignment: .left)
                        .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                            DispatchQueue.main.async {
                                dialog.dismiss(animated: false, completion: nil)
                            }
                        })
                        .build().show()
                    return;
                }
                EasyDialog.Builder(self)
                    .label(text: NSLocalizedString("BugReportViewController_AddBehaviourLogAnnounce", comment: "ことせかい 内部に保存されている操作ログを不都合報告mailに添付しますか？\n\n操作ログにはダウンロードされた小説の詳細(URL等)が含まれるため、開発者に公開されてしまっては困るような情報を ことせかい に含めてしまっている場合には「いいえ」を選択する必要があります。\nまた、操作ログが添付されておりませんと、開発者側で状況の再現が取りにくくなるため、対応がしにくくなる可能性があります。(添付して頂いても対応できない場合もあります)"), textAlignment: .left)
                    .addButton(title: NSLocalizedString("BugReportViewController_NO", comment: "いいえ"), callback: { (dialog) in
                        self.sendBugReportMail(log: nil, description: BugReportViewController.value.DescriptionOfTheProblem, procedure: BugReportViewController.value.ProblemOccurenceProcedure, date: BugReportViewController.value.TimeOfOccurence, needResponse: BugReportViewController.value.IsNeedResponse)
                        DispatchQueue.main.async {
                            dialog.dismiss(animated: false, completion: nil)
                        }
                    })
                    .addButton(title: NSLocalizedString("BugReportViewController_YES", comment: "はい"), callback: { (dialog) in
                        self.sendBugReportMail(log: BehaviorLogger.LoadLog(), description: BugReportViewController.value.DescriptionOfTheProblem, procedure: BugReportViewController.value.ProblemOccurenceProcedure, date: BugReportViewController.value.TimeOfOccurence, needResponse: BugReportViewController.value.IsNeedResponse)
                        DispatchQueue.main.async {
                            dialog.dismiss(animated: false, completion: nil)
                        }
                    })
                .build().show()
                self.navigationController?.popViewController(animated: true)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func sendBugReportMail(log:String?, description:String, procedure:String, date:Date, needResponse:Bool) -> Bool {
        if !MFMailComposeViewController.canSendMail() {
            return false;
        }
        var appVersionString = "*"
        if let infoDictionary = Bundle.main.infoDictionary, let bundleVersion = infoDictionary["CFBundleVersion"] as? String, let shortVersion = infoDictionary["CFBundleShortVersionString"] as? String {
            appVersionString = String.init(format: "%@(%@)", shortVersion, bundleVersion)
        }
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self;
        picker.setSubject(NSLocalizedString("BugReportViewController_SendBugReportMailSubject", comment:"ことせかい 不都合報告"))
        picker.setToRecipients(["limuraproducts@gmail.com"])
        picker.setMessageBody(
            NSLocalizedString("BugReportViewController_SendBugReportMailInformation", comment: "\n\n===============\nここより下の行は編集しないでください。\nなお、問題の発生している場面のスクリーンショットなどを添付して頂けると、より対応しやすくなるかと思われます。")
            + "\n"
            + "\n" + NSLocalizedString("BugReportViewController_SendBugReport_IsNeedResponse", comment: "返信を希望する") + ": " + (needResponse ? NSLocalizedString("BugReportViewController_YES", comment: "はい") : NSLocalizedString("BugReportViewController_NO", comment: "いいえ"))
            + "\niOS version: " + UIDevice.current.systemVersion
            + "\nmodel: " + UIDevice.modelName
            + "\nApp version:" + appVersionString
            + "\n" + NSLocalizedString("BugReportViewController_TimeOfOccurrence", comment: "問題発生日時") + ": " + date.description(with: Locale.init(identifier: "ja_JP"))
            + "\n-----\n" + NSLocalizedString("BugReportViewController_SendBugReport_Description", comment: "不都合の概要") + ":\n" + description
            + "\n-----\n" + NSLocalizedString("BugReportViewController_SendBugReport_Procedure", comment: "不都合の再現方法") + ":\n" + procedure
            , isHTML: false)
        if let log = log {
            if let data = log.data(using: .utf8) {
                picker.addAttachmentData(data, mimeType: "application/json", fileName: "operation_log.json")
            }
        }
        present(picker, animated: true, completion: nil)
        return true;
    }
    // MFMailComposeViewController でmailアプリ終了時に呼び出されるのでこのタイミングで viewController を取り戻します
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}
