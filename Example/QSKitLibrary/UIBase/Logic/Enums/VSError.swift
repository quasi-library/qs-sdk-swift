//
//  VSError.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/10/27.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import Foundation

public enum VSError: Error {
    case requestError, decodeError, parameterError, customError(Int), customErrorMsg(String)
    public var errorStr: String {
        switch self {
        case .requestError:
            return "Network connect error, please try again"
        case .decodeError:
            return "server data error"
        case .parameterError:
            return "Request parameter error"
        case .customError(let code):
            switch code {
            case 1:
                return "error"
            default:
                return "error"
            }
        case .customErrorMsg(let message):
            return message
        }
    }
}
