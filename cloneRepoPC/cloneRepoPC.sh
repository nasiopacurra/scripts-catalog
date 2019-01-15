#!/bin/bash
#
# $1 414208_SIAP19RCO002PC_SalesforceApiPersonas
#
# ========================================================
# =============   F U N C I O N E S    ===================
# ========================================================
function log { 
	local FECHA=`date "+%Y%m%d%H%M%S"`
	echo "[ $$ $0 $FECHA ] $1 "
}

# ========================================================
# =============   P R I N C I P A L    ===================
# ========================================================

if [ $# != 1 ]; then 
	log "Debes poner un parametro como 414208_SIAP19RCO002PC_SalesforceApiPersonas "
	exit 1
fi
DIRPRJS=$1
log "Parametro: [${DIRPRJS}]"
if [ "${DIRPRJS:6:1}" != "_" ] || [ "${DIRPRJS:21:1}" != "_" ]; then 
	log "Debes poner formato como 414208_SIAP19RCO002PC_SalesforceApiPersonas "
	exit 1
fi
log "Formato de parametro CORRECTO"
CODETRABA=${DIRPRJS:0:6}
CODEREPO=${DIRPRJS:7:14}
CODENAME=${DIRPRJS:22}

if [ ! -f "_git.properties" ]; then
	log "NO Existe fichero de propiedades para GIT"
    ./git_properties.sh AMASA3W
fi 
# Cargamos usuario y password 
# USERGIT=
# PASSGIT=
log "Cargando fichero de propiedades para GIT"
source _git.properties

if [ ! -z ${PASSGIT} ] && [ "${USERGIT,,}" == "amasa3w" ]; then 
	log "Configurando parametros de usuario para llamada a GIT"
	git config --global user.name "Angel Pablo Mateos Sanz"
	git config --global user.email "amateos@mutua.es"
fi

URLGITPC=http://git.mutua.es/scm/pc
# C:\Users\AMASA3W\Documents\PrjsMMA\414208_SIAP19RCO002PC_SalesforceApiPersonas
# /cygdrive/c/Users/AMASA3W/Documents/PrjsMMA/414208_SIAP19RCO002PC_SalesforceApiPersonas
PATHPRJS=/cygdrive/c/Users/AMASA3W/Documents/PrjsMMA

log "Numero de Trabajo: [${CODETRABA}]"
log "Codigo de Trabajo: [${CODEREPO}]"
log "Descripcion Corta: [${CODENAME}]" 

URLGIT=`echo "${URLGITPC}/${CODEREPO,,}.git" | sed -e "s/http\:\/\//http\:\/\/${USERGIT}\:${PASSGIT}\@/g"`
URLGIT_text=`echo "${URLGITPC}/${CODEREPO,,}.git" | sed -e "s/http\:\/\//http\:\/\/${USERGIT}\@/g"`
log "Repositorio Remote en Git: [${URLGIT_text}]"

OLDPWD='pwd'
if [ -d "${PATHPRJS}/${DIRPRJS}" ]; then 
	log "Ya existe directorio [${PATHPRJS}/${DIRPRJS}]"
	cd ${PATHPRJS}/${DIRPRJS}
	log "Visualizando rama actual en el repositorio local"
	git branch -a
	log "Comparando repositorio local con remoto"
	git fetch origin
	git merge origin/master
	log "Actualizando repositorio local"
	git pull origin master	
else
	log "No existe directorio [${PATHPRJS}/${DIRPRJS}]"
	log "Realizando clone"
	git clone ${URLGIT} ${PATHPRJS}/${DIRPRJS}
	cd ${PATHPRJS}/${DIRPRJS}
	log "Inicializando repositorio local"
	git init
	log "Creando .gitignore"
	touch .gitignore
	if [ ! -d "log" ]; then 
		log "Creando directorio de ./log en repositorio"
		echo "log/" >> .gitignore
		mkdir log
	fi
	if [ ! -d "datos" ]; then 
		log "Creando directorio de ./datos en repositorio"
		echo "datos/" >> .gitignore
		mkdir datos
	fi
fi
cd ${OLDPWD}
log "Contenido del repositorio local"
ls -la ${PATHPRJS}/${DIRPRJS}

exit 0

