#/usr/bin/bash
set -e
sudo apt update -y && sudo apt install zsh -y
zsh --version
chsh -s $(which zsh)
echo $SHELL
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "INSTALL REQUIRED FONTS"
sudo apt install fonts-powerline -y

