# Dotfiles
## Reasons
These are the common dotfiles that I maintain. A repo for all the dotfiles is beneficial to the maintainability and portability. On a new machine, the developer can simply clone the repo and install. Then they will have the same develop environment. [This post](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/) by Anish Athalye (who is also a very successful research in MIT PDOS) explains the necessity to manage one's dotfile in a unified way.
## Dependency
The dotfiles will be deployed each time on a brand new machine so it is important for developers to manage them easily. The dotfiles should not contain many dependency that complicates the maintenance. In this repo, I use the dotbot as the management suite which is lightweight and self-contained. 

Here is the link to the dotbot
- [dotbot](https://github.com/anishathalye/dotbot/tree/master)

# Installation
1. First install zsh and required fonts: `./install-zsh.sh` \
**Known issues:** If the machine is using `LDAP` authentication by PAM or something, which means that you are login to the machine as a domain user, you might not be able to change the default shell by `chsh` in the `install-zsh.sh`. Here is a workaround: \
Add this code snippet to `~/.profile`:
```zsh
# Run zsh
if [ "$SHELL" != "/usr/bin/zsh" ]
then
    export SHELL="/usr/bin/zsh"
    exec /usr/bin/zsh
fi
```
2. Install prerequistes: `sudo apt-get install python-dev python3-dev python-is-python3 cmake`
3. Install dotfiles: `./install` \
**Known issues:** If the ycmd server is not working, you may have to go to the installation folder and install it.

`cd ~/.vim/plugged/YouCompleteMe && python3 install.py`
