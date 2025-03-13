
#!/bin/bash
alias sub='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias subl='sub'

alias reload='source ~/.zshrc; source ~/.zshenv'
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
