//
//  ViewController.swift
//  RateCalulator
//
//  Created by Emil Marashliev on 1.12.17.
//  Copyright © 2017 ReceiptBank. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RateViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = RateTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.cellViewModels.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "RateTableViewCell")) { index, model, cell in
                let rateCell = cell as! RateTableViewCell
                rateCell.currencyName.text = model.code
                (rateCell.rate.rx.text <-> model.value)
                    .disposed(by: rateCell.disposeBag)
            }
            .disposed(by: disposeBag)

        setupItemSelected()
        setupItemDeselected()
        
        viewModel.initialFetch()
        viewModel.fetching()
    }
    
    private func setupItemSelected() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
//                guard indexPath.row != 0 else { return }
                let cell = self.tableView.cellForRow(at: indexPath) as! RateTableViewCell
                self.viewModel.selectedCurrency.value = cell.currencyName.text ?? ""
                cell.rate.isEnabled = true
                self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                cell.rate.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupItemDeselected() {
        tableView.rx.itemDeselected
            .subscribe(onNext: { indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as! RateTableViewCell
                cell.rate.isEnabled = false
            })
            .disposed(by: disposeBag)
    }
}

