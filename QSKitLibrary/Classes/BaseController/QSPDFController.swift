//
//  VSPDFController.swift
//  QuasiDemo
//
//  Created by Soul on 2023/4/14.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import PDFKit

/// 加载pdf url的页面
class VSPDFController: QSBaseViewController {
    // MARK: - Property
    private var mPdfTitle = ""
    private var mPdfLink: URL?
    private var mPdfDocument: PDFDocument?

    // MARK: - LifeCycle Method
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// 构造方法
    init(
        pdfTitle: String?,
        pdfLink: String
    ) {
        super.init()

        if let pdfTitle {
            self.mPdfTitle = pdfTitle
        }
        self.mPdfLink = URL(string: pdfLink)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.mPdfTitle
        // Do any additional setup after loading the view.

        view.addSubview(progressView)
        progressView.center = view.center

        // 默认加载时间比较长，展示菊花图
        progressView.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        if let url = self.mPdfLink {
            self.view.backgroundColor = .appBackgroundPage

            DispatchQueue.global().async {
                let document = PDFDocument(url: url)
                self.mPdfDocument = document
                DispatchQueue.main.async {
                    self.pdfWebView.document = document
                    self.progressView.stopAnimating()
                }
            }
        } else {
            self.view.backgroundColor = .appBackgroundList
            self.pdfWebView.document = self.mPdfDocument
            self.progressView.stopAnimating()
        }
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        view.addSubview(pdfWebView)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        pdfWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - UI Action Method

    // MARK: - Private Method

    // MARK: - Lazy Method

    lazy var progressView: UIActivityIndicatorView = {
        // 创建UIActivityIndicatorView
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)

        // 设置位置和大小
        activityIndicatorView.hidesWhenStopped = true

        return activityIndicatorView
    }()

    private lazy var pdfWebView: PDFView = {
        let _pdfView = PDFView()
        _pdfView.delegate = self

        return _pdfView
    }()
}

extension VSPDFController: PDFViewDelegate {
}
