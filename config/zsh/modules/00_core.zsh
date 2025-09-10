# Core Zsh settings and Oh My Zsh configuration

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git
    zsh-autosuggestions
    zsh-syntax-highlighting
    )

source $ZSH/oh-my-zsh.sh

# Set terminal type
export TERM=xterm-256color

# Set default editor
export EDITOR='nvim'

# Set locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# vim style keybindings
set -o vi
