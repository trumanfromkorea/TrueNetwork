//
//  ViewController.swift
//  Example
//
//  Created by 장재훈 on 2022/12/07.
//

import TrueNetwork
import UIKit

final class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func navigate(with response: String) {
        DispatchQueue.main.async { [weak self] in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ResponseVC") as? ResponseVC else {
                return
            }

            vc.labelText = response

            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Actions

    @IBAction func tapFetchAllPosts(_ sender: Any) {
        NetworkManager<[PostInfo]>()
            .request(endpoint: Endpoint.fetchPosts) { [weak self] result in
                switch result {
                case let .success(data):
                    self?.navigate(with: data.description)
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

            NetworkManager<[CommentInfo]>()
                .request(endpoint: Endpoint.fetchCommentsWithPath(postId: id)) { [weak self] result in
                    switch result {
                    case let .success(data):
                        self?.navigate(with: data.description)
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

            NetworkManager<[CommentInfo]>()
                .request(endpoint: Endpoint.fetchCommentsWithParams(postId: id)) { [weak self] result in
                    switch result {
                    case let .success(data):
                        self?.navigate(with: data.description)
                    case let .failure(error):
                        self?.singleMessageAlert(message: error.errorDescription)
                    }
                }
        }
    }

    @IBAction func tapUpdatePost(_ sender: Any) {
        postInfoAlert { postInfo in
            NetworkManager<PostInfo>()
                .request(endpoint: Endpoint.writePost(post: postInfo)) { [weak self] result in
                    switch result {
                    case let .success(data):
                        self?.navigate(with: data.description)
                    case let .failure(error):
                        self?.singleMessageAlert(message: error.errorDescription)
                    }
                }
        }
    }

    @IBAction func tapUpdateTitle(_ sender: Any) {
        idTitleAlert { id, title in
            NetworkManager<PostInfo>()
                .request(endpoint: Endpoint.updateTitle(postId: id, title: title)) { [weak self] result in
                    switch result {
                    case let .success(data):
                        self?.navigate(with: data.description)
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

            NetworkManager<DeleteResponse>()
                .request(endpoint: Endpoint.deletePost(postId: id)) { [weak self] result in
                    switch result {
                    case .success:
                        self?.singleMessageAlert(message: "삭제 완료")
                    case let .failure(error):
                        self?.singleMessageAlert(message: error.errorDescription)
                    }
                }
        }
    }
}

// MARK: - Alerts

private extension MainVC {
    func singleMessageAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
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

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
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

            completion((Int(id) ?? 0, title))
        })

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
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

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
