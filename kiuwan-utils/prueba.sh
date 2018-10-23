#!/bin/bash
#

KLAPATH=/Users/angel_mateos/Apps/KiuwanLocalAnalyser

# Parametros del Agente Kiuwan
# -n <subsistema>            --> tiene que estar dado de alta en Kiuwan
# -s <pathDir>               --> ruta de los fuentes
# -cr <changeRequest>        --> Codigo de trabajo
# -l <label>                                                        --> Etiqueta del analisis (Aplicacion + Version)
# -wr <waitresults>          --> (para que te devuelva el codigo de retorno, espera resultados auditoria
# -crs <changeRequestStatus> --> Snapshot -> inprogress, Release->resolved

DIRKW=/Users/angel_mateos/scripts/hellWorld
APPL=appcalidad-scs-pruebaAMS
VERS=0.0.0
KWUO=Calidad_y_Testing

KWLABEL=${APPL}_${VERS}
KWCR=99999
KWPROVIDER=MMA
KWMODEL=CQM_Blocker
KWAUDIT=AuditoriaCtoDesarrollo
KWARQ=Distribuido
# comprobamos que contenga el string -lib- para ser Libreria
if [[ `echo ${APPL} | grep -i '-lib-'` ]] then;
    KWTIPOSW=Libreria
else
    KWTIPOSW=AplicacionWeb
fi
PARMS=""
PARMS="${PARMS} -m ${KWMODEL}"
PARMS="${PARMS} -s ${DIRKW}"
PARMS="${PARMS} -cr ${KWCR}"
PARMS="${PARMS} -l ${KWLABEL}"
PARMS="${PARMS} -wr"
PARMS="${PARMS} -crs inprogress"
PARMS="${PARMS} .kiuwan.analysis.audit=${KWAUDIT}"
PARMS="${PARMS} .kiuwan.application.provider=${KWPROVIDER}"
PARMS="${PARMS} .kiuwan.application.portfolio.Arquitectura=${KWARQ}"
PARMS="${PARMS} .kiuwan.application.portfolio.UO=${KWUO}"
PARMS="${PARMS} .kiuwan.application.portfolio.TipoSoftware=${KWTIPOSW}"

# comprobar que exista la APPL en Kiuwan
#
# TODO -> llamada al API
#
# if No Existe
#     Creamos la aplicacion en vacio
#              PARMS=""
#              PARMS="${PARMS} -m ${KWMODEL}"
#              PARMS="${PARMS} -s ${DIRKW}"
#              PARMS="${PARMS} --user ${USERKW}"
#              PARMS="${PARMS} --pass ${PASSKW}"
#              PARMS="${PARMS} .kiuwan.analysis.audit=${KWAUDIT}"
#              PARMS="${PARMS} .kiuwan.application.provider=${KWPROVIDER}"
#    PARMS="${PARMS} .kiuwan.application.portfolio.Arquitectura=${KWARQ}"
#              PARMS="${PARMS} .kiuwan.application.portfolio.UO=${KWUO}"
#              PARMS="${PARMS} .kiuwan.application.portfolio.TipoSoftware=${KWTIPOSW}"
#              ./agent.sh -c -n ${APPL} ${PARMS} > ${FILEOUT}
PWD_BACK=`pwd`
cd $KLAPATH/bin
log "Lanzando agente Kiuwan (${KLAPATH}/bin)"
log "./agent.sh -n ${APPL} ${PARMS}"

./agent.sh -n $APPL $PARMS 
EXIT_F="$?"
log "Codigo de Retorno: [$EXIT_F] "
cd ${PWD_BACK}
