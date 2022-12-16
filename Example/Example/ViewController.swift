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

    // MARK: - Actions

    @IBAction func tapFetchAllPosts(_ sender: Any) {
        NetworkManager.shared.request(
            endpoint: Endpoint.fetchPosts,
            dataType: [PostInfo].self
        ) { [weak self] result in
            self?.handleResult(result: result)
        }
    }

    @IBAction func tapFetchPostIDPath(_ sender: Any) {
        showInputAlert(title: "id") { id in
            guard let id = Int(id) else {
                return
            }

            NetworkManager.shared.request(
                endpoint: Endpoint.fetchCommentsWithPath(postId: id),
                dataType: [CommentInfo].self
            ) { result in
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    print(error.errorDescription)
                }
            }
        }
    }

    @IBAction func tapFetchPostIDParam(_ sender: Any) {
    }

    @IBAction func tapUpdatePost(_ sender: Any) {
    }

    @IBAction func tapUpdateTitle(_ sender: Any) {
    }

    @IBAction func tapDelete(_ sender: Any) {
    }

    private func handleResult(result: Result<[PostInfo], NetworkError>) {
        switch result {
        case let .success(data):
            print(data.description)
        case let .failure(error):
            print(error.errorDescription)
        }
    }

    private func showInputAlert(title: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(
            title: title,
            message: "",
            preferredStyle: .alert
        )
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else {
                return
            }

            completion(text)
        })

        present(alert, animated: true)
    }
}
