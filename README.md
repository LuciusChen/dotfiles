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
    └── etc/              # 系统级配置 (greetd, keyd, sing-box, sysctl.d 等)
```

## 部署

从备份复制配置到系统：

```bash
# macOS
cp -a ~/repos/dotfiles/macos/.config/. ~/.config/
cp -a ~/repos/dotfiles/macos/.hammerspoon ~/.hammerspoon

# Arch
cp -a ~/dotfiles/arch/home/.config/. ~/.config/
install -m 0644 ~/dotfiles/arch/home/.zshrc ~/.zshrc
mkdir -p ~/.local/share/applications
update-desktop-database ~/.local/share/applications
mkdir -p ~/.local/state/noctalia
install -m 0644 ~/dotfiles/arch/home/.local/state/noctalia/settings.toml ~/.local/state/noctalia/settings.toml
# arch/etc 下的文件按具体路径用 sudo install 部署，不要整目录覆盖 /etc。
```

## 主要工具

| macOS | Arch |
|-------|------|
| Karabiner + Hammerspoon | Labwc + Noctalia |
| WezTerm | Kitty |
| Starship | Starship |

## Labwc 应用切换器

`Win+C/G/W/R` 使用 `wlrctl` 实现“启动、聚焦、隐藏”三态切换；聚焦已有窗口时，鼠标会跟随到窗口中心。
由于上游 `wlrctl focus` 不会解除最小化，需要构建用户级 helper：

```bash
~/dotfiles/arch/scripts/build-wlrctl-focus-helper
```
