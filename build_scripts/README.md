# 构建说明

本目录包含用于构建 `simple_live_app` 的脚本（Windows PowerShell 与 macOS bash）。

文件:
- `build_windows.ps1` - 在 Windows 上构建 Release 可执行文件（.exe 与依赖文件）。
- `build_macos.sh` - 在 macOS 上构建 Release `.app` 包。

前提条件：
- 已安装 Flutter，并将 `flutter` 命令加入 PATH。
- Windows: 需安装 Visual Studio（包含 “Desktop development with C++” 工作负载），并在设置中启用 Developer Mode（以支持符号链接）。
- macOS: 需安装 Xcode 与命令行工具。

用法（Windows PowerShell）:

```powershell
# 以仓库根目录运行
./build_scripts/build_windows.ps1 -projectDir .\simple_live_app
```

用法（macOS / bash）:

```bash
chmod +x build_scripts/build_macos.sh
./build_scripts/build_macos.sh
```

构建产物将放在 `simple_live_app/build_artifacts/windows`（或 `.../macos`）中。

常见问题：
- 如果 `flutter pub get` 失败，请检查网络或将 `ns_danmaku` 的依赖改为本地包或注释掉（这是一个从 Git 拉取的包）。
- Windows 构建报错通常与 Visual Studio 未安装或未选择 C++ 工作负载有关。
