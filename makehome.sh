#!/usr/bin/env bash

function _exit1() {
    echo "
[Error] Command \`home-manager\` not found, please install

    Installation - https://github.com/nix-community/home-manager
"
    exit 1
}

function _exit2() {
    echo "
[Error] User or Home director not found, please input manaually

    ./makehome.sh \"<user>\" \"<home-dir>\"
"
    exit 1
}

which "home-manager" >> /dev/null || _exit1 

_user=${USER}
_home=${HOME}

if [ -z $_user -o -z $_home ];
then
    if [ ${#@} -lt 2 ]; then
        _exit2
    fi
    _user=$1
    _home=$2
fi

if [ ! -e $_home ]; then
    echo "Invalid home directory is not found"
    exit 1
fi

hmconfigdir="${_home}/.config/home-manager"

if [ -e "${_home}/.config/home-manager" ]; then
    echo "Please confirm you want to override the default config [y/n]";
    read awnser
    [[ "${awnser}" == 'n' ]] && exit 0
    if [ -e "${hmconfigdir}-default" ]; then
        mv "${hmconfigdir}-default" "/tmp/home-manager-backup-$$"
    fi
    mv $hmconfigdir "${hmconfigdir}-default"
    cp -R home-manager $hmconfigdir
fi

if [ "$(uname)" == "Darwin" ]; then
    # Applied for MacOS
    sed -i '' "s/#username/${_user}/g" "${hmconfigdir}/home.nix"
    sed -i '' "s*#homedir*${_home}*g" "${hmconfigdir}/home.nix"
else
    sed -i "s/#username/${_user}/g" "${hmconfigdir}/home.nix"
    sed -i "s*#homedir*${_home}*g" "${hmconfigdir}/home.nix"
fi
