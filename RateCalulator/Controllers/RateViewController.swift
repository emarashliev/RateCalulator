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
import Differentiator

class RateViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = RateTableViewModel()
    private var bining: Disposable?
    private var customDataSource: RxTableViewSectionedAnimatedDataSource<Section>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customDataSource = setupDataSource()
        bining = viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: customDataSource!))
        
        setupItemSelected()
        setupItemDeselected()
        
        viewModel.fetching()
    }
    
    private func setupDataSource() -> RxTableViewSectionedAnimatedDataSource<Section>? {
        return RxTableViewSectionedAnimatedDataSource<Section>(
            configureCell: { dataSource, tableView, indexPath, item in
                let rateCell = tableView.dequeueReusableCell(withIdentifier: "RateTableViewCell", for: indexPath)
                    as! RateTableViewCell
                rateCell.currencyName.text = item.code
                rateCell.rate.text =  item.rate.description
                rateCell.rate.rx.text.asDriver()
                    .drive(onNext: { text in
                        
                    })
                    .disposed(by: rateCell.disposeBag)
                return rateCell
        },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
        })
    }
    
    private func setupItemSelected() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                guard indexPath.section != 0 else { return }
                self.viewModel.timer?.dispose()
                let cell = self.tableView.cellForRow(at: indexPath) as! RateTableViewCell
                self.viewModel.selectedCurrency =
                    self.viewModel.sections.value[indexPath.section].items[indexPath.row].code
                cell.rate.isEnabled = true
                self.tableView.beginUpdates()
                self.tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
                self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                self.tableView.endUpdates()
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

