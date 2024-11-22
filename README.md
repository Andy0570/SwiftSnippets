# SwiftSnippets

[![Platform](https://img.shields.io/badge/platform-ios-lightgrey)](https://developer.apple.com/iphone/)&nbsp;
[![Language](https://img.shields.io/badge/language-swift-orange.svg)](https://www.swift.org/)&nbsp;
[![Lincese](https://img.shields.io/badge/License-MIT-informational)](https://www.apache.org/licenses/LICENSE-2.0.html)&nbsp;
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)&nbsp;


## 目录

- [背景](#背景)
- [功能特点](#功能特点)
- [要求](#要求)
- [上手指南](#上手指南)
- [依赖项](#依赖项)
- [工程结构](#工程结构)
- [如何贡献](#如何贡献)
- [统计信息](#统计信息)
- [许可证](#许可证)


## 背景

一些有用的 Swift 代码片段、包括但不限于页面效果、UI 组件、工具类、设计模式、最佳实践等。


## 功能特点

* [x] Git 存储库 PR 规则遵循 Gitflow 工作流；
* [ ] 使用 [Fastlane](https://fastlane.tools/) 自动化开发流程；
* [ ] 使用 [Travis](https://travis-ci.org/) 为 Github 项目配置持续集成；
* [ ] 使用 [Danger](https://danger.systems/) 为存储库创建 PR 规则；


## 要求

- iOS 15.6+
- Xcode 16.1
- Swift 5.0


## 上手指南

本应用程序使用 `Cocoapods` 进行依赖项的管理。   
请首先参照 [Cocoapods官方网站](https://cocoapods.org/) 的指引进行安装配置（如果您已经安装 `Cocoapods`，可以跳过这一步）。

### 前置要求

本项目目前暂未使用任何第三方 SDK，但出于演示目的，以后可能会逐步集成相关使用示例。

### 安装
请通过以下步骤进行安装，在终端执行如下命令：

``` bash
# 将项目克隆到本地
git clone https://github.com/Andy0570/SwiftSnippets.git

# 定位到工程目录内
cd SwiftSnippets

# 安装组件
pod install

# 使用 Xcode 打开当前项目
xed .
```


## 依赖项

| 项目                                                        | 描述                         |
| ----------------------------------------------------------- | ---------------------------- |
| Alamofire                                                   | HTTP 网络框架                |
| SwiftyJSON                                                  | 高效的处理JSON数据格式       |
| [Kingfisher](https://github.com/onevcat/Kingfisher)         | 网络图片缓存与多种附加功能。 |
| [SwiftGen](https://github.com/SwiftGen/SwiftGen)            | 项目资产管理                 |
| [SwiftLint](https://github.com/realm/SwiftLint)             | 代码格式校验                 |
| [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) |                              |
| [Dollar](https://github.com/ankurp/Dollar)                  |                              |
| ...                                                         |                              |

更多依赖项，请查看 [Podfile](https://github.com/Andy0570/SwiftSnippets/blob/main/Podfile)。




## 工程结构
基本的工程结构文件树如下。

```
SwiftSnippets 
├── SwiftSnippets
│   ├── /Vars  #全局变量
│   ├── /Enums  #枚举声明（包括了一些非真实数据）
│   ├── /Application
│   │   ├── AppCredential  #授权凭证
│   │   ...
│   │   └── UserManager  #用户管理
│   ├── /Utils  #工具
│   │   ├── /BlurHash  #照片加载模糊效果
│   │   ├── ColorPalette  #全局颜色
│   │   ├── AnimatorTrigger  #动画效果
│   │   └── MessageCenter  #通知栏
│   │── /Extension  #扩展
│   │── /Services  #服务
│   │   ├── /Authentication  #授权相关请求
│   │   └── /Network  #数据相关请求
│   │── /Components  #视图类
│   │── /ViewModels  #视图模型类
│   │── /ViewControllers  #视图控制器类
│   │── /Models  #数据模型类
│   │── /Coordinators  #页面跳转
│   └── /Resource  #资源文件
└── Pods

```


## 如何贡献

欢迎任何贡献，有关如何参与到本项目的信息，请参见 [CONTRIBUTING](./CONTRIBUTING.md)。


## 统计信息

![Alt](https://repobeats.axiom.co/api/embed/f00690f55cadbe3ee09e90846efa7fde060277f0.svg "Repobeats analytics image")


## 许可证
本项目基于 [MIT](https://opensource.org/licenses/MIT) 许可协议，详情请参见 [LICENSE](./LICENSE)。