# Mac Message Backup

一款专为 macOS 设计的 iMessage 和通话记录备份工具。它可以将您的信息和通话记录安全地备份到 Gmail (IMAP) 或同步到日历，拥有原生的 macOS 界面和极速的备份性能。

![App Icon](MacMessageBackup/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png)

## 主要功能

*   **iMessage & 短信备份**：将本地 `chat.db` 中的所有短信和 iMessage 备份到 Gmail，支持附件和完整对话内容。
*   **通话记录备份**：将通话记录备份到 Gmail，保留通话时长、类型（呼入/呼出）等元数据。
*   **日历同步**：将通话记录同步到 macOS 本地日历，方便在日历视图中回顾通话历史。
*   **极速备份引擎**：
    *   内置 Python 批量处理引擎，通过复用 IMAP 连接大幅提升备份速度。
    *   无需频繁握手，支持每秒处理数百条记录。
*   **原生 macOS 体验**：
    *   **菜单栏常驻**：在菜单栏实时显示备份进度（如 "正在备份 52/460"），不占用 Dock 空间。
    *   **完全后台运行**：点击菜单栏即可快速开始或取消备份。
    *   **权限自动管理**：自动检测并引导用户授予“完全磁盘访问权限”（用于读取 iMessage 数据库）。
*   **断点续传**：自动记录备份进度，中断后可从上次停止的位置继续备份，无需从头开始。

## 技术特点

*   **SwiftUI + AppKit**：采用现代 SwiftUI 构建界面，结合 AppKit 实现底层系统交互。
*   **Python 集成**：利用 Python 的 `imaplib` 处理复杂的 IMAP 协议交互，实现高效的批量上传。
*   **SQLite 直接读取**：直接读取 macOS 系统数据库 (`chat.db`, `CallHistory.storedata`)，确保数据完整性。
*   **安全**：
    *   密码存储在 macOS 钥匙串 (Keychain) 中。
    *   直接与 Gmail 通信，无中间服务器。

## 安装与运行 requirements

*   macOS 13.0 (Ventura) 或更高版本
*   Xcode 14+ (用于编译)
*   Python 3 (macOS 内置即可)

### 编译步骤

1.  克隆项目：
    ```bash
    git clone https://github.com/yourusername/MacMessageBackup.git
    cd MacMessageBackup
    ```
2.  打开 `MacMessageBackup.xcodeproj`。
3.  确保 Signing & Capabilities 中选择了你的开发团队。
4.  点击 Run (或 Cmd+R) 运行。

## 隐私说明

本项目**仅**在本地运行。
*   **不收集**任何用户数据。
*   **不上传**数据到任何第三方服务器（除了用户自己配置的 Gmail）。
*   所有数据库读取操作均在用户授权下进行。

## 许可证

MIT License
