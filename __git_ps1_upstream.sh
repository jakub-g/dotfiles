__git_ps1_show_upstream is a function
__git_ps1_show_upstream () 
{ 
    local key value;
    local svn_remote svn_url_pattern count n;
    local upstream=git legacy="" verbose="" name="";
    svn_remote=();
    local output="$(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' 2>/dev/null | tr '\0\n' '\n ')";
    while read -r key value; do
        case "$key" in 
            bash.showupstream)
                GIT_PS1_SHOWUPSTREAM="$value";
                if [[ -z "${GIT_PS1_SHOWUPSTREAM}" ]]; then
                    p="";
                    return;
                fi
            ;;
            svn-remote.*.url)
                svn_remote[$((${#svn_remote[@]} + 1))]="$value";
                svn_url_pattern="$svn_url_pattern\\|$value";
                upstream=svn+git
            ;;
        esac;
    done <<< "$output";
    for option in ${GIT_PS1_SHOWUPSTREAM};
    do
        case "$option" in 
            git | svn)
                upstream="$option"
            ;;
            verbose)
                verbose=1
            ;;
            legacy)
                legacy=1
            ;;
            name)
                name=1
            ;;
        esac;
    done;
    case "$upstream" in 
        git)
            upstream="@{upstream}"
        ;;
        svn*)
            local -a svn_upstream;
            svn_upstream=($(git log --first-parent -1 					--grep="^git-svn-id: \(${svn_url_pattern#??}\)" 2>/dev/null));
            if [[ 0 -ne ${#svn_upstream[@]} ]]; then
                svn_upstream=${svn_upstream[${#svn_upstream[@]} - 2]};
                svn_upstream=${svn_upstream%@*};
                local n_stop="${#svn_remote[@]}";
                for ((n=1; n <= n_stop; n++))
                do
                    svn_upstream=${svn_upstream#${svn_remote[$n]}};
                done;
                if [[ -z "$svn_upstream" ]]; then
                    upstream=${GIT_SVN_ID:-git-svn};
                else
                    upstream=${svn_upstream#/};
                fi;
            else
                if [[ "svn+git" = "$upstream" ]]; then
                    upstream="@{upstream}";
                fi;
            fi
        ;;
    esac;
    if [[ -z "$legacy" ]]; then
        count="$(git rev-list --count --left-right 				"$upstream"...HEAD 2>/dev/null)";
    else
        local commits;
        if commits="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null)"; then
            local commit behind=0 ahead=0;
            for commit in $commits;
            do
                case "$commit" in 
                    "<"*)
                        ((behind++))
                    ;;
                    *)
                        ((ahead++))
                    ;;
                esac;
            done;
            count="$behind	$ahead";
        else
            count="";
        fi;
    fi;
    if [[ -z "$verbose" ]]; then
        case "$count" in 
            "")
                p=""
            ;;
            "0	0")
                p="="
            ;;
            "0	"*)
                p=">"
            ;;
            *"	0")
                p="<"
            ;;
            *)
                p="<>"
            ;;
        esac;
    else
        case "$count" in 
            "")
                p=""
            ;;
            "0	0")
                p=" u="
            ;;
            "0	"*)
                p=" u+${count#0	}"
            ;;
            *"	0")
                p=" u-${count%	0}"
            ;;
            *)
                p=" u+${count#*	}-${count%	*}"
            ;;
        esac;
        if [[ -n "$count" && -n "$name" ]]; then
            __git_ps1_upstream_name=$(git rev-parse 				--abbrev-ref "$upstream" 2>/dev/null);
            if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
                p="$p \${__git_ps1_upstream_name}";
            else
                p="$p ${__git_ps1_upstream_name}";
                unset __git_ps1_upstream_name;
            fi;
        fi;
    fi
}
