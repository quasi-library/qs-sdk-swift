//
//  VSTableViewCell.swift
//  QuasiDemo
//
//  Created by Soul on 2023/4/19.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

open class QSTableViewCell: UITableViewCell {
    // MARK: - Init Method
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.addSubSnaps()
        self.layoutSnaps()
    }

    // MARK: - UI Layout Method
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    open func addSubSnaps() {
    }

    open func layoutSnaps() {
    }

    // MARK: - UI Action Method

    // MARK: - Lazy Method
}
