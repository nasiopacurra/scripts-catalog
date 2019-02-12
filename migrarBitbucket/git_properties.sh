#!/bin/bash
#
FILE=_git.properties

if [ -f ".gitignore" ]; then 
  rm -fr ${FILE}
  touch ${FILE}
fi
printf "Usuario Git Origen: "
read USER
if [ -z ${USER} ]; then 
  rm -fr ${FILE}
  exit -1
fi
stty -echo
printf "Password Git Origen [${USER}]: "
read PASS
stty echo
printf "\n"
if [ -z ${PASS} ]; then 
  rm -fr ${FILE}
  exit -1
fi
echo USERGIT_ORIG=${USER} >> ${FILE}
echo PASSGIT_ORIG=${PASS} >> ${FILE}

printf "Usuario Git Destino: "
read USER
if [ -z ${USER} ]; then 
  rm -fr ${FILE}
  exit -1
fi
stty -echo
printf "Password Git Destino [${USER}]: "
read PASS
stty echo
printf "\n"
if [ -z ${PASS} ]; then 
  rm -fr ${FILE}
  exit -1
fi
echo USERGIT_DEST=${USER} >> ${FILE}
echo PASSGIT_DEST=${PASS} >> ${FILE}



if [ -f ".gitignore" ]; then
  num=`cat .gitignore | grep ${FILE} |wc -l`
  if [ ${num} -eq 0 ]; then
    echo ${FILE} >> .gitignore
  fi
else
  echo _confidencial.txt > .gitignore
  echo ${FILE} >> .gitignore
fi

exit 0


