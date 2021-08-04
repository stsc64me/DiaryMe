//
//  ViewController.swift
//  DiaryME
//
//  Created by Sittisak Teanpanom on 3/8/2564 BE.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var diaryTable: UITableView!
    @IBOutlet var searchDiaryList: UISearchBar!
    
    var filteredData: [String]?
    var diaryUrlImage:[String]?
    var diaryName:[String]?
    var diaryContent:[String]?
    var diaryTime:[String]?
    var isSelected:Int?
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.diaryTable.delegate = self
        self.diaryTable.dataSource = self
        self.searchDiaryList.delegate = self
        
        let dismiss: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismiss)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getAllImagePlist()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createViewController = segue.destination as? CreateDiaryViewController {
            createViewController.diaryName = self.diaryName ?? []
            createViewController.diaryContent = self.diaryContent ?? []
            createViewController.diaryUrlImage = self.diaryUrlImage ?? []
            createViewController.diaryTime = self.diaryTime ?? []
        }
        
        if let deteailViewController = segue.destination as? DetailDiaryViewController {
            deteailViewController.diaryName = self.diaryName ?? []
            deteailViewController.diaryContent = self.diaryContent ?? []
            deteailViewController.diaryUrlImage = self.diaryUrlImage ?? []
            deteailViewController.diaryTime = self.diaryTime ?? []
            deteailViewController.indexIsSelect = isSelected
        }
    }
    
    //MARK: - object functions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK: - functions
    func getAllImagePlist() {
        let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let customPlistURL = docsBaseURL.appendingPathComponent("DiaryList.plist")
        let plistProfileModel = NSDictionary(contentsOfFile: customPlistURL.path)
        let thumbnailImage = plistProfileModel?.object(forKey: "urlImage") as? Array<Any>
        let nameDiary = plistProfileModel?.object(forKey: "nameImage") as? Array<Any>
        let timeDiary = plistProfileModel?.object(forKey: "time") as? Array<Any>
        let contentDiary = plistProfileModel?.object(forKey: "content") as? Array<Any>
        
        
        self.diaryUrlImage = thumbnailImage as? [String]
        self.diaryName = nameDiary as? [String]
        self.diaryTime = timeDiary as? [String]
        self.diaryContent = contentDiary as? [String]
        self.filteredData = diaryName
        self.diaryTable.reloadData()
    }
    
    func addToPlist(diaryUrlImage: [String],diaryName: [String],diaryContent:[String],diaryTime:[String], completion: (() -> Void)? = nil) {
        
        guard let pathPlist = Bundle.main.path(forResource: "DiaryList", ofType: "plist") else {return}
        
        let plistProfileModel = NSMutableDictionary(contentsOfFile: pathPlist)
        
        plistProfileModel?.setValue(diaryUrlImage as Any,forKey: "urlImage")
        
        plistProfileModel?.setValue(diaryName as Any, forKey: "nameImage")
        
        plistProfileModel?.setValue(diaryContent as Any, forKey: "content")
        
        plistProfileModel?.setValue(diaryTime as Any, forKey: "time")
        
        
        let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let customPlistURL = docsBaseURL.appendingPathComponent("DiaryList.plist")
        do  {
            let data = try PropertyListSerialization.data(fromPropertyList: plistProfileModel!, format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
            do {
                try data.write(to: customPlistURL, options: .atomic)
                completion?()
            } catch (let err){
                _ = alert(message: "\(err.localizedDescription)")
            }
        } catch (let err){
            _ = alert(message: "\(err.localizedDescription)")
        }
    }
    
    func alert(message: String, title: String = "") -> UIAlertController? {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .default, handler: nil)
      alertController.addAction(OKAction)
      present(alertController, animated: true, completion: nil)
      return alertController
    }
    //MARK: - IBAction functions
    @IBAction func btnNewDiary(_ sender: Any) {
        self.performSegue(withIdentifier: "addDiary", sender: self)
    }
}

//MARK: - Tableview controller
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DiaryViewCell", owner: self, options: nil)?.first as! DiaryViewCell
        let diaryName = filteredData?[indexPath.row] ?? ""
        let timeDiary = diaryTime?[indexPath.row] ?? ""
        let imagstr = diaryUrlImage?[indexPath.row] ?? ""
        
        var imgDiary: UIImage?
        if let img = imagstr.toImage() {
            imgDiary = img
        }else {
            imgDiary = UIImage(systemName: "book")
        }
        
        cell.setUIDiaryCell(name: diaryName, time: timeDiary, image: imgDiary ?? UIImage())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelected = indexPath.row
        self.performSegue(withIdentifier: "detailView", sender: self)
    }
    
    //TODO:Slide for delete in cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.diaryUrlImage?.remove(at: indexPath.row)
            self.diaryName?.remove(at: indexPath.row)
            self.diaryContent?.remove(at: indexPath.row)
            self.diaryTime?.remove(at: indexPath.row)
            self.filteredData = self.diaryName
            self.addToPlist(
                diaryUrlImage: self.diaryUrlImage ?? [],
                diaryName: self.diaryName ?? [],
                diaryContent: self.diaryContent ?? [],
                diaryTime: self.diaryTime ?? [],
                completion: {
                    self.diaryTable.reloadData()
            })
        }
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? diaryName : diaryName?.filter({(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })

        self.diaryTable.reloadData()
    }
}
