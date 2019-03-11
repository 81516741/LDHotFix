fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### ManagerLib
```
fastlane ManagerLib
```
ManagerLib 使用这个航道, 可以快速的对自己的私有库, 进行升级维护

需要传的参数有 版本（tag）  spec的名字（target）  spec库的名字（repo）

可以直接执行脚本./pod_update.sh

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
