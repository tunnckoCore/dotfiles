#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias lsal="ls -al"
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export GPG_SIGN_KEY_FINGERPRINT="83A79973F18425351FA6005D3D812AC9E5D87CE5"
export GPG_AUTH_KEY_FINGERPRINT="FDB5C44765C53929B2D74612B39C923AA8114FC6"

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export GPG_TTY=$(tty)
gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null

alias gpg_list="gpg -K --with-fingerprint --with-subkey-fingerprints --with-keygrip --keyid-format long"

gpg_backup() {
  mkdir -p ~/.gpg-backups

  echo "Exporting GPG keys to ~/.gpg-backups"

  gpg --export-ownertrust > ~/.gpg-backups/sigma-trust.gpg
  gpg --export --export-options backup --output ~/.gpg-backups/sigma-public-keys.gpg
  gpg --export-secret-keys --export-options backup --output ~/.gpg-backups/sigma-private-keys.gpg
}

gpg_restore() {
  echo "Importing GPG keys from ~/.gpg-backups"

  gpg --import-ownertrust ~/.gpg-backups/sigma-trust.gpg
  gpg --import ~/.gpg-backups/sigma-public-keys.gpg
  gpg --import ~/.gpg-backups/sigma-private-keys.gpg
}

#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpg-connect-agent UPDATESTARTUPTTY /bye
#gpgconf --launch gpg-agent
