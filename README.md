# 自定义 QML 控件库框架

该仓库提供了一个可扩展的自定义 QML 控件库框架，用于在 Qt Quick 项目中快速搭建带有主题与多语言能力的组件体系。框架强调 **QML 与 JS 对应** 的结构，每个控件都配套一个负责业务逻辑或样式计算的 JS 文件，便于在不破坏 UI 声明的情况下复用逻辑。

## 目录结构

```
YunPan/
├── qml/
│   └── CustomControls/
│       ├── qmldir                     # QML 模块导出定义
│       ├── Controls/                  # 具体控件实现
│       │   ├── Buttons/
│       │   │   ├── PrimaryButton.qml
│       │   │   └── PrimaryButtonLogic.js
│       │   ├── Indicators/
│       │   │   ├── LoadingSpinner.qml
│       │   │   └── LoadingSpinnerLogic.js
│       │   └── Labels/
│       │       ├── TitleLabel.qml
│       │       └── TitleLabelLogic.js
│       ├── Theme/                     # 主题管理与主题数据
│       │   ├── ThemeManager.qml
│       │   └── ThemeData.js
│       └── I18n/                      # 多语言管理与语言资源
│           ├── I18nManager.qml
│           └── I18nData.js
└── examples/
    └── gallery/
        └── main.qml                   # 控件库示例与主题/语言切换演示
```

## 功能特性

- **主题一键切换**：`ThemeManager` 单例维护当前主题与可用主题列表，JS 中的 `ThemeData` 负责定义主题色板与 token 解析。控件利用 `ThemeManager.revision` 作为轻量级变更标记，只在修订号变化时重新构建状态颜色表，再通过属性绑定在悬停、按压等状态间切换，避免在窗口拖动等几何变动时反复执行 JS 查找。
- **多语言一键切换**：`I18nManager` 单例提供当前语言与翻译函数，所有控件通过访问该单例实现文本的动态刷新。`I18nData.js` 暴露 `registerTranslations()` 供每个控件或业务模块按需注册自己的词条，并内置英文与简体中文示例；组件绑定 `I18nManager.revision` 来更新缓存的翻译字符串，从而在语言切换时即时刷新，又不会在其他交互阶段造成额外的 JS 计算开销。
- **QML/JS 对应结构**：每个控件都拆分为 QML 与 JS 两部分，QML 负责声明式界面，JS 专注样式计算与状态逻辑，方便后续复用或替换。
- **轻量级加载动画**：自研的 `LoadingSpinner` 基于 `QtQuick.Shapes` 绘制圆弧并通过旋转/透明度动画驱动，相比默认 `BusyIndicator` 或自绘 `Canvas` 方案更节省 CPU/GPU，拖动与缩放窗口时依旧保持流畅，可在任何需要加载态的控件中复用。
- **示例应用**：`examples/gallery/main.qml` 演示了如何在 `ApplicationWindow` 中引入控件库并通过按钮切换主题与语言。

## 使用方法

1. **配置 QML 模块搜索路径**

   在运行示例或集成至现有项目时，需要将 `qml` 目录加入 `QML2_IMPORT_PATH`，例如：

   ```bash
   export QML2_IMPORT_PATH="$(pwd)/qml"
   qmlscene examples/gallery/main.qml
   ```

   或者在 CMake / qmake 工程中将 `qml/` 添加到 `QML_IMPORT_PATH`。

2. **使用 Python 启动示例窗口**

   如果更习惯以 Python 方式运行，可安装 [PySide6](https://doc.qt.io/qtforpython/)、[PyQt6](https://riverbankcomputing.com/software/pyqt/intro)、[PySide2](https://wiki.qt.io/Qt_for_Python/GettingStarted) 或 [PyQt5](https://riverbankcomputing.com/software/pyqt/intro) 并使用仓库中提供的脚本：

   ```bash
   pip install PySide6  # 也可以安装 PyQt6 / PySide2 / PyQt5
   python examples/gallery/run.py
   ```

   脚本会自动将仓库根目录下的 `qml/` 加入 QML 导入路径，然后载入 `examples/gallery/main.qml` 展示控件库；如果上述库均未安装，则会提示安装命令或改用 `qmlscene` 运行，并在加载失败时输出详细的 QML 警告信息，便于排查问题。

3. **扩展主题**

   - 在 `ThemeData.js` 中新增主题条目并补充色板。
   - 通过 `ThemeManager.availableThemes()` 获取主题名称列表，并利用 `ThemeManager.setTheme("yourTheme")` 切换。

4. **扩展语言**

   - 调用 `I18nData.registerTranslations("langCode", { ... })` 注册控件或业务模块的词条；每个控件的 JS 逻辑文件都可以在加载时自动注册自己的翻译，从而避免集中维护庞大的字典。
   - 调用 `I18nManager.setLanguage("langCode")` 即可切换到目标语言。

5. **新增控件**

   - 在 `Controls` 目录中创建对应的 QML 文件与 JS 文件，遵循现有命名方式（例如 `XxxControl.qml` 与 `XxxControlLogic.js`）。控件内部建议缓存翻译与主题色值，并在语言/主题切换信号触发时刷新，以提升交互时的流畅度。
   - 在 `qmldir` 文件中注册新的控件类，便于外部通过 `import CustomControls 1.0 as Custom` 引入。

## 后续建议

- 若需要打包为 Qt 插件，可继续扩展 `qmldir`，或通过 C++ 插件注册类型。
- 可结合 `Qt.labs.settings` 将用户选择的主题/语言持久化。
- 进一步完善 CI 或单元测试（例如使用 `qmltestrunner`）。

欢迎在此框架基础上继续扩展更多复杂控件与业务逻辑。
