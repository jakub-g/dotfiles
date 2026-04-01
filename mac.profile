
#!/bin/bash
alias sub='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias subl='sub'

#alias reload='source ~/.zshrc; source ~/.zshenv'
#alias reload='exec bash -l'
alias reload='exec zsh -l'
alias dotedit='sub ~/.zshrc; sub ~/.zshenv; sub ~/dotfiles/mac.profile'

alias o='open .'

store_token() {
	printf "Enter env var name (e.g. FOOBAR_TOKEN): " && \
	  read TOKEN_NAME && \
	  printf "Enter API token value: " && \
	  read TOKEN && \
	  security add-generic-password -U -a ${USER} -s ${TOKEN_NAME} -w ${TOKEN} && \
	  unset TOKEN

	TO_WRITE="\nexport ${TOKEN_NAME}="
	TO_WRITE+='$(security find-generic-password -a ${USER}'
	TO_WRITE+=" -s ${TOKEN_NAME} -w)"
	echo -e "${TO_WRITE}" >> ~/.zshrc
	unset TOKEN_NAME
	source ~/.zshrc
}

alias karabiner='cd ~/.config/karabiner/assets/complex_modifications'
alias kara='karabiner'

alias down='cd ~/Downloads'
alias downloads='cd ~/Downloads'

alias macos_hide_desktop='defaults write com.apple.finder CreateDesktop false ; killall Finder'
alias macos_show_desktop='defaults write com.apple.finder CreateDesktop true  ; killall Finder'

alias topmem='top -o mem'

alias jqcless='jq -C | less -r'

alias cld='claude'

alias git-list-all-remote-branches='git ls-remote | grep 'refs/heads/' | cut -f2 | sed "s|refs/heads/||"'
alias path='echo $PATH | tr ":" "\n"'

alias dush='du -sh'

alias gone='git branch -vv | grep gone'
alias git-gone='gone'


# function cdc() {
#   cd "$HOME/Code/$1"
# }

# function _cdc() {
#   ((CURRENT == 2)) &&
#   _files -/ -W "$HOME/Code"
# }

# compdef _cdc cdc



# find files on disk, except in .git subfolder
alias find-no-git="find . -type f -not -path '*/\.git/*'"

# curl helpers
alias jqcurl='curl -S -D /dev/stderr -X GET'
alias curl-headers='curl -sS -I -X GET'
alias curlh='curl-headers'