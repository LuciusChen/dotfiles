
## 终端配置

### ohmyzsh

Theme: [powerlevel10k](https://github.com/romkatv/powerlevel10k)

`$ p10k configure`: Lean --> Unicode --> 256 colors --> 24-hour format --> Two lines --> Dotted --> Left --> Lightest --> Sparse --> Many icons --> Concise --> No

Plugin: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

### ohmytmux

[.tmux](https://github.com/LuciusChen/.tmux): forked from gpakosz/.tmux

## IDEA

### Plugin

 - Rainbow Brackets
 - One Dark Pro

## VSCode

### Extensions

 - ESLint
 - Markdown All in One
 - Markdown Preview Github
 - MoonScript Language
 - One Dark Pro
 - Prettier - Code formatter
 - GitHub Copilot

### Settings

```json
{
  "editor.fontFamily": "'Fira Code',Menlo, Monaco, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "security.workspace.trust.untrustedFiles": "open",
  // VSCode implemented this feature to address performance issues of the famous Bracket Pair Colorizer extension by CoenraadS.
  // High performance bracket pair colorization
  // https://blog.csdn.net/qq_21567385/article/details/120387446?spm=1001.2014.3001.5501
  "editor.bracketPairColorization.enabled": true,
  // Controls how the editor should render whitespace characters,
  // posibilties are 'none', 'boundary', and 'all'.
  // The 'boundary' option does not render single spaces between words.
  "editor.renderWhitespace": "boundary",
  "workbench.colorCustomizations": {
    // editorBracketHighlight
    "editorBracketHighlight.foreground1": "#EFBB24", // 鬱（yù，简：「郁」）金 UKON
    "editorBracketHighlight.foreground2": "#F8C3CD", // 退紅 TAIKOH
    "editorBracketHighlight.foreground3": "#A5DEE4", // 瓶覗（sì）KAMENOZOKI
    "editorBracketHighlight.foreground4": "#8A6BBE", // 藤紫 FUJIMURASAKI
    "editorBracketHighlight.foreground5": "#90B44B", // 鶸（ruò）萌黄 HIWAMOEGI
    "editorBracketHighlight.foreground6": "#FFB11B", // 山吹 YAMABUKI
    "editorBracketHighlight.unexpectedBracket.foreground": "#E83015", // 牡丹 SYOJYOHI
    // tab
    "tab.activeBackground": "#724832", // 燕脂 ENJI
    // scrollbarSlider
    "scrollbarSlider.background": "#91AD70", // 柳染 YANAGIZOME
    "scrollbarSlider.hoverBackground": "#91AD70",
    "scrollbarSlider.activeBackground": "#91AD70"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "editor.inlineSuggest.enabled": true,
  "workbench.colorTheme": "One Dark Pro Darker",
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

## Node.js

- dum

## github

```
git checkout --orphan latest_branch
git add -A
git commit -am "commit message"
git branch -D main
git branch -m main
git push -f origin main
```