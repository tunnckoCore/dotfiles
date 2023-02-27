#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
#alias lsal="ls -al"
#alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export GPG_SIGN_KEY_FINGERPRINT="83A79973F18425351FA6005D3D812AC9E5D87CE5"
export GPG_AUTH_KEY_FINGERPRINT="FDB5C44765C53929B2D74612B39C923AA8114FC6"

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export $(dbus-launch)

export GPG_TTY=$(tty)
gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null

source ~/.gpgpass
source ~/.aliases
