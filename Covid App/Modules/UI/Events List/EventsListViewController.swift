//
//  EventsListViewController.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//  
//

import UIKit
import RxSwift
import RxCocoa

class EventsListViewController: UIViewController {
    
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: UINib(nibName: "EventListCell", bundle: nil), withCellClass: EventListCell.self)
        }
    }
    
    private var eventsList: [Event] = []
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel = EventsListViewModel()
    
    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
        prepareViewModel()
        viewModel.getListEvent()
    }
    
    private func renderUi() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "event_logo")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "event_logout"), style: .plain, target: self, action:#selector(logout))
    }
    
    @objc private func logout() {
        AppConfig.shared.clearAccessToken()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func prepareViewModel() {
        viewModel.eventLoading.subscribe(onNext: {
            [weak self] loading in
            self?.showLoading(loading)
        }).disposed(by: disposeBag)
        viewModel.getEventSuccess.subscribe(onNext: {
            [weak self] list in
            self?.reloadEventList(list)
        }).disposed(by: disposeBag)
        viewModel.getEventFailed.subscribe(onNext: {
            [weak self] error in
            self?.showError(error)
        }).disposed(by: disposeBag)
    }
    private func reloadEventList(_ events: [Event]) {
        eventsList.removeAll()
        eventsList.append(contentsOf: events)
        tableView.reloadData()
    }
    private func scanEvent(_ event: Event) {
        print("Scan event: \(event.name ?? "")")
    }
}


// MARK: - UI Setup
extension EventsListViewController {
    
}

extension EventsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as? EventListCell else { return UITableViewCell() }
        let event = eventsList[indexPath.row]
        cell.displayEvent(event)
        cell.scanEventHandle = { [weak self] in
            guard let self = self else { return }
            self.scanEvent(event)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
}
