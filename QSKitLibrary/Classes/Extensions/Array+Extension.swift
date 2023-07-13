//
//  Array+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/11/25.
//

import Foundation

extension Array {
    func objectOfIndex(_ index: Int) -> Any? {
        if index > (count - 1) {
            return nil
        }
        return self[index]
    }
}
