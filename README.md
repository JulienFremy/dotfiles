Notes
=====

git installed through Homebrew install lame completions.

To avoid them, you can remove the `_git` file in a directory installed by Homebrew

You can see these directories with `echo $fpath`

Then by default, the git completion will the one directly provided by zsh, which
is far better.

TODO
====

A script that:

-symlinks ohmyzshrc to ~/.zshrc
-symlinks prompt/my_theme.zsh-theme to ~/.ohmyzshrc/themes
-symlink other stuff
-add a note on manually adding shortcuts for iTerm and tmux

