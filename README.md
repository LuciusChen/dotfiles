# Lucius's dotfiles

按操作系统组织的个人配置文件。

## 结构

```
dotfiles/
├── macos/                # macOS 配置
│   ├── .config/          # Karabiner, WezTerm, Kitty, Starship, BTOp
│   ├── .hammerspoon/     # 窗口管理、快捷键、自动化
│   └── .gnupg/           # GPG agent
│
└── arch/                 # Arch Linux 配置
    ├── home/.config/     # Labwc, Noctalia, Kanshi 等
    ├── home/.local/      # Noctalia GUI 持久化设置等用户状态
    └── etc/              # 系统级配置 (greetd, kanata, sing-box, sysctl.d 等)
```

## 部署

从备份复制配置到系统：

```bash
# macOS
cp -a ~/repos/dotfiles/macos/.config/. ~/.config/
cp -a ~/repos/dotfiles/macos/.hammerspoon ~/.hammerspoon

# Arch
sudo pacman -S --needed pipewire-pulse
systemctl --user enable --now pipewire-pulse.socket
cp -a ~/dotfiles/arch/home/.config/. ~/.config/
install -m 0644 ~/dotfiles/arch/home/.zshrc ~/.zshrc
~/dotfiles/arch/scripts/install-firefox-userjs
~/dotfiles/arch/scripts/install-papirus-icon-theme
sudo ~/dotfiles/arch/scripts/install-sudo-pam-policy
mkdir -p ~/.local/share/applications
cp -a ~/dotfiles/arch/home/.local/share/applications/. ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
mkdir -p ~/.local/state/noctalia
install -m 0644 ~/dotfiles/arch/home/.local/state/noctalia/settings.toml ~/.local/state/noctalia/settings.toml
umask 077
pass show noctalia/storage-key > ~/.local/state/noctalia/storage.key
# arch/etc 下的文件按具体路径用 sudo install 部署，不要整目录覆盖 /etc。
```

## 主要工具

| macOS | Arch |
|-------|------|
| Karabiner + Hammerspoon | Labwc + Noctalia |
| WezTerm | Kitty |
| Starship | Starship |

## Labwc 应用切换器

按住 `Tab` 加字母交给 keydock（源码在 `~/Projects/keydock`）：kanata 用 `kanata_cmd_allowed` 运行，直接执行 `keydock key <字母>`，不经过 labwc 快捷键。已绑定的字母实现“启动、聚焦、隐藏”三态切换，多窗口时一起调出并停在最近使用的窗口，聚焦时鼠标跟随到窗口中心；未绑定的字母会弹出浮层，按数字把已打开的应用绑定上去。`Tab+/` 打开浮层查看所有绑定。绑定写在 `~/.config/keydock/config.toml`，浮层配色由 Noctalia 模板 `keydock.toml` 生成。
keydock 需要单独构建并安装到 `~/.local/bin/keydock`（见其 README）。
微信菜单入口和 `Tab+W` 共用 `wechat-launch`：使用 `wechat-universal-bwrap` 4.1.13.9 的原生 Wayland 后端及 `text-input-unstable-v3` 输入法插件，保留打包器的沙箱和原有数据路径（`~/.xwechat`、`~/Documents/home`、`~/Documents/xwechat_files`）。
启动脚本通过 bwrap 参数设置微信进程的环境，覆盖打包器的 `xcb` 默认值；直接运行系统的 `wechat-universal` 仍使用打包器默认设置。
微信音频使用 `pipewire-pulse`，部署时启用其用户级 socket。启动脚本会创建打包器要求的 `$XDG_RUNTIME_DIR/pulse` 目录，避免重启后音频服务尚未就绪时，沙箱因目录不存在而拒绝启动微信。
2026-09-10 实测：微信 4.1.13.9 在原生 Wayland 下继承系统 `QT_SCALE_FACTOR=0.75` 时仍会缩小窗口但不同比例缩小内部控件，导致登录按钮裁切，因此保留 `QT_SCALE_FACTOR=1`；已移除旧的取整覆盖和字体 DPI 清理设置。
