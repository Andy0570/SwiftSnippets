这里记录 iOS 开发过程中，与 Xcode 相关的常见错误。

Tips: 
* `$(PROJECT_DIR)` 代表的是整个项目
* `$(SRCROOT)` 代表的是项目根目录
* `$(PODS_ROOT)`、`$(SRCROOT)/Pods` 代表的是Pods根目录

---

[TOC]

# Xcode 编译错误

## 查询 Library 报错

错误内容：`"directory not found for option '-L/..."`

解决方法：Project -> targets -> Build Setting -> Library Search Paths 删除该路径。

## 查询 Framework 报错

错误内容：`"directory not found for option '-F/..."`

解决方法：Project -> targets -> Build Setting -> Framework Search Paths 删除该路径。

## Error: Multiple commands produce

错误产生的原因是 Xcode 10 的 New Build System 会对重复元素进行严格检查，以避免不必要的重建。

info.plist 重复错误的解决方法：
Project -> targets -> Build Phases -> Copy Bundle Resources 中移除 info.plist 文件

Copy Pods Resources 重复错误的解决方法：
Project -> targets -> Build Phases -> Copy Pods Resources -> Output Files 中移除：
```bash
${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}
```

## Command PhaseScriptExecution failed with a nonzero exit code

解决方法：跳转到项目的 **TARGETS** - **Build Settings** 页面，搜索关键字 `enable_user` 将 **User Script Sandboxing** 选项设置为 `No`。

参考：[Github: Command PhaseScriptExecution failed with a nonzero exit code #12209](https://github.com/CocoaPods/CocoaPods/issues/12209#issuecomment-1952635494)


## SwiftLint: The file “.swiftlint.yml” couldn’t be opened because you don’t have permission to view it

在 Xcode 14 中，Apple 添加了一个新的 flag `ENABLE_USER_SCRIPT_SANDBOXING`，它告诉编译系统是否阻止脚本阶段（scripts phases）访问源文件或中间构建对象。

回到 Xcode 14（默认情况下），这个标志被设置为 `No`，所以一切正常工作。但是在 Xcode 15 中，这个标志现在被设置为 `Yes`，因此脚本不能访问文件。

解决方法：跳转到项目的 **Targets** - **Build Settings** 页面，搜索 `ENABLE_USER_SCRIPT_SANDBOXING`，将 `User Script Sandboxing` 设置为 `No`。

参考：[How to fix the "The file “.swiftlint.yml” couldn’t be opened because you don’t have permission to view it" issue](https://thisdevbrain.com/swiftlint-permission-issue/)


# PCH 头文件相关

## Error: Build input file cannot be found:

修改 `Info.plist` 或 `PrefixHeader.pch` 路径导致的编译错误。

Project -> Targets -> Build Setting 中搜索并设置：
```bash
$(SRCROOT)/Project/Resource(资源)/Global/PrefixHeader.pch
$(SRCROOT)/Project/Resource(资源)/Global/Info.plist

$(SRCROOT)/SeaTao/Resource/PrefixHeader.pch
```

## Error: '*/*.h' file not found

设置 Header Search Paths

项目 -> TARGETS -> Build Settings -> 搜索栏搜索 header search paths 并设置如下：

```bash
$(PROJECT_DIR)/build/include
```

## Library not found for -ljoperate-ios-2.0.0

JOperate 是极光推送（JPush）中的可选框架，跳转到：

Build Settings - Linking-General - Other Linker Flags 中删除相关项


## 在 Swift 中链接 Bridge 头文件

```bash
# 相对路径
$(SRCROOT)/SwiftExtension/Extensions/MD5-Bridging-Header.h

# 绝对路径
/Users/你的用户名/Desktop/SwiftExtension/SwiftExtension/Extensions/MD5-Bridging-Header.h
```
