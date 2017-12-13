//
//  RateTableViewModel.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 5.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import Foundation
import RxSwift
import Differentiator

final class RateTableViewModel {
    
    
    let selectedCurrency = Variable("EUR")
    let selectedCellModelView = Variable<RateCellViewModel?>(nil)
    let cellViewModels = Variable([RateCellViewModel]())
    private let disposeBag = DisposeBag()
    private let disposecellViewModels = DisposeBag()

    
    func fetching() {
        Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .flatMap { [unowned self] _ in
                return Currency.all(with: self.selectedCurrency.value)
            }
            .subscribe { [unowned self] event in
                switch event {
                case .next(let currencies):
                    _ = currencies.map({ currency in
                        let modelView = self.getCellViewModel(by: currency.code)
                        modelView?.base = currency.rate
                        if let multiplier = self.selectedCellModelView.value?.amount.value {
                            modelView?.multiplier = NSDecimalNumber(string: (multiplier.count > 0) ? multiplier : "0")
                        }
                    })
                case .error(let error):
                    print(error.localizedDescription)
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func initialSetup() {
        let defaultSelectedCellViewModel = RateCellViewModel(with: Currency(code: self.selectedCurrency.value, rate: 1))
        Currency.all(with: self.selectedCurrency.value)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .subscribe { [unowned self] event in
                switch event {
                case .next(let currencies):
                    self.cellViewModels.value = currencies.map { currency in
                        RateCellViewModel(with: currency)
                    }
                    self.cellViewModels.value.insert(defaultSelectedCellViewModel, at: 0)
                case .error(let error):
                    print(error.localizedDescription)
                case .completed:
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        selectedCurrency.asObservable()
            .subscribe(onNext: { [unowned self] code in
                if let cellViewModel = self.getCellViewModel(by: code) {
                    self.selectedCellModelView.value = cellViewModel
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func getCellViewModel(by code: String) -> RateCellViewModel? {
        return self.cellViewModels.value.filter { cellViewModel in
            cellViewModel.code == code
            }.first
    }
    
}
