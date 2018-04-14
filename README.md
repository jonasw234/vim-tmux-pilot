# Wintab

Inspired by [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
this plugin further extends the `<c-{h,l}>` mappings to switch between `vim` tabs or `tmux` windows when no `vim` split or `tmux` pane is available,
similarly to what happens in the [i3](https://i3wm.org) window manager in a workspace with both tabs and windows.

# Installation

I suggest using [vim-plug](https://github.com/junegunn/vim-plug)
and sourcing the appropriate files from `~/.zshrc` and `~/.tmux.conf`.

In `~/.vimrc`, add:
```vim
Plug 'urbainvaes/vim-wintab'
```
In `~./zshrc`, add:
```zsh
# Uncomment to disable navigation of vim tabs and tmux windows
# export WINTAB_MODE=winonly

export WINTAB_ROOT=$HOME/.vim/plugged/vim-wintab
source ~/.vim/plugged/vim-wintab/wintab.plugin.zsh
```
In `~/.tmux.conf`, add:
```tmux
source-file $WINTAB_ROOT/wintab.tmux.conf
```
Note that the `$WINTAB_ROOT` environment variable needs to be defined for the plugin to work.

# Usage

Set the environment variable `WINTAB_WINONLY` to `winonly` to disable tab navigation.
In zsh, this plugin defines keybindings only for normal mode;
to enable `tmux` navigation in insert mode,
add the following to your `~/.zshrc`:
```zsh
if ! [ $TMUX = "" ]
    bindkey "^h" wintabcmd_h
    bindkey "^j" wintabcmd_j
    bindkey "^k" wintabcmd_k
    bindkey "^l" wintabcmd_l
fi
```
With tab navigation enabled,
the order of precedence when `<ctrl-h>` or `<ctrl-l>` is issued from `vim` is as follows:
`vim` window → `viw` tab → `tmux` pane → `tmux` window.
As of now, this order can't be customized.

# License

MIT
