#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

_set_liveuser_PS1() {
    PS1='[\u@\h \W]\$ '
    if [ "$(whoami)" = "liveuser" ] ; then
        local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
        if [ -n "$iso_version" ] ; then
            local prefix="eos-"
            local iso_info="$prefix$iso_version"
            PS1="[\u@$iso_info \W]\$ "
        fi
    fi
}
_set_liveuser_PS1
unset -f _set_liveuser_PS1

ShowInstallerIsoInfo() {
    local file=/usr/lib/endeavouros-release
    if [ -r $file ] ; then
        cat $file
    else
        echo "Sorry, installer ISO info is not available." >&2
    fi
}


alias ll='ls --color=auto'
alias ls='ls -lav --color=auto --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --color=auto --ignore=.?*'   # show long listing but no hidden dotfiles except "."

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.
##
## October 2021: removed many obsolete functions. If you still need them, please look at
## https://github.com/EndeavourOS-archive/EndeavourOS-archiso/raw/master/airootfs/etc/skel/.bashrc

_open_files_for_editing() {
    # Open any given document file(s) for editing (or just viewing).
    # Note1:
    #    - Do not use for executable files!
    # Note2:
    #    - Uses 'mime' bindings, so you may need to use
    #      e.g. a file manager to make proper file bindings.

    if [ -x /usr/bin/exo-open ] ; then
        echo "exo-open $@" >&2
        setsid exo-open "$@" >& /dev/null
        return
    fi
    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            echo "xdg-open $file" >&2
            setsid xdg-open "$file" >& /dev/null
        done
        return
    fi

    echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}

#------------------------------------------------------------

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##

# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=eos-pacdiff
################################################################################

alias vi=nvim
alias svi="sudo nvim"
alias ip="ip -c"
# man color
export LESS_TERMCAP_mb=$'\e[01;31m' # commence à clignoter
export LESS_TERMCAP_md=$'\e[01;37m' # début gras
export LESS_TERMCAP_me=$'\e[0m' # termine tous les modes comme ceci, us, mb, md, mr
export LESS_TERMCAP_se=$'\e[0m' # fin du mode hors concours
export LESS_TERMCAP_so=$'\e[45;93m' # démarrer le mode hors concours
export LESS_TERMCAP_ue=$'\e[0m' # fin souligné
export LESS_TERMCAP_us=$'\e[4;93m' # commencer à souligner

alias htb="cd /home/yayoi/Documents/hack/HTB"
alias thm="cd /home/yayoi/Documents/hack/THM"
alias htb_conn="sudo openvpn /home/yayoi/Documents/hack/HTB/lab_guesswhoisback.ovpn"
alias thm_conn="sudo openvpn /home/yayoi/Documents/hack/THM/itachi.ovpn"
alias ipp="nohup cherrytree /home/yayoi/Documents/hack/notes_htb_ippsec.ctb &"
alias bug="cd /home/yayoi/Documents/hack/Bugbounty/grab/"
# sudo service ntp start
export PATH=$PATH:/home/yayoi/go/bin:/home/yayoi/.local/share/gem/ruby/3.0.0/bin/

#lsmod | grep pcspkr 1>/dev/null
#if [ $? -eq 0 ]; then
#    sudo rmmod pcspkr
#fi

#shopt -s dirspell

bind 'set completion-ignore-case on'

# To add color on the prompt
#PS1="\e[0;31m[\u@\h \W]\$ \e[m"
#PROMPT_COMMAND='PS1="\[\033[01;32m\][\u@\h]\[\033[00m\]-\A:\[\033[01;34m\]\W\[\033[00m\]\$ "'
#PS1="\[\033[01;31m\][\u@\h]\[\033[00m\]-\A:\[\033[01;34m\]\W\[\033[00m\]\$ "

prompt="\[\033[01;32m\][\u@\h]\[\033[00m\]-\A:\[\033[01;34m\]\W\[\033[00m\]\$ " 
PS1=$prompt
add_venv_info () {
    if [ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ]
    then    
	    _OLD_VIRTUAL_PS1=$prompt

    elif [ "$VIRTUAL_ENV" != "" ]
    then
	    echo $PS1
            PS1="(`basename \"$VIRTUAL_ENV\"`) $PS1"
    fi
    export PS1
}
PROMPT_COMMAND=add_venv_info

alias pac="sudo pacman"
alias wireshark="sudo wireshark"
alias xfreerdp="flatpak run com.freerdp.FreeRDP /size:956x1041"
alias braavos_khal="flatpak run com.freerdp.FreeRDP /size:956x1041 /u:khal.drogo /p:horse /d:essos.local /v:192.168.56.23 /cert-ignore"

export PATH=/home/yayoi/.local/bin:$PATH

# GOAD
alias goad="cd /opt/GOAD/"
alias goadhalt="cd /opt/GOAD/ && vagrant halt"
alias goadans="cd /opt/GOAD/ && source ansible/.venv/bin/activate"
#alias goadans="cd /opt/GOAD/ && source ansible/.venv/bin/activate && vagrant up && cd ansible && ansible-playbook -i ../ad/sevenkingdoms.local/inventory main.yml"
#!/usr/bin/env bash
complete -W "\$(gf -list)" gf

# to retrieve ipv4 wlan0 ip addr
# ip -o -4 addr show wlan0 | awk '{print $4}' | sed 's/\/.*//g'
alias adb_set_proxy="adb shell settings put global http_proxy $(ip -o -4 addr show wlan0 | awk '{print $4}' | sed 's/\/.*//g'):8080"
alias adb_unset_proxy="adb shell settings put global http_proxy :0"


# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ranger conf
export VISUAL=nvim;
export EDITOR=nvim;

alias i3conf='vi /home/yayoi/.config/i3/config'

#https://bbs.archlinux.org/viewtopic.php?id=287306
#https://bbs.archlinux.org/viewtopic.php?id=287185
export GROFF_NO_SGR=1


# OpenJDK for java and ghidra ofc
#export PATH=/opt/tools/jdk-20.0.2+9/bin:$PATH
#. "$HOME/.cargo/env"

