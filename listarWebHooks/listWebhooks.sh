#!/bin/bash
#

if [ ! -f "_git.properties" ]; then 
    ./git_properties.sh
fi 
# Cargamos usuario y password 
# USERGIT=
# PASSGIT=
source _git.properties

GITLAB_HOST=srkmcontdelivery.mutua.es
GITLAB_PORT=80
GITLAB_URL_PREFIX="http://${GITLAB_HOST}:${GITLAB_PORT}"
GITLAB_API_VERSION=v3

#gain a gitlab token
GITLAB__API_URL="${GITLAB_URL_PREFIX}/api/${GITLAB_API_VERSION}"
SESSION=$(curl --silent  --data "login=${USERGIT}&password=${PASSGIT}" ${GITLAB__API_URL}/session ) || exit 1
GITLAB_PRIVATE_TOKEN=$(echo "${SESSION}" | jq --raw-output .private_token )
largo=${#GITLAB_PRIVATE_TOKEN}
((largo = largo - 1))
GITLAB_PRIVATE_TOKEN=${GITLAB_PRIVATE_TOKEN:0:largo}
# echo "Private Token: [${GITLAB_PRIVATE_TOKEN}]"

perPage=100
shopt -s extglob # Required to trim whitespace; see below
while IFS=':' read key value; do
    # trim whitespace in "value"
    value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}

    case "$key" in
        X-Total) xTotal="$value"
                ;;
        X-Total-Pages) xTotalPages="$value"
                ;;
        HTTP*) read PROTO STATUS MSG <<< "$key{$value:+:$value}"
                ;;
     esac
done < <(curl -I --silent --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${GITLAB__API_URL}/projects/all?per_page=${perPage}&page=1")
echo " Total de repositorios [${xTotal}}"
echo " Total de paginas [${xTotalPages}] a [${perPage}] repositorios por pagina"

#xPage=1
for ((xPage=1; xPage<=${xTotalPages}; ++xPage)); do
    echo " Pagina: [${xPage}]"

    RESPUESTA=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${GITLAB__API_URL}/projects/all?per_page=${perPage}&page=${xPage}")
    ID=$(echo ${RESPUESTA} | jq --raw-output '.[].id')
    ID=`echo -n "${ID}" | sed -e 's/\x0d//g'`
    pathWithNamespace=$(echo ${RESPUESTA} | jq --raw-output '.[].path_with_namespace')
    pathWithNamespace=`echo -n "${pathWithNamespace}" | sed -e 's/\x0d//g'`

    idArray=(${ID});
    pathWithNamespaceArray=(${pathWithNamespace});
    for ((i=0; i<${#idArray[@]}; ++i)); do
        echo "${idArray[$i]}/${pathWithNamespaceArray[$i]}"
        agrp=$(echo "${pathWithNamespaceArray[$i]}" |awk -F "/" '{print $1}')
        appl=$(echo "${pathWithNamespaceArray[$i]}" |awk -F "/" '{print $2}')
        echo "${idArray[$i]}/${pathWithNamespaceArray[$i]}" >> listado_repos_git.txt
        RESPUESTA=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${GITLAB__API_URL}/projects/${agrp}%2F${appl}/hooks")
        if [ "${#RESPUESTA}" == "2" ]; then 
            echo " NO HAY webHooks definidos en [${agrp},${appl}]"
        else
            HOOKS=$(echo ${RESPUESTA} | jq --raw-output '.[].url')
            HOOKS=`echo -n "${HOOKS}" | sed -e 's/\x0d//g'`
            hooksArray=(${HOOKS});
            for ((j=0; j<${#hooksArray[@]}; ++j)); do
                echo "${idArray[$i]}#${agrp}#${appl}#${hooksArray[$j]}"
                echo "${idArray[$i]}#${agrp}#${appl}#${hooksArray[$j]}" >> listado_hooks_git.txt
            done
        fi
    done

done

exit 0
