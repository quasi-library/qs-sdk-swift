# QSKitLibrary

[![CI Status](https://img.shields.io/travis/soulstayreal@gmail.com/QSKitLibrary.svg?style=flat)](https://travis-ci.org/soulstayreal@gmail.com/QSKitLibrary)
[![Version](https://img.shields.io/cocoapods/v/QSKitLibrary.svg?style=flat)](https://cocoapods.org/pods/QSKitLibrary)
[![License](https://img.shields.io/cocoapods/l/QSKitLibrary.svg?style=flat)](https://cocoapods.org/pods/QSKitLibrary)
[![Platform](https://img.shields.io/cocoapods/p/QSKitLibrary.svg?style=flat)](https://cocoapods.org/pods/QSKitLibrary)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

支持通过swift lint自动格式化代码，在[SwiftLint](Example/.swiftlint.yml)配置规则。

```shell
# 支持通过 homebrew 安装
brew install swiftlint
```

在Build Phases 中Run Swift Lint Script

```ruby
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftlint > /dev/null; then
  swiftlint --fix --no-cache --config "${PROJECT_DIR}/.swiftlint.yml"
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

## Installation

QSKitLibrary is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QSKitLibrary'
```

## Author

soulstayreal@gmail.com

## License

QSKitLibrary is available under the MIT license. See the LICENSE file for more info.
