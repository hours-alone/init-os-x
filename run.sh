#!/bin/bash

# Settup Mac OS X
# if you want to get this script from github, to install git, you need to install command line tools with xcode-select --install

# Move on directory of this script
DIR=$(dirname $0)
cd $DIR

# Show Hidden Files
defaults write com.apple.finder AppleShowAllFiles YES

# Allow the selection of text on QuickLoock
defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder

# Allow Apple crash reports like notifications
defaults write com.apple.CrashReporter UseUNC 1

echo "Have you already install command line tools ?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
			echo "-- Skipped";
			break;;
        No )
            xcode-select --install;
            echo "Have you finished to install command line tools?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) 
                        break;;
                    No ) 
                        echo "And now ?";
                esac
            done
            break;;
    esac
done

# install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
tmp=$(brew -v)
echo '$tmp installed'
wait

# install brew cask, it use to install others softs
brew install caskroom/cask/brew-cask
wait

# change order on PATH environment
printf "\nexport PATH=/usr/local/bin:/usr/local/sbin:\$PATH\n" >> $HOME/.bash_profile
echo "PATH => $(cat $HOME/.bash_profile)"
printf "\nalias tree=\"find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'\"\n" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo "Do you wish to install Symfony?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
            php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
            php composer-setup.php
            php -r "unlink('composer-setup.php');"
			curl -sS https://get.symfony.com/cli/installer | bash
			break;;
        No ) 
			echo "-- Skipped";
			break;;
    esac
done

# Install Oh my zsh
echo "install Oh my zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install IOS environment with cocoapods
# update ruby gem
echo "install gem"
gem update -n /usr/local/bin --system

echo "install rbenv"
brew install rbenv

echo "install 2.6.5"
rbenv install 2.6.5

echo "rbenv - global => 2.6.5"
rbenv global 2.6.5

echo "install bundler"
# install cocoapods
gem install bundler
wait

# install command-line to generate your project’s documentation 
echo "install jazzy"
gem install jazzy

# install SwiftLint to enforce Swift style and conventions
echo "install swiftlint"
brew install swiftlint
wait

echo "install sublime-text and postman"
# brew cask install google-chrome # it's already installed
brew cask install sublime-text
brew cask install postman
wait

brew update && brew upgrade brew-cask && brew cleanup
wait

sudo reboot
