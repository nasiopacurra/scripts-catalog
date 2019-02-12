#!/bin/bash
#

if [ ! -f "_git.properties" ]; then 
    ./git_properties.sh
fi 
# Cargamos usuario y password 
source _git.properties
if [ -z ${USERGIT_ORIG} ] || [ -z ${PASSGIT_ORIG} ] ; then
    echo "Faltan credenciales .. "
    exit -1
fi 

curl -u ${USERGIT_ORIG}:${PASSGIT_ORIG} http://git.mutua.es/rest/api/1.0/projects/APPARQ/repos?limit=1000 > apparq_repos.json
curl -u ${USERGIT_ORIG}:${PASSGIT_ORIG} http://git.mutua.es/rest/api/1.0/projects/DIGANALYTICS/repos?limit=1000 > diganalytics_repos.json
curl -u ${USERGIT_ORIG}:${PASSGIT_ORIG} http://git.mutua.es/rest/api/1.0/projects/APPARQDATOS/repos?limit=1000 > apparqdatos_repos.json
curl -u ${USERGIT_ORIG}:${PASSGIT_ORIG} http://git.mutua.es/rest/api/1.0/projects/MIDDLEWARE/repos?limit=1000 > middleware_repos.json
curl -u ${USERGIT_ORIG}:${PASSGIT_ORIG} http://git.mutua.es/rest/api/1.0/projects/POCARQ/repos?limit=1000 > pocarq_repos.json
curl -u ${USERGIT_ORIG}:${PASSGIT_ORIG} http://git.mutua.es/rest/api/1.0/projects/PC/repos?limit=1000 > pc_repos.json

rm -fr listado_migracion.txt
cat apparq_repos.json | jq '.values[].links.clone[].href' | grep http >> listado_migracion.txt
cat diganalytics_repos.json | jq '.values[].links.clone[].href' | grep http >> listado_migracion.txt
cat apparqdatos_repos.json | jq '.values[].links.clone[].href' | grep http >> listado_migracion.txt
cat middleware_repos.json | jq '.values[].links.clone[].href' | grep http >> listado_migracion.txt
cat pocarq_repos.json | jq '.values[].links.clone[].href' | grep http >> listado_migracion.txt
cat pc_repos.json | jq '.values[].links.clone[].href' | grep http >> listado_migracion.txt

