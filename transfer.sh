#! /bin/bash

for file in ~/dotfiles/*; do
  rm -fr $file
  cp ~/.config/"$(basename $file)" $file -r
done
