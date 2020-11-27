# swager_to_dart

🛠 用于 Spring Boot 的 Swager 到其他语言 API 与 Model 生成工具

⚠ WINDOWS ONLY
⚠ DART ONLY

其他语言支持请修改模板生成部分代码

其他平台需要自己改环境, 截止到 11.11.2020, `shared_preferences` 尚未正式支持` Windows` 与 `Mac OS`
支持后可移除 json 文件的写入并使用 `shared_preferences` 保存偏好

## Requirements

### 编译需求-Windows

- Windows 10 SDK (10.0.17763.0)
- MSVC 142

建议使用 `Visual Studio` 安装 C++环境与 Windows SDK

## Notice

由于当前 Windows 无法编译到 `Release` 版本, 所以使用环境需要有 `Debug Runtime`

## Usage

- 顶部 API 栏输入 swager api json 地址
- 第二行地址栏右边按钮选择保存位置, 建议直接放到项目下, API 更新后会覆盖原有 API
- 右边模板用于生成 API

### API Template

占位符用 `$$` 表示

#### 可用占位符

- `Summary` 注释
- `ReturnType` 返回值类型
- `GeneratedApiName` swager 返回的方法名
- `ApiParameters` 适合 `dart` 的方法参数, 就像下面这样

```dart
 {@required String param}
```

- `ApiUrl` 不带有域名的 api 地址
- `ApiParametersMap` 适合 `dart` 的 Post 方法参数, 就像下面这样

```dart
 {"param":param}
```

## 具体用例请参照 [paibei](http://gitlab.netmi.com.cn/FlutterProject/paibei) 项目
