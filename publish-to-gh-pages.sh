#!/bin/bash
set -ev
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout gh-pages
cd ../
mv .deploy_git/.git/ ./public/
cd ./public
git config user.name  "MrLeo"
git config user.email "leo@xuebin.me" 
# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"
git push --force --quiet "https://${Travis_gh_token}@${GH_REF}" gh-pages:gh-pages