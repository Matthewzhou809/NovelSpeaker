//
//  SampleUrlFetcher.swift
//  NovelSpeaker
//
//  Created by 飯村卓司 on 2017/11/19.
//  Copyright © 2017年 IIMURA Takuji. All rights reserved.
//

import UIKit
import PDFKit

class NiftyUtilitySwift: NSObject {
    @objc public static func checkTextImportConifirmToUser(viewController: UIViewController, title: String, content: String, hintString: String?){
        DispatchQueue.main.async {
            var easyDialog = EasyDialog.Builder(viewController)
                .textField(tag: 100, placeholder: title, content: title, keyboardType: .default, secure: false, focusKeyboard: false, borderStyle: .roundedRect)
                // TODO: 怪しくheightを画面の縦方向からの比率で指定している。
                // ここに 1.0 とか書くと他のViewの分の高さが入って全体は画面の縦幅よりも高くなるので全部が表示されない。
                // つまり、この謎の数字 0.53 というのは、できれば書きたくない値であり、この値でも大きすぎるかもしれず、
                // 小さすぎるかもしれず、適切な大きさ(baseViewが表示領域の縦幅に入る状態)になるように縮む必要があるのだが、
                // EasyDialog をそのように修正するのが面倒なのでやっていないという事なのであった。('A`)
                .textView(content: content, heightMultiplier: 0.53)
                
            if let hintString = hintString {
                easyDialog = easyDialog.label(text: hintString)
            }
            easyDialog.addButton(title: NSLocalizedString("NiftyUtilitySwift_CancelImport", comment: "取り込まない"), callback: { (dialog) in
                DispatchQueue.main.async {
                    dialog.dismiss(animated: false, completion: nil)
                }
            })
            .addButton(title: NSLocalizedString("NiftyUtilitySwift_Import", comment: "このまま取り込む"), callback: { (dialog) in
                let titleTextField = dialog.view.viewWithTag(100) as! UITextField
                let title = titleTextField.text ?? title
                DispatchQueue.main.async {
                    dialog.dismiss(animated: false, completion: nil)
                }
                if let globalData = GlobalDataSingleton.getInstance() {
                    if let newUserBook = globalData.createNewUserBook() {
                        newUserBook.title = title
                        newUserBook.general_all_no = NSNumber.init(value: 1)
                        globalData.updateNarouContent(newUserBook)
                        globalData.updateStory(content, chapter_number: 1, parentContent:   newUserBook)
                        return
                    }
                }
                DispatchQueue.main.async {
                    EasyDialog.Builder(viewController)
                        .title(title: NSLocalizedString("NiftyUtilitySwift_CanNotAddToBookshelfTitle", comment: "不明なエラー"))
                        .label(text: NSLocalizedString("NiftyUtilitySwift_CanNotAddToBookshelfBody", comment: "本棚への追加に失敗しました。"))
                        .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                            DispatchQueue.main.async {
                                dialog.dismiss(animated: false, completion: nil)
                            }
                        })
                        .build().show()
                }
            })
            .build().show()
        }

    }
    
    @objc public static func checkUrlAndConifirmToUser(viewController: UIViewController, url: URL, cookieArray: [String], depth: Int = 0) {
        BehaviorLogger.AddLog(description: "checkUrlAndConifirmToUser called.", data: ["url": url.absoluteString])
        DispatchQueue.main.async {
            let easyAlert = EasyAlert(viewController: viewController)
            let alertActionHolder = easyAlert?.show(NSLocalizedString("ImportFromWebPageViewController_loading", comment: "loading"), message: nil)
            let uriLoader = UriLoader()
            let customSiteInfoData = GlobalDataSingleton.getInstance().getCachedCustomAutoPagerizeSiteInfoData()
            uriLoader.addCustomSiteInfo(from: customSiteInfoData)
            let siteInfoData = GlobalDataSingleton.getInstance().getCachedAutoPagerizeSiteInfoData()
            uriLoader.addSiteInfo(from: siteInfoData)
            uriLoader.fetchOneUrl(url, cookieArray: cookieArray, successAction: { (story: HtmlStory?) in
                DispatchQueue.main.async {
                    alertActionHolder?.closeAlert(false, completion: {
                        // firstPageLink があった場合はそっちを読み直します
                        if let firstPageLink = story?.firstPageLink {
                            // ただし、depth が 5 を越えたら読み直さず先に進みます
                            if depth < 5 {
                                NiftyUtilitySwift.checkUrlAndConifirmToUser(viewController: viewController, url: firstPageLink, cookieArray: cookieArray, depth: depth+1)
                                return
                            }
                        }
                        guard let content = story?.content else {
                            DispatchQueue.main.async {
                                EasyDialog.Builder(viewController)
                                    .title(title: NSLocalizedString("NiftyUtilitySwift_ImportError", comment: "取り込み失敗"))
                                    .label(text: NSLocalizedString("NiftyUtilitySwift_ImportedButNoTextFound", comment: "読み込めはしたけれど、内容がありませんでした"))
                                    .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                                        DispatchQueue.main.async {
                                            dialog.dismiss(animated: false, completion: nil)
                                        }
                                    })
                                    .build().show()
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            var multiPageString = NSLocalizedString("NiftyUtilitySwift_FollowingPageAreNotAvailable", comment: "続ページ：無し")
                            let nextUrl:URL? = story?.nextUrl ?? nil
                            if (story?.nextUrl) != nil {
                                multiPageString = NSLocalizedString("NiftyUtilitySwift_FollowingPageAreAvailable", comment: "続ページ：有り")
                            }
                            var titleString = NSLocalizedString("NiftyUtilitySwift_TitleUnknown", comment: "不明なタイトル")
                            if let title = story?.title {
                                titleString = title
                            }
                            EasyDialog.Builder(viewController)
                                .textField(tag: 100, placeholder: titleString, content: titleString, keyboardType: .default, secure: false, focusKeyboard: false, borderStyle: .roundedRect)
                                //.title(title: titleString)
                                // TODO: 怪しくheightを画面の縦方向からの比率で指定している。
                                // ここに 1.0 とか書くと他のViewの分の高さが入って全体は画面の縦幅よりも高くなるので全部が表示されない。
                                // つまり、この謎の数字 0.53 というのは、できれば書きたくない値であり、この値でも大きすぎるかもしれず、
                                // 小さすぎるかもしれず、適切な大きさ(baseViewが表示領域の縦幅に入る状態)になるように縮む必要があるのだが、
                                // EasyDialog をそのように修正するのが面倒なのでやっていないという事なのであった。('A`)
                                .textView(content: content, heightMultiplier: 0.53)
                                .label(text: multiPageString)
                                .addButton(title: NSLocalizedString("NiftyUtilitySwift_CancelImport", comment: "取り込まない"), callback: { (dialog) in
                                    DispatchQueue.main.async {
                                        dialog.dismiss(animated: false, completion: nil)
                                    }
                                })
                                .addButton(title: NSLocalizedString("NiftyUtilitySwift_Import", comment: "このまま取り込む"), callback: { (dialog) in
                                    let titleTextField = dialog.view.viewWithTag(100) as! UITextField
                                    let titleString = titleTextField.text ?? titleString
                                    DispatchQueue.main.async {
                                        dialog.dismiss(animated: false, completion: nil)
                                    }
                                    guard let globalData = GlobalDataSingleton.getInstance() else {
                                        DispatchQueue.main.async {
                                            EasyDialog.Builder(viewController)
                                                .title(title: NSLocalizedString("NiftyUtilitySwift_CanNotAddToBookshelfTitle", comment: "不明なエラー"))
                                                .label(text: NSLocalizedString("NiftyUtilitySwift_CanNotAddToBookshelfBody", comment: "本棚への追加に失敗しました。"))
                                                .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                                                    DispatchQueue.main.async {
                                                        dialog.dismiss(animated: false, completion: nil)
                                                    }
                                                })
                                                .build().show()
                                        }
                                        return
                                    }
                                    let cookieParameter = cookieArray.joined(separator: ";")
                                    globalData.addNewContent(for: url, nextUrl:nextUrl, cookieParameter: cookieParameter, title: titleString, author: story?.author, firstContent: content, viewController: viewController)
                                })
                                .build().show()
                        }
                    })
                }
            }, failedAction: { (url:URL?, error:String?) in
                DispatchQueue.main.async {
                    alertActionHolder?.closeAlert(false, completion: {
                        var errorMessage = NSLocalizedString("NiftyUtilitySwift_CanNotAddToBookshelfTitle", comment: "不明なエラー")
                        if let err = error {
                            errorMessage = err
                        }
                        EasyDialog.Builder(viewController)
                            .title(title: NSLocalizedString("NiftyUtilitySwift_ImportError", comment: "取り込み失敗"))
                            .label(text: errorMessage)
                            .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                                DispatchQueue.main.async {
                                    dialog.dismiss(animated: false, completion: nil)
                                }
                            })
                            .build().show()
                    })
                }
            })
        }
    }
    
    @objc public static func BinaryPDFToString(data: Data) -> String? {
        if #available(iOS 11.0, *) {
            let pdf = PDFDocument(data: data)
            if let str = pdf?.string {
                return str
            }
        }
        return nil
    }
    
    @objc public static func FilePDFToString(url: URL) -> String? {
        if #available(iOS 11.0, *) {
            let pdf = PDFDocument(url: url)
            if let str = pdf?.string {
                return str
            }
        }
        return nil
    }
    
    @objc public static func FileRTFToAttributedString(url: URL) -> NSAttributedString? {
        do {
            let attributedString = try NSAttributedString(fileURL: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            return attributedString
        }catch let error{
            print("AttributedString from RTF failed. error: ", error)
        }
        return nil
    }
    @objc public static func FileRTFDToAttributedString(url: URL) -> NSAttributedString? {
        do {
            let attributedString = try NSAttributedString(fileURL: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
            return attributedString
        }catch let error{
            print("AttributedString from RTFD failed. error: ", error)
        }
        return nil
    }

    @objc public static func EasyDialogOneButton(viewController: UIViewController, title: String?, message: String?, buttonTitle: String?, buttonAction:(()->Void)?) {
        var dialog = EasyDialog.Builder(viewController)
        if let title = title {
            dialog = dialog.title(title: title)
        }
        if let message = message {
            dialog = dialog.label(text: message, textAlignment: .left)
        }
        dialog = dialog.addButton(title: buttonTitle != nil ? buttonTitle! : NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
            if let buttonAction = buttonAction {
                buttonAction()
            }
            dialog.dismiss(animated: false, completion: nil)
        })
        dialog.build().show()
    }
    
    @objc public static func httpGet(url: URL, successAction:((Data)->Void)?, failedAction:((Error?)->Void)?){
        let session: URLSession = URLSession.shared
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            session.dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse {
                    if Int(response.statusCode / 100) % 10 == 2 {
                        if let successAction = successAction {
                            successAction(data)
                            return
                        }
                    }
                }
                if let failedAction = failedAction {
                    failedAction(error)
                }
            }.resume()
        }
    }
    
    // cachedHTTPGet で使われるキャッシュの情報
    struct dataCache {
        var data: Data?
        let cachedDate: Date
        var error: Error?
    }
    // cachedHTTPGet のキャッシュ
    static var httpCache = Dictionary<URL,dataCache>()

    // 今から指定したTimeInterval時間前より新しいデータをキャッシュしていたなら、特に何にもアクセスせずにそれを返します。
    // キャッシュはメモリを使うのでちと微妙です。
    @objc public static func cashedHTTPGet(url: URL, delay: TimeInterval, successAction:((Data)->Void)?, failedAction:((Error?)->Void)?){
        if let cache = httpCache[url] {
            if cache.cachedDate < Date(timeIntervalSinceNow: delay) {
                if let data = cache.data {
                    if let successAction = successAction {
                        successAction(data)
                    }
                }else{
                    if let failedAction = failedAction {
                        failedAction(cache.error)
                    }
                }
                return
            }
        }
        NiftyUtilitySwift.httpGet(url: url, successAction: { (data) in
            let cache = dataCache(data: data, cachedDate: Date(timeIntervalSinceNow: 0), error: nil)
            httpCache[url] = cache
            if let successAction = successAction {
                successAction(data)
            }
        }, failedAction: { (error) in
            let cache = dataCache(data: nil, cachedDate: Date(timeIntervalSinceNow: 0), error: error)
            httpCache[url] = cache
            if let failedAction = failedAction {
                failedAction(error)
            }
        })
    }
    
    /// 指定された文字列がフォント名として正しいか否かを判定します
    @objc public static func isValidFontName(fontName: String) -> Bool {
        for familyName in UIFont.familyNames.sorted() {
            for currentFontName in UIFont.fontNames(forFamilyName: familyName).sorted() {
                if currentFontName == fontName {
                    return true
                }
            }
        }
        return false
    }
    
    static func sleep(second:TimeInterval) {
        Thread.sleep(forTimeInterval: second)
        //RunLoop.current.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: second))
    }
    
    static let backgroundQueue = DispatchQueue(label: "com.limuraproducts.novelspeaker.backgroundqueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    /// 怪しく background で回しつつ終了を待ちます(ただ、コレを使おうと思う場合はなにかおかしいと思ったほうが良さそうです)
    public static func backgroundAndWait(block:(()->Void)?) {
        guard let block = block else {
            return
        }
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        NiftyUtilitySwift.backgroundQueue.asyncAfter(deadline: .init(uptimeNanoseconds: 1000*50)) {
            block()
            dispatchSemaphore.signal()
        }
        while dispatchSemaphore.wait(timeout: DispatchTime.now()) == DispatchTimeoutResult.timedOut {
            NiftyUtilitySwift.sleep(second: 0.1)
        }
    }
    
    // バイト数(例えば 4096)から "4.00[KBytes]" みたいな文字列に変換します
    public static func ByteSizeToVisibleString(byteSize:Int) -> String {
        let unitArray = ["Byte", "KByte", "MByte", "GByte", "TByte", "PByte"]
        var unitCount = 0
        var currentSizeUnit = byteSize
        var currentRemainder = 0
        while currentSizeUnit > 1024 {
            currentRemainder = currentSizeUnit % 1024
            currentSizeUnit /= 1024
            unitCount += 1
            if unitArray.count <= unitCount {
                break
            }
        }
        let answer = Float(currentSizeUnit * 1024 + currentRemainder) / 1024.0
        var s = ""
        if answer > 1 {
            s = "s"
        }
        return String(format: "%.2f[%@%@]", answer, unitArray[unitCount], s)
    }
    
    @objc public static func Date2EpochSecond(date:Date) -> UInt {
        return UInt(date.timeIntervalSince1970)
    }
    @objc public static func EpochSecond2Date(second:UInt) -> Date {
        return Date.init(timeIntervalSince1970: TimeInterval(second))
    }
    // ISO-8601 形式っぽい文字列を Date に変換する。失敗すると nil を返す。
    // ISO-8601 の一部にしか対応してない。
    // 例えばタイムゾーン部分は Z と +0900 みたいなのは対応しているけれど、+09:00 には対応していない
    // (そっちに対応するなら Z 一文字じゃなくて ZZZZZ と Zを5文字にしないと駄目なんだけれど
    // そうすると +0900 (":"が無い)に対応できない)
    // 同様に yyyy-MM... と "-" の入った拡張表記が強制であったり、MM や dd を省く形式にも対応していない。
    // YYYY-Www-D のような週の記述にも対応していない。
    // 時刻の hh:mm, hh のような省略形式にも対応していない。
    // 11:30:30,5 といった1秒未満の値も対応していない。当然 11,5 (11時半) という表記も対応していない。
    @objc public static func Date2ISO8601String(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from:date)
    }
    @objc public static func ISO8601String2Date(iso8601String:String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: iso8601String)
    }
    
    @objc public static func RestoreBackupFromJSONWithProgressDialog(jsonData:Data, dataDirectory:URL?, rootViewController:UIViewController){
        let globalDataSingleton = GlobalDataSingleton.getInstance()
        var builder = EasyDialog.Builder(rootViewController)
        NiftyUtilitySwift.DispatchSyncMainQueue {
            builder = builder.label(text: NSLocalizedString("NovelSpeakerBackup_Restoreing", comment: "バックアップより復元"), textAlignment: .center, tag: 100)
        }
        let dialog = builder.build()
        
        DispatchQueue.main.async {
            dialog.show()
        }
        
        let result = globalDataSingleton?.restoreBackup(fromJSONData: jsonData, dataDirectory: dataDirectory, progress: { (progressText) in
            DispatchQueue.main.async {
                if let label = dialog.view.viewWithTag(100) as? UILabel, let progressText = progressText{
                    label.text = NSLocalizedString("NovelSpeakerBackup_Restoreing", comment: "バックアップより復元")
                    + "\r\n" + progressText
                }
            }
        })
        DispatchQueue.main.async {
            dialog.dismiss(animated: false, completion: {
                if result == true {
                    EasyDialog.Builder(rootViewController)
                    .label(text: NSLocalizedString("GlobalDataSingleton_BackupDataLoaded", comment:"設定データを読み込みました。ダウンロードされていた小説については現在ダウンロード中です。すべての小説のダウンロードにはそれなりの時間がかかります。"), textAlignment: .center)
                    .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                        dialog.dismiss(animated: false, completion: nil)
                    })
                    .build().show()
                }else{
                    EasyDialog.Builder(rootViewController)
                    .label(text: NSLocalizedString("GlobalDataSingleton_RestoreBackupDataFailed", comment:"設定データの読み込みに失敗しました。"), textAlignment: .center)
                    .addButton(title: NSLocalizedString("OK_button", comment: "OK"), callback: { (dialog) in
                        dialog.dismiss(animated: false, completion: nil)
                    })
                    .build().show()
                }
            })
        }
    }
    
    @objc static public func DispatchSyncMainQueue(block:(()->Void)?) -> Void {
        guard let block = block else {
            return
        }
        if Thread.isMainThread {
            block()
        }else{
            DispatchQueue.main.sync {
                block()
            }
        }
    }
    
    @objc static public func GetAppVersionString() -> String {
        var appVersionString = "*"
        if let infoDictionary = Bundle.main.infoDictionary, let bundleVersion = infoDictionary["CFBundleVersion"] as? String, let shortVersion = infoDictionary["CFBundleShortVersionString"] as? String {
            appVersionString = String.init(format: "%@(%@)", shortVersion, bundleVersion)
        }
        return appVersionString
    }
}