# JAKUB: START ZSH BASICS
# enable #
setopt interactivecomments

# Enable prompt substitution in zsh, so that we can use $(..) inside PS1
setopt PROMPT_SUBST
# Set the prompt. Will look like: 'jakub~/dev/reponame(jakub/branchname:13+150-) $'
CURR_TIME='$(date +%H:%M:%S)'
SUB_CURR_BRANCH='$(git rev-parse --abbrev-ref HEAD 2>/dev/null)'
SUB_DIFF_PREPROD='$(git rev-list --left-right --count HEAD...origin/preprod 2>/dev/null | sed "s/\t/+/g")-'
CURR_FOLDER="~%"
CURR_FOLDER_SHORT='$(echo "$PWD" | sed -e "s|^/Users/$USER/go/src/github.com/||")'
#SUB_DIFF_PREPROD=''
#%F{green}%n%f is username
PS1='['$CURR_TIME'] %F{yellow}'$CURR_FOLDER_SHORT'%F{white}%B%F{white}('$SUB_CURR_BRANCH'%b:'$SUB_DIFF_PREPROD')%f %B%F{white}\$ %f%b'
#PS1='['$CURR_TIME'] %F{yellow}%~%F{white}%B%F{white}('$SUB_CURR_BRANCH'%b:'$SUB_DIFF_PREPROD')%f %B%F{white}\$ %f%b'

# Enable zsh autocompletions
autoload -Uz compinit
compinit
# JAKUB: END ZSH BASICS
