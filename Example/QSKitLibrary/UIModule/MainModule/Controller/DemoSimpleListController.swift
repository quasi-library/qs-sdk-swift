//
//  DemoSimpleListController.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import Foundation
import QSKitLibrary

class DemoSimpleListController: QSBaseViewController {
    // MARK: - Property

    // MARK: - LifeCycle Method
    //    required init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = String(describing: type(of: self))
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Bind Method
    private let mViewModel = DemoSimpleListViewModel()
    override func bindViewModel() {
        super.bindViewModel()

        // 监听报错信息用于toast展示
        mViewModel.errorDataSubject
            .subscribe(with: self) { weakself, errMessage in
                debugPrint(weakself, "接收到报错信息 \n", errMessage as Any)
            }
            .disposed(by: mDisposeBag)
    }


    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        self.view.addSubview(listView)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        listView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    // MARK: - UI Action Method

    // MARK: - Private Method

    // MARK: - Lazy Method
    private let kCellId = "CartItemCell"
    private lazy var listView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .appBackgroundList
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.sectionHeaderHeight = 0.01
        table.register(
            DemoEntryItemCell.self,
            forCellReuseIdentifier: kCellId
        )
        table.layer.cornerRadius = 2
        table.clipsToBounds = true

        return table
    }()
}

extension DemoSimpleListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        mViewModel.mDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: kCellId,
            for: indexPath
        ) as? DemoEntryItemCell else {
            return UITableViewCell()
        }

        let entryModel = mViewModel.mDataSource[indexPath.row]
        cell.loadItemModel(entryModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entryModel = mViewModel.mDataSource[indexPath.row]
        switch entryModel {
        case .testButton:
            let buttonVc = ExampleButtonController()
            self.navigationController?.show(buttonVc, sender: nil)
        case .testSliderDouble:
            let sliderVc = ExampleDoubleSliderController()
            self.navigationController?.show(sliderVc, sender: nil)
        }
    }
}
