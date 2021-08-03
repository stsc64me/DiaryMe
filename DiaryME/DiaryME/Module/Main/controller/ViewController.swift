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
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.diaryTable.delegate = self
        self.diaryTable.dataSource = self
    }
    
    @IBAction func btnNewDiary(_ sender: Any) {
        self.performSegue(withIdentifier: "addDiary", sender: self)
    }
}

//MARK: - Tableview controller
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DiaryViewCell", owner: self, options: nil)?.first as! DiaryViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailView", sender: self)
    }
}
