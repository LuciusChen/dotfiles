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
    ├── home/.config/     # Hyprland, Waybar, Rofi, Fcitx5, Kitty 等
    └── etc/              # 系统级配置 (keyd, sing-box, ly 等)
```

## 部署

手动创建符号链接：

```bash
# macOS
ln -sf ~/repos/dotfiles/macos/.config/* ~/.config/
ln -sf ~/repos/dotfiles/macos/.hammerspoon ~/.hammerspoon

# Arch
ln -sf ~/repos/dotfiles/arch/home/.config/* ~/.config/
ln -sf ~/repos/dotfiles/arch/home/.zshrc ~/.zshrc
sudo ln -sf ~/repos/dotfiles/arch/etc/* /etc/
```

## 主要工具

| macOS | Arch |
|-------|------|
| Karabiner + Hammerspoon | Hyprland + Waybar |
| WezTerm | Kitty |
| Starship | Starship |
