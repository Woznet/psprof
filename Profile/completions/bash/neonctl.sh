#!/usr/bin/env sh

###-begin-neonctl-completions-###
#
# yargs command completion script
#
# Installation: neonctl completion >> ~/.bashrc
#    or neonctl completion >> ~/.bash_profile on OSX.
#
_neonctl_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(neonctl --get-yargs-completions "${args[@]}")

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=()
    fi

    return 0
}
complete -o bashdefault -o default -F _neonctl_yargs_completions neonctl
###-end-neonctl-completions-###

