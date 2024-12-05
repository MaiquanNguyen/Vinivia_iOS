//
//  EventsListViewModel.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//  
//

import RxSwift
import RxCocoa

class EventsListViewModel {

    var eventLoading = PublishSubject<Bool>()
    var getEventSuccess = PublishSubject<[Event]>()
    var getEventFailed = PublishSubject<Error>()
    
    func getListEvent() {
        let service = NetworkService()
        eventLoading.onNext(true)
        service.getEvent() { [weak self] result in
            guard let self = self else { return }
            self.eventLoading.onNext(false)
            switch result {
            case .success(let response):
                self.getEventSuccess.onNext(response.data ?? [])
            case .failure(let error):
                self.getEventSuccess.onNext([])
                self.getEventFailed.onNext(error)
            }
        }
    }
    
    func searchListEvent() {
        
    }
}
