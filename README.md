# Lucius's dotfiles

macOS 和 Arch Linux 的个人配置。两边没有共享文件：同名工具（zsh、kitty、Starship、邮件、GPG）也各有一份，内容不同。

## 两边对照

| 用途 | macOS | Arch | 共用 |
|---|---|---|---|
| 编辑器 | Emacs (emacs-plus) | Emacs (emacs-pgtk) | [.emacs.d](https://github.com/LuciusChen/.emacs.d)、[ashen](https://github.com/LuciusChen/ashen) 主题 |
| 输入法 | 鼠须管 | Fcitx5 | Rime 方案，经 Dropbox 同步 |
| 终端 | WezTerm、kitty | kitty | |
| 窗口和快捷键 | Karabiner + Hammerspoon | labwc + kanata + [keydock](https://github.com/LuciusChen/keydock) | |
| 桌面 | | Noctalia | |
| 命令行 | zsh、Starship | zsh、Starship | |

Emacs 在两边都跟随系统深浅色，代码在 `.emacs.d` 的 `lib/lib-ui.el`。

## macOS

```
macos/
├── .zshrc 等         # zsh、邮件 (mbsync, msmtp)、git、vim、Maven
├── .config/          # Karabiner, WezTerm, kitty, Starship, btop, emacs-plus
├── .hammerspoon/     # 窗口管理、快捷键、自动化
├── .gnupg/           # GPG agent
└── brew.sh           # Homebrew 包
```

```bash
cp -a ~/repos/dotfiles/macos/.config/. ~/.config/
cp -a ~/repos/dotfiles/macos/.hammerspoon ~/.hammerspoon
```

## Arch

```
arch/
├── home/             # zsh、邮件 (mbsync, msmtp)、GPG
├── home/.config/     # labwc, Noctalia, Kanshi, kitty, Fcitx5, keydock 等
├── home/.local/      # Fcitx5 主题、Noctalia 插件和 GUI 设置等
├── etc/              # 系统级配置 (greetd, kanata, sing-box, sysctl.d 等)
├── usr/local/        # labwc 会话入口、sudo 的 PAM 辅助脚本
├── firefox/          # Firefox user.js
├── scripts/          # 安装 Firefox user.js、Papirus 图标
├── pkglist.txt       # 手动安装的官方源和 archlinuxcn 包
└── pkglist-aur.txt   # 手动安装的 AUR 包
```

### 部署

```bash
cp -a ~/dotfiles/arch/home/. ~/
chmod 700 ~/.gnupg
update-desktop-database ~/.local/share/applications
~/dotfiles/arch/scripts/install-firefox-userjs
~/dotfiles/arch/scripts/install-papirus-icon-theme
umask 077
pass show noctalia/storage-key > ~/.local/state/noctalia/storage.key

# 系统文件逐个安装，保留仓库里的权限，不整目录覆盖 /etc。
cd ~/dotfiles/arch && git ls-files etc usr | grep -v README | while read -r f; do
  sudo install -Dm"$(stat -c %a "$f")" "$f" "/$f"
done
```

### 重装

重装系统时，在部署之外按顺序补这些步骤：

1. 在 `/etc/pacman.conf` 末尾加 archlinuxcn 源，再装 keyring：

   ```ini
   [archlinuxcn]
   Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
   ```

   ```bash
   sudo pacman -Sy archlinuxcn-keyring
   ```

2. 按清单装包：

   ```bash
   sudo pacman -S --needed - < ~/dotfiles/arch/pkglist.txt
   yay -S --needed - < ~/dotfiles/arch/pkglist-aur.txt
   ```

   清单只收手动安装的包。顺带装上的库用 `sudo pacman -D --asdeps <包>` 标成依赖，再更新清单：

   ```bash
   pacman -Qqen > ~/dotfiles/arch/pkglist.txt
   pacman -Qqem > ~/dotfiles/arch/pkglist-aur.txt
   ```

3. 从私有仓库恢复 GPG 私钥，再按“部署”复制配置。`pass` 依赖这把私钥。
4. sing-box 的私有订阅地址 `/etc/sing-box/profile-url` 不在仓库里，需要单独恢复（见 `arch/etc/sing-box/README.org`）。
5. 启用系统服务：

   ```bash
   sudo systemctl enable greetd kanata NetworkManager bluetooth power-profiles-daemon \
     systemd-resolved systemd-timesyncd sshd tailscaled sing-box accounts-daemon \
     fstrim.timer sing-box-profile-update.timer
   ```

6. 开机画面：systemd-boot 启动项的 `options` 加上 `zswap.enabled=0 console=tty1 vt.global_cursor_default=0 quiet loglevel=3 rd.udev.log_level=3 splash`，`loader.conf` 设 `timeout 0`（按住空格显示菜单）；`mkinitcpio.conf` 的 `HOOKS` 在 `systemd` 后加 `plymouth`，再运行 `sudo plymouth-set-default-theme bgrt && sudo mkinitcpio -P`。交换用 zram，所以关掉 zswap。
7. 充电阈值：启用 upower 的 75–80% 充电阈值。

   ```bash
   busctl call org.freedesktop.UPower /org/freedesktop/UPower/devices/battery_BAT0 \
     org.freedesktop.UPower.Device EnableChargeThreshold b true
   ```

8. Dropbox 用官方程序装到 `~/.dropbox-dist`，登录并等待同步完成。
9. Rime：把 `~/Dropbox/Squirrel/rime-rice/` 中除 `installation.yaml` 外的文件复制到 `~/.local/share/fcitx5/rime/`，`installation.yaml` 设 `installation_id: "rime-rice"` 和 `sync_dir: "/home/lucius/Dropbox/Squirrel"` 后同步。同步只导回词库，`*.custom.yaml` 要手动复制。
10. 克隆 [.emacs.d](https://github.com/LuciusChen/.emacs.d) 到 `~/.emacs.d`，首次启动 Emacs 时 straight 会装好其余的包。
11. 克隆 [keydock](https://github.com/LuciusChen/keydock) 到 `~/Projects/keydock`，构建并安装到 `~/.local/bin/keydock`（见其 README）。
12. 用 `fprintd-enroll` 重新录入指纹。

### 按键

- `Tab` + 字母：启动、聚焦或隐藏绑定的应用；`Tab` + 数字：切到未绑定的已打开应用（[keydock](https://github.com/LuciusChen/keydock)）。
- `Tab+;` + `h`/`l`/`k`/`j`：贴左、贴右、最大化、居中；`Tab+[`/`]`：把窗口移到桌面 1/2。
- `Super+`` `：切换同一应用的其他窗口，可以跨桌面。
- 按住 `Tab`、`;` 或 `Super`：显示这一层的键位图。

应用绑定在 `~/.config/keydock/config.toml`。改了 `rc.xml` 的 `Super` 快捷键，要同步改 kanata 的 `super` 层和 keydock 的提示文字。kanata 用 `kanata-bin` 的 `kanata_cmd_allowed` 运行命令。

### 深浅色

状态栏的主题按钮或 `noctalia msg theme-mode-toggle` 切换整个桌面，Emacs、Fcitx5 和 Firefox 跟随系统。

- 手动设置：Firefox 启用 “System theme — auto”，Dark Reader 设为跟随系统；登录界面需要时运行 `noctalia greeter-sync`。
- 配色抄自 [Ashen](https://github.com/LuciusChen/ashen)，改了要同步 `Ashen.json` 和两个 OriHope 主题。kitty 的浅色背景故意和 Emacs 差一级。

### 微信

`Tab+W` 和菜单入口都通过 `labwc/scripts/wechat-launch` 以原生 Wayland 启动，各项设置的原因见脚本注释。
