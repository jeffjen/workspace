# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
shopt -s histappend

# enable extended global replacement
shopt -s extglob

# Aggregate history of all terminals in the same .history
shopt -s histverify histreedit
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoredups:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable local rc setup
if [ -f ~/.bash_rc ]; then
    . ~/.bash_rc
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.workspaceenv/bash_aliases ]; then
    . ~/.workspaceenv/bash_aliases
fi

# definition for environment setup
if [ -f ~/.workspaceenv/bash_env ]; then
    . ~/.workspaceenv/bash_env
fi

# definition for.workspaceenv commandline editing
if [ -f ~/.workspaceenv/bash_editmode ]; then
    . ~/.workspaceenv/bash_editmode
fi

# definition for convenience wrapper
if [ -f ~/.workspaceenv/bash_function ]; then
    . ~/.workspaceenv/bash_function
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$my_chroot" ] && [ -r /etc/debian_chroot ]; then
    my_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if test "$UID" -ne 0; then
        PS1='${my_chroot:+($my_chroot)}\e[1;32m\u@\h\e[m:\e[1;34m[\w]\e[m$(__git_ps1)\n>> '
    else
        PS1='${my_chroot:+($my_chroot)}\e[0;31m\u@\h\e[m:\e[1;34m[\w]\e[m$(__git_ps1)\n>> '
    fi
else
    PS1='${my_chroot:+($my_chroot)}\u@\h:[\w]$(__git_ps1)\n>> '
fi
PS2='.. '
unset color_prompt force_color_prompt
