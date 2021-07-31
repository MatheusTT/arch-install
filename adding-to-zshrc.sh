#!/bin/bash

# plugins
sudo pacman -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions

if ! ls -a $HOME | grep .p10k.zsh; then
    echo "
    ## For saving commands 
    HISTFILE=~/.zsh_history
    HISTSIZE=10000
    SAVEHIST=10000

    ## Plugins
    # zsh-syntax-highlighting
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # zsh-autosuggestions
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

    ## My own commands
    ZLE_RPROMPT_INDENT=0
    pfetch" >> $HOME/.zshrc
fi