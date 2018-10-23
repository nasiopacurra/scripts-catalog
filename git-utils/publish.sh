#!/usr/bin/env bash

GH_USER=username
GH_PATH=`cat ~/.ghtoken`
GH_REPO=reponame
GH_TARGET=master
ASSETS_PATH=build
<run some build command>
VERSION=`grep '"version":' version.json | cut -d\" -f4` 

git add -u
git commit -m "$VERSION release"
git push

res=`curl --user "$GH_USER:$GH_PATH" -X POST https://api.github.com/repos/${GH_USER}/${GH_REPO}/releases \
-d "
{
  \"tag_name\": \"v$VERSION\",
  \"target_commitish\": \"$GH_TARGET\",
  \"name\": \"v$VERSION\",
  \"body\": \"new version $VERSION\",
  \"draft\": false,
  \"prerelease\": false
}"`
echo Create release result: ${res}
rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin)["id"])'`
file_name=yourproj-${VERSION}.ext

curl --user "$GH_USER:$GH_PATH" -X POST https://uploads.github.com/repos/${GH_USER}/${GH_REPO}/releases/${rel_id}/assets?name=${file_name}\
 --header 'Content-Type: text/javascript ' --upload-file ${ASSETS_PATH}/${file_name}

rm ${ASSETS_PATH}/${file_name}


Script assumes that <run some build command> will autoupdate version.json file, which can be something like this:

{
  "version": "1.1.5",
}
Also it assumes that after <run some build command> file named yourproj-${VERSION}.ext will be created in ASSETS_PATH, 
e.g. build/yourproj-1.1.5.ext (This file will be uploaded as release attachment)
We reccomend to follow semver (http://semver.org/) for your projects.

Creating access token

Script assumes that you store your GitHub access token in ~/.ghtoken file in your filesystem.

To create it go to the https://github.com/settings/tokens/new, and tick 'repo':
Enter some description and press Generate token.

Copy and paste token to ~/.ghtoken file:

echo "a1d23d126223b709e8f12ee12201dcfb5013155" > ~/.ghtoken
