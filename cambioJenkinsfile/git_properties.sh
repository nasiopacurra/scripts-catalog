#!/bin/bash
#
FILE=_git.properties
USER=amasa3w

stty -echo
printf "Password [${USER}]: "
read PASS
stty echo
printf "\n"

echo USERGIT=${USER} > ${FILE}
echo PASSGIT=${PASS} >> ${FILE}

if [ -f ".gitignore" ]; then
  num=`cat .gitignore | grep ${FILE} |wc -l`
  if [ ${num} -eq 0 ]; then
    echo ${FILE} >> .gitignore
  fi
else
  echo ${FILE} > .gitignore
fi

exit 0


