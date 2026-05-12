# 简介

Ringtone Kit（铃声服务）是一个用于设置铃声的工具库。通过使用 Ringtone Kit，开发者可以在鸿蒙应用中提供铃声设置的功能，为用户提供简单一致、安全高品质的铃声设置体验。

<div align="center">

### 应用首页

<img src="./screenshots/main.png" width="250"/>

</div>

# 使用说明


1. **输入文件名**：在文本框中输入期望的音频文件名（例如 `test.mp3`）；
2. **模拟生成**：点击 **✅ 生成示例音频** 按钮，触发模拟文件创建逻辑（实际未写入存储，仅更新 UI 状态）；
3. **模拟试听**：点击 **🔊 试听** 按钮，触发模拟播放逻辑（通过 Toast 提示“正在试听: test.mp3”）；
4. **状态反馈**：
    - 输入为空时点击按钮 → 显示 Toast：“请输入文件名！”
    - 成功模拟生成 → Toast：“已模拟生成文件: test.mp3”
    - 成功模拟试听 → Toast：“正在试听: test.mp3”

> 💡 本设计聚焦于**交互闭环与用户体验**：即使无真实音频能力，仍可通过清晰的状态反馈引导用户完成操作流程。
# 工程目录结构

```bash
├──entry/src/main
│  └──ets                           // 代码区
│     ├──entryability
│     │  └──EntryAbility.ets        // 程序入口类
│     └──pages                      // 页面文件
│        └──Index.ets               // 主界面
└──entry/src/main/resources         // 资源文件目录
```

# 约束与限制

1. 本实例仅支持标准系统上运行，支持设备：华为手机、华为平板。
2. HarmonyOS系统：HarmonyOS NEXT Developer Beta3及以上。
3. DevEco Studio版本：DevEco Studio NEXT Developer Beta3及以上。
4. HarmonyOS SDK版本：HarmonyOS NEXT Developer Beta3 SDK及以上。