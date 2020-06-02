TODO at each install (try to automate this, check TODO)
=======================================================

- link files
- install fzf
- install ag

Notes
=====

git installed through Homebrew install lame completions.

To avoid them, you can remove the `_git` file in a directory installed by Homebrew

You can see these directories with `echo $fpath`

Then by default, the git completion will the one directly provided by zsh, which
is far better.

iTerm shortcuts
===============

Cmd+n to select tmux tabs
-------------------------

First, you need to go in Preferences/Keys/Navigation Shortcuts
and select "No Shortcut" for both
"Shortcut to activate a window" and "Shortcut to select a tab"

Then, in Preferences/Keys/Key Bindings add the following shortcuts:
Cmd+1: Send Hex Codes: 0x1 0x31
Cmd+2: Send Hex Codes: 0x1 0x32
... and so on and so forth

Alt-nav
-------

In Preferences/Profiles/Keys, select Alt+-> and choose send escape sequence f
and select Alt+<- and chose send escape sequence b

TODO
====

A script that (but before test dotfiles (check Pocket link)):

-symlinks ohmyzshrc to ~/.zshrc
-symlinks prompt/my_theme.zsh-theme to ~/.oh-my-zsh/themes/my_theme.zsh-theme
-symlink other stuff

