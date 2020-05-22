#!/bin/bash

alias nnode='winpty -Xallow-non-tty node'

alias ni='npm install --ignore-scripts'
alias nt='npm test'
alias ns='npm start -- --no-ue'
alias nr='npm run'
alias npmrun='npm run'
alias npmpublic='npm --userconfig /c/git/public.npmrc'

alias grunt-debug='node --debug-brk /d/bin/nodist/bin/node_modules/grunt-cli/bin/grunt'
alias mocha-debug='node --debug-brk /d/bin/nodist/bin/node_modules/mocha/bin/mocha'
alias grunt-inspect='node --inspect --inspect-brk ./node_modules/grunt-cli/bin/grunt'

alias _npmscripts_print="node -e \"console.log(Object.keys(require('./package.json').scripts, null, '  ').join(' '))\""
_npmscripts_completion()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    opts=$( _npmscripts_print )
    COMPREPLY=( $(compgen -W "${opts}" -- $cur) )
}
complete -F _npmscripts_completion npmrun
complete -F _npmscripts_completion nr