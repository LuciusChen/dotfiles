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
    ├── etc/              # 系统级配置 (greetd, kanata, sing-box, sysctl.d 等)
    ├── pkglist.txt       # 手动安装的官方源和 archlinuxcn 包
    └── pkglist-aur.txt   # 手动安装的 AUR 包
```

## 部署

从备份复制配置到系统：

```bash
# macOS
cp -a ~/repos/dotfiles/macos/.config/. ~/.config/
cp -a ~/repos/dotfiles/macos/.hammerspoon ~/.hammerspoon

# Arch
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

## Arch 重装

在上面“部署”之外，重装系统时按顺序补这些步骤：

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

6. 开机画面：systemd-boot 启动项的 `options` 加上 `zswap.enabled=0 console=tty1 vt.global_cursor_default=0 quiet loglevel=3 rd.udev.log_level=3 splash`，`/boot/loader/loader.conf` 设 `timeout 0`（开机按住空格显示菜单）。`/etc/mkinitcpio.conf` 的 `HOOKS` 在 `systemd` 后加 `plymouth`，再 `sudo plymouth-set-default-theme bgrt && sudo mkinitcpio -P`。系统用 zram-generator 做内存交换，所以关闭 zswap；其余参数让开关机只显示 Lenovo 标志，greetd 在同一个 tty1 上接着显示登录界面（关机静默见 `arch/etc/systemd/system.conf.d/quiet-shutdown.conf`）。
7. 充电阈值：启用 upower 的 75–80% 充电阈值。

   ```bash
   busctl call org.freedesktop.UPower /org/freedesktop/UPower/devices/battery_BAT0 \
     org.freedesktop.UPower.Device EnableChargeThreshold b true
   ```

8. Dropbox 用官方程序装到 `~/.dropbox-dist`，登录并等待同步完成。
9. Rime：把 `~/Dropbox/Squirrel/rime-rice/` 里除 `installation.yaml` 外的文件复制到 `~/.local/share/fcitx5/rime/`。再在 `installation.yaml` 中设置 `installation_id: "rime-rice"` 和 `sync_dir: "/home/lucius/Dropbox/Squirrel"`，重新部署并同步。Rime 同步只会自动导回用户词库，`*.custom.yaml` 必须手动复制。
10. 构建 keydock 并安装到 `~/.local/bin/keydock`（见其 README）。
11. 用 `fprintd-enroll` 重新录入指纹。

## 主要工具

| macOS | Arch |
|-------|------|
| Karabiner + Hammerspoon | Labwc + Noctalia |
| WezTerm | Kitty |
| Starship | Starship |

## 应用切换（keydock）

按住 `Tab` 加字母交给 keydock（源码在 `~/Projects/keydock`）：kanata 直接执行 `keydock key <字母>`，不经过 labwc 快捷键。已绑定的字母实现“启动、聚焦、隐藏”三态切换，只作用于当前 workspace 的窗口，一起调出并停在最近使用的窗口；当前 workspace 没有时跳到它最近所在的 workspace。同一应用的其他窗口用 `Super+`` 切换，可以跨 workspace，新窗口从 launcher 打开。聚焦时鼠标跟随到窗口中心；未绑定的字母会弹出键盘图，按数字把已打开的应用绑定上去。没有绑定字母的已打开应用按最近使用排在数字键上，`Tab+1` 到 `Tab+9` 直接切换，编号会随使用变化。绑定写在 `~/.config/keydock/config.toml`，配色由 Noctalia 模板 `keydock.toml` 生成。

按住 `Tab`、`;` 或 `Super` 稍等片刻，会浮出键盘图显示这一层每个键的作用，松开或按下层里的键就消失；`Tab` 加 `;` 显示窗口操作，所以用 `Tab` 打开应用后不用换手就能摆放窗口：`h`/`l` 贴左右，`k` 最大化，`j` 把窗口居中并缩到屏幕宽高各一半，再按一次恢复；最小化由 `Tab` 加字母的隐藏代替。`Tab+[` 和 `Tab+]` 把窗口移到桌面 1 和 2 并跟过去。提示文字写在同一个配置文件的 `[[layer]]` 里并跟随系统语言，所以 `Super` 层改了 `rc.xml` 后，要同步改 kanata 的 `super` 层和这里的文字。插着 Corne 时自动显示 Corne 布局。
kanata 服务使用 `kanata-bin` 包里允许执行命令的 `kanata_cmd_allowed`，配置中开启了 `danger-enable-cmd`。

## 微信

微信菜单入口和 `Tab+W` 共用 `wechat-launch`：使用 `wechat-universal-bwrap` 4.1.13.9 的原生 Wayland 后端及 `text-input-unstable-v3` 输入法插件，保留打包器的沙箱和原有数据路径（`~/.xwechat`、`~/Documents/home`、`~/Documents/xwechat_files`）。
启动脚本通过 bwrap 参数设置微信进程的环境，覆盖打包器的 `xcb` 默认值；直接运行系统的 `wechat-universal` 仍使用打包器默认设置。
启动脚本会创建打包器要求的 `$XDG_RUNTIME_DIR/pulse` 目录，否则沙箱因目录不存在而拒绝启动微信。
微信 4.1.13.9 在原生 Wayland 下继承系统的 `QT_SCALE_FACTOR=0.75` 时，窗口缩小但内部控件不同比例缩小，登录按钮会被裁切，因此启动脚本设置 `QT_SCALE_FACTOR=1`。
