//
//  ViewController.swift
//  DiaryME
//
//  Created by Sittisak Teanpanom on 3/8/2564 BE.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var navbar: UINavigationBar!
    @IBOutlet var diaryTable: UITableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.diaryTable.delegate = self
        self.diaryTable.dataSource = self
    }
    
    @IBAction func btnNewDiary(_ sender: Any) {
        
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
