#!/usr/bin/env bash

git_branch_clean() {
  git fetch -p
  for b in $(git branch -vv | grep disparue | awk '{print $1}'); do git branch -D "$b"; done
}

git_branch_list() {
  git fetch -p
  git branch -vv | grep disparue | awk '{print $1}'
}

