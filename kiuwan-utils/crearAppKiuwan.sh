#!/bin/bash
#
function log {
    FECHA=`date "+%Y%m%d%H%M%S"`
    echo "[ $$ $PROC $FECHA ] $1 " 
}

KLAPATH=/Users/angel_mateos/Apps/KiuwanLocalAnalyzer
USERKW="amateos@mutua.es"
PASSKW="K1uwan2017"
# Parametros del Agente Kiuwan
# -n <subsistema>            --> tiene que estar dado de alta en Kiuwan
# -s <pathDir>               --> ruta de los fuentes
# -cr <changeRequest>        --> Codigo de trabajo
# -l <label>                                                        --> Etiqueta del analisis (Aplicacion + Version)
# -wr <waitresults>          --> (para que te devuelva el codigo de retorno, espera resultados auditoria
# -crs <changeRequestStatus> --> Snapshot -> inprogress, Release->resolved

DIRAPPL=/Users/angel_mateos/scripts/helloWorld

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
if [[ `echo ${APPL} | grep -i '-lib-'` ]]; then
    KWTIPOSW=Libreria
else
    KWTIPOSW=AplicacionWeb
fi
PARMS=""
PARMS="${PARMS} -n ${APPL}"
PARMS="${PARMS} -m ${KWMODEL}"
PARMS="${PARMS} -s ${DIRAPPL}"
PARMS="${PARMS} -l ${KWLABEL}"
PARMS="${PARMS} -wr"
PARMS="${PARMS} --user ${USERKW}"
PARMS="${PARMS} --pass ${PASSKW}"
PARMS="${PARMS} .kiuwan.analysis.audit=${KWAUDIT}"
PARMS="${PARMS} .kiuwan.application.provider=${KWPROVIDER}"
PARMS="${PARMS} .kiuwan.application.portfolio.Arquitectura=${KWARQ}"
PARMS="${PARMS} .kiuwan.application.portfolio.UO=${KWUO}"
PARMS="${PARMS} .kiuwan.application.portfolio.TipoSoftware=${KWTIPOSW}"

PWD_BACK=`pwd`
cd ${KLAPATH}/bin
log "Lanzando agente Kiuwan (${KLAPATH}/bin)"
log "./agent.sh -c ${PARMS}"
./agent.sh -c ${PARMS} 
EXIT_F="$?"
log "Codigo de Retorno: [${EXIT_F}] "
cd ${PWD_BACK}
