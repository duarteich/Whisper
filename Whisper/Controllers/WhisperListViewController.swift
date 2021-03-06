//
//  ViewController.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import UIKit

class WhisperListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - private properties
    private let viewModel = WhisperViewModel()
    var parentWhisper: Whisper?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.whispers.bind { [weak self] whispers in
            guard let self = self else { return }
            if !whispers.isEmpty {
                self.tableView.reloadData()
            }
        }
        if let parentWhisper = parentWhisper {
            title = "Replies"
            if parentWhisper.replies > 0 {
                viewModel.fetchReplies(whisper: parentWhisper)
            } else {
                print("No replies for this Whisper")
            }
            
        } else {
            title = "Popular"
            viewModel.fetchWhispers()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 700
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: - UITableViewDataSource
extension WhisperListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.whispers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WhisperCell.identifier, for: indexPath) as? WhisperCell else {
            fatalError("The dequeued cell is not an instance  of PhotoCell")
        }
        let whisper = viewModel.whispers.value[indexPath.row]
        cell.setup(with: whisper)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension WhisperListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let repliesViewController = storyboard?.instantiateViewController(withIdentifier: "whisperListViewController") as? WhisperListViewController else { return }
        repliesViewController.parentWhisper = viewModel.whispers.value[indexPath.row]
        navigationController?.pushViewController(repliesViewController, animated: true)
    }
}

