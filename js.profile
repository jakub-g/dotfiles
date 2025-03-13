#!/bin/bash

# yarn: cd to package by its name
cdp() { cd $(yarn workspace "$1" exec pwd) }
# yarn: open package.json for package by name
pkg() { FOLDER=$(yarn workspace "$1" exec pwd); code "$FOLDER/package.json" }

function yaml_lint() {
	for i in $(find . -name '*.yml' -o -name '*.yaml'); do echo $i; ruby -e "require 'yaml';YAML.load_file(\"$i\")"; done
}

function yaml_to_json() {
	echo "python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < file.yaml > file.json"
}

#alias nnode='winpty -Xallow-non-tty node'

#alias ni='npm install --ignore-scripts'
#alias nt='npm test'
#alias ns='npm start -- --no-ue'
#alias nr='npm run'
#alias npmrun='npm run'
#alias npmpublic='npm --userconfig /c/git/public.npmrc'

#alias grunt-debug='node --debug-brk /d/bin/nodist/bin/node_modules/grunt-cli/bin/grunt'
#alias mocha-debug='node --debug-brk /d/bin/nodist/bin/node_modules/mocha/bin/mocha'
#alias grunt-inspect='node --inspect --inspect-brk ./node_modules/grunt-cli/bin/grunt'

# alias _npmscripts_print="node -e \"console.log(Object.keys(require('./package.json').scripts, null, '  ').join(' '))\""
# _npmscripts_completion()
# {
#     local cur=${COMP_WORDS[COMP_CWORD]}
#     opts=$( _npmscripts_print )
#     COMPREPLY=( $(compgen -W "${opts}" -- $cur) )
# }
# complete -F _npmscripts_completion npmrun
# complete -F _npmscripts_completion nr
