//
//  ViewController.swift
//  Example
//
//  Created by 장재훈 on 2022/12/07.
//

import TrueNetwork
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func tapFetchAllPosts(_ sender: Any) {
        NetworkManager.shared.request(
            endpoint: Endpoint.fetchPosts,
            dataType: [PostInfo].self
        ) { [weak self] result in
            switch result {
            case let .success(data):
                print(data.description)
            case let .failure(error):
                self?.singleMessageAlert(message: error.errorDescription)
            }
        }
    }

    @IBAction func tapFetchPostIDPath(_ sender: Any) {
        idAlert { id in
            guard let id = Int(id) else {
                return
            }

            NetworkManager.shared.request(
                endpoint: Endpoint.fetchCommentsWithPath(postId: id),
                dataType: [CommentInfo].self
            ) { [weak self] result in
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    self?.singleMessageAlert(message: error.errorDescription)
                }
            }
        }
    }

    @IBAction func tapFetchPostIDParam(_ sender: Any) {
        idAlert { id in
            guard let id = Int(id) else {
                return
            }

            NetworkManager.shared.request(
                endpoint: Endpoint.fetchCommentsWithParams(postId: id),
                dataType: [CommentInfo].self
            ) { [weak self] result in
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    self?.singleMessageAlert(message: error.errorDescription)
                }
            }
        }
    }

    @IBAction func tapUpdatePost(_ sender: Any) {
        postInfoAlert { postInfo in
            NetworkManager.shared.request(
                endpoint: Endpoint.writePost(post: postInfo),
                dataType: PostInfo.self
            ) { [weak self] result in
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    self?.singleMessageAlert(message: error.errorDescription)
                }
            }
        }
    }

    @IBAction func tapUpdateTitle(_ sender: Any) {
        idTitleAlert { id, title in
            NetworkManager.shared.request(
                endpoint: Endpoint.updateTitle(postId: id, title: title),
                dataType: PostInfo.self
            ) { [weak self] result in
                switch result {
                case let .success(data):
                    print(data)
                case let .failure(error):
                    self?.singleMessageAlert(message: error.errorDescription)
                }
            }
        }
    }

    @IBAction func tapDelete(_ sender: Any) {
        idAlert { id in
            guard let id = Int(id) else {
                return
            }

            NetworkManager.shared.request(
                endpoint: Endpoint.deletePost(postId: id),
                dataType: DeleteResponse.self
            ) { [weak self] result in
                switch result {
                case let .success(data):
                    self?.singleMessageAlert(message: "삭제 완료")
                case let .failure(error):
                    self?.singleMessageAlert(message: error.errorDescription)
                }
            }
        }
    }
}

private extension ViewController {
    func singleMessageAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }

    func idAlert(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Input", message: nil, preferredStyle: .alert)

        alert.addTextField { $0.placeholder = "ID" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let id = alert.textFields?.first?.text else {
                return
            }

            completion(id)
        })

        present(alert, animated: true)
    }

    func idTitleAlert(completion: @escaping ((Int, String)) -> Void) {
        let alert = UIAlertController(title: "Input", message: nil, preferredStyle: .alert)

        alert.addTextField { $0.placeholder = "ID" }
        alert.addTextField { $0.placeholder = "Title" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let id = alert.textFields?[0].text,
                  let title = alert.textFields?[1].text else {
                return
            }

            completion(
                (Int(id) ?? 0,
                 title)
            )
        })

        present(alert, animated: true)
    }

    func postInfoAlert(completion: @escaping (PostInfo) -> Void) {
        let alert = UIAlertController(title: "Input", message: nil, preferredStyle: .alert)

        alert.addTextField { $0.placeholder = "ID" }
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Body" }
        alert.addTextField { $0.placeholder = "UserID" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let id = alert.textFields?[0].text,
                  let title = alert.textFields?[1].text,
                  let body = alert.textFields?[2].text,
                  let userId = alert.textFields?[3].text else {
                return
            }

            completion(PostInfo(userId: Int(userId) ?? 0, id: Int(id) ?? 0, title: title, body: body))
        })

        present(alert, animated: true)
    }
}
