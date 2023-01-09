//
//  ResponseVC.swift
//  Example
//
//  Created by 장재훈 on 2022/12/19.
//

import UIKit

final class ResponseVC: UIViewController {
    @IBOutlet weak var label: UILabel?
    
    var labelText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label?.text = labelText
    }
}
