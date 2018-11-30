#!/bin/bash
#

# ========================================================
# =============   F U N C I O N E S    ===================
# ========================================================
function log { 
	local FECHA=`date "+%Y%m%d%H%M%S"`
	echo "[ $$ ${PROC} ${FECHA} ] ${1} " >> ${FILELOG}
	echo ${1}
}

function cambiaJenkinsfile {

    local URL=http://${USERGIT}:${PASSGIT}@srkmcontdelivery.mutua.es

    local repo=${URL}/${agrp}/${appl}.git
    if [ -d ${appl} ]; then
        rm -fr ${appl}
    fi
    repoDisplay=`echo ${repo} | sed -e "s/${USERGIT}/xUSERx/g" | sed -e "s/${PASSGIT}/xPASSx/g"`
    log "Clonando [${repoDisplay}]"
    git clone ${repo}
    if [ $? == 0 ]; then
        PWD_OLD=`pwd`
        cd ${appl}
        for branch in $(git branch --remote | grep -v HEAD); do
            log " Checkout [${branch}]"
            git checkout ${branch}
            if [ $? == 0 ] && [ -f Jenkinsfile ]; then 
                log " Existe Jenkinsfile en [${agrp},${appl},${branch}]"
                if grep "@Library('jenkins-pipelines') _" Jenkinsfile
                then 
                    # code if found
                    log " Jenkinsfile CORRECTO en [${agrp},${appl},${branch}]"
                    library=`cat Jenkinsfile | grep "\@Library"`
                    log " @Library Antes [ ${library} ]"
                    log " Incluyendo ['ProvisioningAPIConnect'] en [${agrp},${appl},${branch}]"
                    sed -i "s/('jenkins-pipelines')/(['ProvisioningAPIConnect', 'jenkins-pipelines'])/g" Jenkinsfile
                    if [ $? == 0 ]; then
                        library=`cat Jenkinsfile | grep "\@Library"`
                        log " @Library Despues [ ${library} ]"
                        local rama=`echo ${branch} | sed -e 's/origin\///g'`
                        log " Integrando Jenkinsfile en [${agrp},${appl},${branch}]"
                        git add Jenkinsfile
                        if [ $? == 0 ]; then
                            log " Realizando COMMIT en [${agrp},${appl},${branch}]"
                            git commit -m "Modificacion Jenkinsfile"
                            if [ $? == 0 ]; then
                                log " Realizando PUSH en [${agrp},${appl},${branch}]"
                                git push origin HEAD:${rama}
                                if [ $? == 0 ]; then
                                    log " TODO CORRECTO con [${agrp},${appl},${branch}]"
                                fi
                            fi
                        fi 
                    else
                        log " Sustitucion NO REALIZADA con [${agrp},${appl},${branch}]"
                    fi 
                else
                    # code if not found
                    log " Formato de Cambio NO ENCONTRADO con [${agrp},${appl},${branch}]"
                fi
            else
                log " Jenkinsfile NO ENCONTRADO con [${agrp},${appl},${branch}]"
            fi 
        done
        cd ${PWD_OLD}
        rm -fr ${appl}
    fi
}

function modificarWebHook {

    local push=$1

    local RESPUESTA=$(curl --silent --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "${GITLAB__API_URL}/projects/${agrp}%2F${appl}/hooks") || exit 1
    if [ $? == 0 ]; then
        log " El curl de obtencion de hooks ha ido bien. Longitud respuesta: [${#RESPUESTA}]"
        if [ "${#RESPUESTA}" == "2" ]; then 
            log " NO HAY webHooks definidos en [${agrp},${appl}]"
        else
            log ${RESPUESTA} 
            local nWebhooks=`echo "${RESPUESTA}" | awk -F "{" '{print NF-1}'`
            if [ "${nWebhooks}" == "1" ]; then 

                local idHooks=$(echo ${RESPUESTA} | jq --raw-output '.[].id')
                largo=${#idHooks}
                ((largo = largo - 1))
                idHooks=${idHooks:0:largo}
                log " idHooks:[${idHooks}]"

                local idProject=$(echo ${RESPUESTA} | jq --raw-output '.[].project_id')
                local largo=${#idProject}
                ((largo = largo - 1))
                idProject=${idProject:0:largo}
                log " idProject:[${idProject}]"

                local createdAt=$(echo ${RESPUESTA} | jq --raw-output '.[].created_at')
                largo=${#createdAt}
                ((largo = largo - 1))
                createdAt=${createdAt:0:largo}
                log " createdAt:[${createdAt}]"

                local putData=$(echo "${RESPUESTA}" | awk -F "{" '{print $2}' | awk -F "}" '{print$1}')
                log " {${putData}}"
                if [ "${push}" == "true" ]; then 
                    putData=`echo ${putData} | sed -e 's/\"push\_events\"\:false,/\"push\_events\"\:true,/g'`
                else
                    putData=`echo ${putData} | sed -e 's/\"push\_events\"\:true,/\"push\_events\"\:false,/g'`
                fi
                putData=`echo ${putData} | sed -e 's/\"id\":/\"hook_id\":/g'`
                putData=`echo ${putData} | sed -e "s/\"project_id\":/\"id\":/g"`
                putData=`echo ${putData} | sed -e "s/\"created_at\":\"${createdAt}\",//g"`
                log " {${putData}}"
                RESPUESTA=$(curl --silent -X PUT -H "Content-Type: application/json" -H "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}"  -d "{${putData}}" "${GITLAB__API_URL}/projects/${idProject}/hooks/${idHooks}") || exit 1
                if [ $? == 0 ]; then
                    log " El curl de actualizacion del Hook ha ido bien"
                    log ${RESPUESTA} 
                    local pushEvents=$(echo ${RESPUESTA} | jq --raw-output '.push_events')
                    largo=${#pushEvents}
                    ((largo = largo - 1))
                    pushEvents=${pushEvents:0:largo}
                    log " pushEvents:[${pushEvents}]"
                    if [ "${pushEvents}" == "true" ]; then 
                        log " Webhook ACTIVO en [${agrp},${appl}]"
                    else
                        log " Webhook IN-ACTIVO en [${agrp},${appl}]"
                    fi
                    retWebhooks=true
                fi 
            else
                log " HAY [${nWebhooks}] webHooks definidos en [${agrp},${appl}]"
            fi
        fi
    fi 

}



# ========================================================
# =============   P R I N C I P A L    ===================
# ========================================================

if [ ! -f "_git.properties" ]; then 
    ./git_properties.sh
fi 
# Cargamos usuario y password 
# USERGIT=
# PASSGIT=
source _git.properties

FILELOG=/tmp/proceso_Cambio_Jenkinsfile.log
PROC=$0
FILEIN=agrupa_nombre.txt 

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

for line in $(cat ${FILEIN}); do 
    agrp=`echo ${line} | awk -F "," '{print $1}'`
    appl=`echo ${line} | awk -F "," '{print $2}'`
    log "====================================================================="
    log "Trabajando sobre [${agrp},${appl}]"
    log "====================================================================="
    log "Desactivando Webhook en [${agrp},${appl}]"
    retWebhooks=false
    modificarWebHook false
    if [ $? == 0 ] && [ "${retWebhooks}" == "true" ]; then
        log "Cambiando Jenkinsfiles en [${agrp},${appl}]"
        cambiaJenkinsfile
        log "Activando Webhook en [${agrp},${appl}]"
        modificarWebHook true
    else
        log "ERROR al modificar Webhook [$?] en [${agrp},${appl}]"
    fi
done

exit 0

