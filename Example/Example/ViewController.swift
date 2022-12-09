//
//  ViewController.swift
//  Example
//
//  Created by 장재훈 on 2022/12/07.
//

import TrueNetwork
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    private func fetchPosts() {
        NetworkManager.shared.request(
            endpoint: Endpoint.fetchPosts, dataType: [PostInfo].self
        ) { result in
            switch result {
            case let .success(data):
                print(data.description)
            case let .failure(error):
                print(error.errorDescription)
            }
        }
    }
}
