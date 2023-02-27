# Dotfiles as of Feb 2023

Mhmmm... This nightmare should stop by switching to NixOS..


## SSH inside GPG (sign & auth keys)

This trickery uses `gpg-agent` instead of `ssh-agent`. So you need to inform both sides for the other one.

1. Add ENV vars, ssh & gpg-agent configs

Add this to `.bashrc` or something similar

```bash
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export GPG_TTY=$(tty)
gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null
```

the `~/.ssh/config`

```
Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
```

the `~/.gnupg/gpg-agent`

```
#pinentry-program /usr/bin/pinentry-curses
pinentry-program /usr/bin/pinentry-tty

enable-ssh-support
max-cache-ttl 60480000
default-cache-ttl 60480000
ttyname $GPG_TTY
```

1. Add your `KEYGRIP`s of the **AUTH** and **SIGN** keys to `~/.gnupg/sshcontrol`

```bash
gpg -K --with-fingerprint --with-subkey-fingerprints --with-keygrip --keyid-format long

ssb   ed25519/3D812AC9E5D87CE5 2023-02-26 [S] [expires: 2028-02-25]
      Key fingerprint = 83A7 9973 F184 2535 1FA6  005D 3D81 2AC9 E5D8 7CE5
      Keygrip = 78C59F72A0B57569585BBF8D1EBEA82A6190B6FA
ssb   cv25519/A31C6380C1E9A7FE 2023-02-26 [E] [expires: 2023-03-03]
      Key fingerprint = 4E78 BBF3 747B DFA3 3E84  183E A31C 6380 C1E9 A7FE
      Keygrip = 6BB4578D3BF72D791A07366570E906F73C8046C0
ssb   ed25519/B39C923AA8114FC6 2023-02-26 [A] [expires: 2028-02-25]
      Key fingerprint = FDB5 C447 65C5 3929 B2D7  4612 B39C 923A A811 4FC6
      Keygrip = E3F1B15CEB129B91D46B3BF6587155063B6101FB


echo 78C59F72A0B57569585BBF8D1EBEA82A6190B6FA >> ~/.gnupg/sshcontrol
echo E3F1B15CEB129B91D46B3BF6587155063B6101FB >> ~/.gnupg/sshcontrol
```

1. Add env vars of the fingerprints for SIGN and AUTH keys

_strip the spaces from the fingerprint that is shown_

in the `.bashrc` or somewhere similar

```bash
export GPG_SIGN_KEY_FINGERPRINT="83A79973F18425351FA6005D3D812AC9E5D87CE5"
export GPG_AUTH_KEY_FINGERPRINT="FDB5C44765C53929B2D74612B39C923AA8114FC6"
```

1. Add your Signing Key fingerprint to `git`, or pass `-S` flag to your `git commit` commands.

I also use `Signed-off-by`, so I have `commit.gpgsign` set to `true`

```bash
git config --global user.email "your_github_noreplay_email similar to 5038030+tunnckoCore@users.noreply.github.com"
git config --global user.name "your_username
git config --global user.signingkey 83A79973F18425351FA6005D3D812AC9E5D87CE5
git config --global commit.gpgsign true
```

1. Add your public key `sign` (`[S]`) gpg key to Github - GPG Keys

https://github.com/settings/gpg/new

```bash
# copy the output
gpg --armor --export $GPG_SIGN_KEY_FINGERPRINT
```

2. Add your public key `sign` gpg key to Github - SSH Keys, select `Signing Key` in the dropdown.

https://github.com/settings/ssh/new

```bash
# copy the output
gpg --export-ssh-key $GPG_SIGN_KEY_FINGERPRINT
```

3. Add your public `auth` gpg key to Github - SSH Keys, select `Authentication Key`.

https://github.com/settings/ssh/new

```bash
gpg --export-ssh-key $GPG_AUTH_KEY_FINGERPRINT
```

4. Login to Github

This is the same for every user.

```bash
ssh -T git@github.com
```

If something fails, try adding `-v` flag. `ssh -Tvv git@github.com`.


5. Now you hopefully can

```bash
git add -A
git commit --gpgsign
```
