#!/bin/bash -x
#

# ========================================================
# =============   F U N C I O N E S    ===================
# ========================================================

# Funccion de migracion de REPO de GitLab/BitbucketServer a BitbucketDataCenter
# $1 - Nombre del repositorio en Origen
# $2 - Identificador de Proyecto/Agrupacion en Origen
# $3 - Identificador de Proyecto/Agrupacion en Destino
# 
# NOTAS: 
# - El repositorio destino no tiene que existir
# - La agrupacion destino DEBE EXISTIR
#
function migrarRepo {

    local REPO_NAME=$1
    local PROJECT_ORIG=$2
    local PROJECT_DEST=$3

    echo "Creando Repositorio en Destino: [${PROJECT_DEST}/${REPO_NAME,,}]"
    local curl_status=$(curl -s -o /dev/null -w '%{http_code}' -L --insecure -X POST -H "Content-Type: application/json" -d "{\"name\":\"${REPO_NAME,,}\",\"scmId\":\"git\",\"forkable\": false}" "${GIT_DEST}/rest/api/1.0/projects/${PROJECT_DEST}/repos")
    echo "Return Crear Repositorio en Destino: [${curl_status}]"
    if [ "${curl_status}" == "201" ]; then
        local GITLAB_URL=${GIT_ORIG}/scm/${PROJECT_ORIG}/${REPO_NAME}.git
        local BITBUCKET_URL=${GIT_DEST}/scm/${PROJECT_DEST}/${REPO_NAME}.git

        git clone --bare ${GITLAB_URL}

        local PWD_OLD=`pwd`
        cd ${REPO_NAME}.git
        git config --global http.sslVerify false
        git remote add bitbucket ${BITBUCKET_URL}
        git push --all bitbucket
        git push --tags bitbucket
        cd ${PWD_OLD}
        rm -fr ${REPO_NAME}.git
    fi 

}

# ========================================================
# =============   P R I N C I P A L    ===================
# ========================================================

if [ ! -f "_git.properties" ]; then 
    ./git_properties.sh
fi 
# Cargamos usuario y password 
source _git.properties
if [ -z ${USERGIT_ORIG} ] || [ -z ${PASSGIT_ORIG} ] || [ -z ${USERGIT_DEST} ] || [ -z ${PASSGIT_DEST} ] ; then
    echo "Faltan credenciales .. "
    exit -1
fi 

GIT_ORIG="http://${USERGIT_ORIG}:${PASSGIT_ORIG}@git.mutua.es"
GIT_DEST="https://${USERGIT_DEST}:${PASSGIT_DEST}@git.globalint.mutua.es"

# Llamadas particulares de migracion

# migrarRepo bigdata-framework-etl APPARQDATOS APPARQDATOS

# migrarRepo jdg-config-pro MIDDLEWARE MIDDLEWARE

# migrarRepo front-dev-portal APPARQ APPARQ
# migrarRepo lib-arch-base APPARQ APPARQ
# migrarRepo sccfg-acp APPARQ APPARQ
# migrarRepo sccfg-dev APPARQ APPARQ
# migrarRepo sccfg-pro APPARQ APPARQ
# migrarRepo sccfg-uat APPARQ APPARQ
# migrarRepo win-indexador-rrhh APPARQ APPARQ
# migrarRepo win-scan-escaner-net APPARQ APPARQ
# migrarRepo win-scan-indexador-java APPARQ APPARQ
# migrarRepo win-scan-monitor-java APPARQ APPARQ
# migrarRepo win-scan-serviceinvoker-net APPARQ APPARQ

# migrarRepo batch-bigdata-fraude-siniestros DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-acquisition DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-analitica-navegacion DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-general DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-ingestion DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-negocio DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-patrimonial-dmactividadcomercial DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-patrimonial-dmactividadcomercialtmp DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-prestaciones-digital DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-scoring DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-scoring-models DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-segmentacion DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-services DIGANALYTICS DIGANALYTICS
# migrarRepo bigdata-spark DIGANALYTICS DIGANALYTICS
# migrarRepo cmdigital-general DIGANALYTICS DIGANALYTICS
# migrarRepo cmdigital-ingestion DIGANALYTICS DIGANALYTICS
# migrarRepo cmdigital-transformation DIGANALYTICS DIGANALYTICS

# migrarRepo front-dev-portal POCARQ POCARQ
# migrarRepo lib-arch-base POCARQ POCARQ
# migrarRepo poc-fuse POCARQ POCARQ
# migrarRepo poc-me-springboot POCARQ POCARQ
# migrarRepo sccfg-acp POCARQ POCARQ
# migrarRepo sccfg-pro POCARQ POCARQ
# migrarRepo sccfg-uat POCARQ POCARQ
# migrarRepo scs-pepito POCARQ POCARQ
# migrarRepo scs-xxx-emilio POCARQ POCARQ

# migrarRepo ahmh11pprivapc PC PC
# migrarRepo asca15rvisor PC PC
# migrarRepo asmu12phsweb PC PC
# migrarRepo asmu13pmotor PC PC
# migrarRepo asmu13psirep PC PC
# migrarRepo asmu14ppphf2 PC PC
# migrarRepo asmu14rherrcomu PC PC
# migrarRepo assi15r0000401 PC PC
# migrarRepo assi15r0000511 PC PC
# migrarRepo auau16r4nd5fpc PC PC
# migrarRepo auau16r4nd5gpc PC PC
# migrarRepo auau16r4nd5hpc PC PC
# migrarRepo auau16r4nd5ipc PC PC
# migrarRepo auau16r4nd5jpc PC PC
# migrarRepo auau16r4nd5kpc PC PC
# migrarRepo auau16r4nd5lpc PC PC
# migrarRepo auau16rblolopd PC PC
# migrarRepo auau16sqtardev PC PC
# migrarRepo auau17p47584 PC PC
# migrarRepo aucu15rblqsini PC PC
# migrarRepo auge16r2qum9zk PC PC
# migrarRepo auge17r3y9mgmc PC PC
# migrarRepo auge17rl4aqwwt PC PC
# migrarRepo cmgc11piglobfipc PC PC
# migrarRepo coco13ractsubso PC PC
# migrarRepo coco14rsubsolid PC PC
# migrarRepo coco15rredsuba PC PC
# migrarRepo coco16ssubas17 PC PC
# migrarRepo coco17ssubas18 PC PC
# migrarRepo cofi12p146 PC PC
# migrarRepo cofu13r13747 PC PC
# migrarRepo cofu14r13747 PC PC
# migrarRepo copr12rppriv2 PC PC
# migrarRepo copr17p48738 PC PC
# migrarRepo dica13p12172 PC PC
# migrarRepo dica14pctimulti PC PC
# migrarRepo dica15p26792 PC PC
# migrarRepo dica15pctimulti PC PC
# migrarRepo didi14p21572 PC PC
# migrarRepo didi14pmantevol PC PC
# migrarRepo didi14pmovitien PC PC
# migrarRepo didi16oevoluti PC PC
# migrarRepo dige15pvisione PC PC
# migrarRepo dige15rdepriun PC PC
# migrarRepo dige15rgtareas PC PC
# migrarRepo dige15rpr2014 PC PC
# migrarRepo dige15snotific PC PC
# migrarRepo dior12ssubast PC PC
# migrarRepo dipr12rrefarpc PC PC
# migrarRepo dipr13p11725 PC PC
# migrarRepo dipr13r3000 PC PC
# migrarRepo dipr13r4000 PC PC
# migrarRepo dipr14p11855 PC PC
# migrarRepo dipr14p12122 PC PC
# migrarRepo dipr14pmodcons PC PC
# migrarRepo dipr14rsinanal PC PC
# migrarRepo dipr15p27216 PC PC
# migrarRepo dipr15pbpsa PC PC
# migrarRepo diwe14pprefor PC PC
# migrarRepo diwe14pprivcrm PC PC
# migrarRepo diwe14pwacm PC PC
# migrarRepo eses15p31974 PC PC
# migrarRepo eses15p31975 PC PC
# migrarRepo eses15r31942 PC PC
# migrarRepo eses15ragr2014 PC PC
# migrarRepo eses16p35184 PC PC
# migrarRepo eses17p35194 PC PC
# migrarRepo esne13ptaller PC PC
# migrarRepo hoac16p38040 PC PC
# migrarRepo hoco16p36576 PC PC
# migrarRepo hoho16peacal PC PC
# migrarRepo inad15rmantemi PC PC
# migrarRepo inge14o19051 PC PC
# migrarRepo muco13rmutpestr PC PC
# migrarRepo nege16r4nd5epx PC PC
# migrarRepo nege16rcaj2kbi PC PC
# migrarRepo nene16p35109 PC PC
# migrarRepo nene17p39723 PC PC
# migrarRepo orsu13pglopd PC PC
# migrarRepo prge14sspxvya0 PC PC
# migrarRepo prpr16rautalle PC PC
# migrarRepo prte12pexper PC PC
# migrarRepo prte17p37238 PC PC
# migrarRepo rede12rdesdirec PC PC
# migrarRepo repr12pcompapc PC PC
# migrarRepo repr13pparkings PC PC
# migrarRepo repr15remegenc PC PC
# migrarRepo sacl13r1003 PC PC
# migrarRepo sese13r12113 PC PC
# migrarRepo sese14r12113 PC PC
# migrarRepo siap16p37372 PC PC
# migrarRepo siap16reaca3pc PC PC
# migrarRepo siap16rpomedpc PC PC
# migrarRepo siap17rbot01pc PC PC
# migrarRepo siap17rbot02pc PC PC
# migrarRepo siap17rcomcopc PC PC
# migrarRepo siap17rfun01pc PC PC
# migrarRepo siap17smoxb62b PC PC
# migrarRepo siap18rau001pc PC PC
# migrarRepo siap18rau002pc PC PC
# migrarRepo siap18rau003pc PC PC
# migrarRepo siap18rau004pc PC PC
# migrarRepo siap18rau005pc PC PC
# migrarRepo siap18rau006pc PC PC
# migrarRepo siap18rau007pc PC PC
# migrarRepo siap18rau008pc PC PC
# migrarRepo siap18rau009pc PC PC
# migrarRepo siap18rau010pc PC PC
# migrarRepo siap18rau011pc PC PC
# migrarRepo siap18rco001pc PC PC
# migrarRepo siap18rco004pc PC PC
# migrarRepo siap18res001pc PC PC
# migrarRepo siap18res002pc PC PC
# migrarRepo siap18rho001pc PC PC
# migrarRepo siap18rho002pc PC PC
# migrarRepo siap18rpr002pc PC PC
# migrarRepo siap18rpr003pc PC PC
# migrarRepo siap18rpr004pc PC PC
# migrarRepo siap18rpr005pc PC PC
# migrarRepo siap18rpr006pc PC PC
# migrarRepo siap18rsi001pc PC PC
# migrarRepo siap18rsi002pc PC PC
# migrarRepo siap18rsi004pc PC PC
# migrarRepo siap18rsi005pc PC PC
# migrarRepo siap18rsi006pc PC PC
# migrarRepo siap18rsi007pc PC PC
# migrarRepo siap18rsi008pc PC PC
# migrarRepo siap18rsi009pc PC PC
# migrarRepo siap18rsi010pc PC PC
# migrarRepo siap18rsi011pc PC PC
# migrarRepo siap18rsi015pc PC PC
# migrarRepo siap18rssi016pc PC PC
# migrarRepo siap18rvi001pc PC PC
# migrarRepo siap19rco002pc PC PC
# migrarRepo siap19rsi001pc PC PC
# migrarRepo siar12rbusmepc PC PC
# migrarRepo siax19rco003pc PC PC
# migrarRepo sica12rmeugrpc PC PC
# migrarRepo sica14rfne8ck3 PC PC
# migrarRepo sica14rrecom06 PC PC
# migrarRepo sice16rcomcopc PC PC
# migrarRepo sice16renttepc PC PC
# migrarRepo sice16rnotgapc PC PC
# migrarRepo sice17rcomcopc PC PC
# migrarRepo sice17renttepc PC PC
# migrarRepo sice17rnotgapc PC PC
# migrarRepo sice17rplemppc PC PC
# migrarRepo sice18rau003pc PC PC
# migrarRepo sice18rco001pc PC PC
# migrarRepo sice18rco002pc PC PC
# migrarRepo sice18rco003pc PC PC
# migrarRepo sice18rco004pc PC PC
# migrarRepo sice18rtr005pc PC PC
# migrarRepo side12a453f2pc PC PC
# migrarRepo side12pmobnot PC PC
# migrarRepo side12prefacmut PC PC
# migrarRepo side12rasnehpc PC PC
# migrarRepo side12rasnewpc PC PC
# migrarRepo side12rbonifpc PC PC
# migrarRepo side12rsgew8pc PC PC
# migrarRepo side12rstacepc PC PC
# migrarRepo side12rstanepc PC PC
# migrarRepo side12rvidaw8 PC PC
# migrarRepo side13p12333 PC PC
# migrarRepo side13p286pc PC PC
# migrarRepo side13pctzmmg PC PC
# migrarRepo side13pgestaut PC PC
# migrarRepo side13pmvsamdb2 PC PC
# migrarRepo side13prefaseii PC PC
# migrarRepo side13r799 PC PC
# migrarRepo side13rindexdat PC PC
# migrarRepo side14p11753 PC PC
# migrarRepo side14pcmsconn PC PC
# migrarRepo side14ppocterm PC PC
# migrarRepo side14psegcopc PC PC
# migrarRepo side14rasdf3434 PC PC
# migrarRepo side14raumegtpi PC PC
# migrarRepo side14rburofax PC PC
# migrarRepo side14rtarifs PC PC
# migrarRepo side15r26719 PC PC
# migrarRepo side15r28495 PC PC
# migrarRepo side15rid26718 PC PC
# migrarRepo side18rtr001pc PC PC
# migrarRepo side18rtr002pc PC PC
# migrarRepo side18rtr003pc PC PC
# migrarRepo side18rtr004pc PC PC
# migrarRepo side18rtr006pc PC PC
# migrarRepo sidi17rwsinfpc PC PC
# migrarRepo sidi18rtr001pc PC PC
# migrarRepo sidi18rtr006pc PC PC
# migrarRepo sidx18rtr006pc PC PC
# migrarRepo sidx18str007pc PC PC
# migrarRepo sige15rcmscats PC PC
# migrarRepo sigo16p35180 PC PC
# migrarRepo sigo16p35277 PC PC
# migrarRepo siof12a453f1pc PC PC
# migrarRepo siof12a453f5pc PC PC
# migrarRepo siof12a453f7pc PC PC
# migrarRepo siof12a453f8pc PC PC
# migrarRepo siof12a453f9pc PC PC
# migrarRepo siof12a453fxpc PC PC
# migrarRepo siof12paccesos PC PC
# migrarRepo siof12r144pc PC PC
# migrarRepo siof12rservdpc PC PC
# migrarRepo siof13paccesos PC PC
# migrarRepo siof13pgconfigu PC PC
# migrarRepo siof13pmejsdesk PC PC
# migrarRepo siof13rpcsql PC PC
# migrarRepo siof14apcarga PC PC
# migrarRepo siof14pmejsdesk PC PC
# migrarRepo siof14r19845 PC PC
# migrarRepo siof14rdegcambi PC PC
# migrarRepo siof14rgimplant PC PC
# migrarRepo siof14rgpryrepo PC PC
# migrarRepo siof14rpcsql PC PC
# migrarRepo siof14stxtsear PC PC
# migrarRepo siof15rsdarqui PC PC
# migrarRepo siop12gsgeswbpc PC PC
# migrarRepo sipr16rjunta PC PC
# migrarRepo sise12rregisac PC PC
# migrarRepo sisi13pgestask PC PC
# migrarRepo sisi13rmigseg PC PC
# migrarRepo sisi15pid29182 PC PC
# migrarRepo sisi16peacal PC PC
# migrarRepo sisi16rapitj PC PC
# migrarRepo sisi16smigrpor PC PC
# migrarRepo sisi16ssopsist PC PC
# migrarRepo site12p1115 PC PC
# migrarRepo site12p1122 PC PC
# migrarRepo site12pawas8pc PC PC
# migrarRepo site12pstarwpc PC PC
# migrarRepo site12ptarifpc PC PC
# migrarRepo site13p12531 PC PC
# migrarRepo site13p12532 PC PC
# migrarRepo site13pwas8 PC PC
# migrarRepo site13r11743 PC PC
# migrarRepo site14a19961 PC PC
# migrarRepo site14aadfasdf3 PC PC
# migrarRepo site15pprusesio PC PC
# migrarRepo site17rdrvdbpc PC PC
# migrarRepo site18rpr001pc PC PC
# migrarRepo suri16p35734 PC PC
# migrarRepo trca17p43970 PC PC
# migrarRepo trca17p43974 PC PC
# migrarRepo trca17p44127 PC PC
# migrarRepo trca17pparrill PC PC
# migrarRepo trda17p45213 PC PC
# migrarRepo trde18sgedesmu PC PC
# migrarRepo trtr16p35072 PC PC
# migrarRepo trtr16p43709 PC PC
# migrarRepo trtr16papiho PC PC
# migrarRepo trtr16rapicopc PC PC
# migrarRepo trtr16rcotvida PC PC
# migrarRepo trtr16rnuwebpc PC PC
# migrarRepo xxxx99paut01pc PC PC
# migrarRepo xxxx99paut02pc PC PC
# migrarRepo xxxx99paut03pc PC PC
# migrarRepo xxxx99paut04pc PC PC
# migrarRepo xxxx99paut05pc PC PC
# migrarRepo xxxx99paut06pc PC PC
# migrarRepo xxxx99paut07pc PC PC
# migrarRepo xxxx99paut08pc PC PC
# migrarRepo xxxx99paut09pc PC PC
# migrarRepo xxxx99paut10pc PC PC
# migrarRepo xxxx99paut11pc PC PC
# migrarRepo xxxx99paut12pc PC PC

exit 0
