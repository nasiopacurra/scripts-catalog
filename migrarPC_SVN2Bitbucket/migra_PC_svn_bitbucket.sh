#!/bin/bash

# ========================================================
# =============   F U N C I O N E S    ===================
# ========================================================

# Proceso de migracion de REPO de SVN a Bitbucket
function migrar_SVN2Bitbucket {

    local REPO=$1
    local REPOSVN="http://srxmsubversion.mutua.es/svn/OFIPROY/Testing/PrjsMMA"
    local REPOGIT="http://${USERGIT}:${PASSGIT}@git.mutua.es"

    svn export --force --username testsvn --password SVNMutua01 --non-interactive ${REPOSVN}/${REPO}/trunk /tmp/${REPO}
    rm -fr /tmp/${REPO}/ejecuciones/*.tar.gz
    rm -fr /tmp/${REPO}/.svn
    dos2unix -q /tmp/${REPO}/*.sh
    chmod +x /tmp/${REPO}/*.sh

    curl -X POST -H "Content-Type: application/json" -d "{\"name\":\"${REPO,,}\",\"scmId\":\"git\",\"forkable\": false}" "${REPOGIT}/rest/api/1.0/projects/PC/repos"

    local PWD_OLD=`pwd`
    cd /tmp/${REPO}
    git init
    git add --all
    git commit -m "Initial Commit"
    git remote add origin ${REPOGIT}/scm/pc/${REPO,,}.git
    git config --global user.name "Angel Pablo Mateos Sanz"
    git config --global user.email "amateos@mutua.es"
    git push -u origin master
    cd ${PWD_OLD}
    rm -fr /tmp/${REPO}

}

# Proceso para actualizar directorio de AppPAC
# $1 - Directorio del AppPAC
# $2 - Repositorio en Bitbucket
function actualizar_DIR_AppPAC {

    local REPOGIT=http://gitreader:gitreader2018@git.mutua.es
    local DIRPAC=$1
    local REPO=$2

    local DIRTEMP=`mktemp -d`
    echo ">> Creamos directorio temporal [${DIRTEMP}]"
    echo ">> Comprobamos que no existe el directorio [${DIRTEMP}/${REPO,,}]"
    if [ -d ${DIRTEMP}/${REPO,,} ]; then
        echo ">> Borrando el directorio [${DIRTEMP}/${REPO,,}]"
        rm -fr ${DIRTEMP}/${REPO,,}
        echo ">> Retorno [$?]"
    fi
    local PWD_OLD=`pwd`
    cd ${DIRTEMP}
    echo ">> Clonamos el repositorio de Bitbucket [../scm/pc/${REPO,,}.git]"
    git clone ${REPOGIT}/scm/pc/${REPO,,}.git
    echo ">> Retorno [$?]"
    cd ${DIRTEMP}/${REPO,,}
    echo ">> Obtenemos la rama  [origin/master]"
    git checkout origin/master
    echo ">> Retorno [$?]"
    echo ">> Convertimos shellscripts a formato unix  [dos2unix *.sh]"
    dos2unix -q ${DIRTEMP}/${REPO,,}/*.sh
    echo ">> Retorno [$?]"
    echo ">> Damos permisos de ejecucion a los shellscripts [chmod +x *.sh]"
    chmod +x ${DIRTEMP}/${REPO,,}/*.sh
    echo ">> Retorno [$?]"
    echo ">> Borramos directorio de configuracion de git [rm .git]"
    rm -fr ${DIRTEMP}/${REPO,,}/.git
    echo ">> Retorno [$?]"
    echo ">> Actualizamos directorio del proyecto AppPAC [${DIRPAC}]"
    cp -r ${DIRTEMP}/${REPO,,}/. ${DIRPAC}
    echo ">> Retorno [$?]"
    cd ${PWD_OLD}
    echo ">> Borramos directorio temporal [${DIRTEMP}]"
    rm -fr ${DIRTEMP}
    echo ">> Retorno [$?]"

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

# migrar_SVN2Bitbucket AHMH11PPRIVAPC
# migrar_SVN2Bitbucket CMGC11PIGLOBFIPC
# 
# migrar_SVN2Bitbucket ASMU12PHSWEB
# migrar_SVN2Bitbucket COFI12P146
# migrar_SVN2Bitbucket COPR12RPPRIV2
# migrar_SVN2Bitbucket DIOR12SSUBAST
# migrar_SVN2Bitbucket DIPR12RREFARPC
# migrar_SVN2Bitbucket PRTE12PEXPER
# migrar_SVN2Bitbucket REDE12RDESDIREC
# migrar_SVN2Bitbucket REPR12PCOMPAPC
# migrar_SVN2Bitbucket SIAR12RBUSMEPC
# migrar_SVN2Bitbucket SICA12RMEUGRPC
# migrar_SVN2Bitbucket SIDE12A453F2PC
# migrar_SVN2Bitbucket SIDE12PMOBNOT
# migrar_SVN2Bitbucket SIDE12PREFACMUT
# migrar_SVN2Bitbucket SIDE12RASNEHPC
# migrar_SVN2Bitbucket SIDE12RASNEWPC
# migrar_SVN2Bitbucket SIDE12RBONIFPC
# migrar_SVN2Bitbucket SIDE12RSGEW8PC
# migrar_SVN2Bitbucket SIDE12RSTACEPC
# migrar_SVN2Bitbucket SIDE12RSTANEPC
# migrar_SVN2Bitbucket SIDE12RVIDAW8
# migrar_SVN2Bitbucket SIOF12A453F1PC
# migrar_SVN2Bitbucket SIOF12A453F5PC
# migrar_SVN2Bitbucket SIOF12A453F7PC
# migrar_SVN2Bitbucket SIOF12A453F8PC
# migrar_SVN2Bitbucket SIOF12A453F9PC
# migrar_SVN2Bitbucket SIOF12A453FXPC
# migrar_SVN2Bitbucket SIOF12PACCESOS
# migrar_SVN2Bitbucket SIOF12R144PC
# migrar_SVN2Bitbucket SIOF12RSERVDPC
# migrar_SVN2Bitbucket SIOP12GSGESWBPC
# migrar_SVN2Bitbucket SISE12RREGISAC
# migrar_SVN2Bitbucket SITE12P1115
# migrar_SVN2Bitbucket SITE12P1122
# migrar_SVN2Bitbucket SITE12PAWAS8PC
# migrar_SVN2Bitbucket SITE12PSTARWPC
# migrar_SVN2Bitbucket SITE12PTARIFPC

# migrar_SVN2Bitbucket ASMU13PMOTOR
# migrar_SVN2Bitbucket ASMU13PSIREP
# migrar_SVN2Bitbucket COCO13RACTSUBSO
# migrar_SVN2Bitbucket COFU13R13747
# migrar_SVN2Bitbucket DICA13P12172
# migrar_SVN2Bitbucket DIPR13P11725
# migrar_SVN2Bitbucket DIPR13R3000
# migrar_SVN2Bitbucket DIPR13R4000
# migrar_SVN2Bitbucket ESNE13PTALLER
# migrar_SVN2Bitbucket MUCO13RMUTPESTR
# migrar_SVN2Bitbucket ORSU13PGLOPD
# migrar_SVN2Bitbucket REPR13PPARKINGS
# migrar_SVN2Bitbucket SACL13R1003
# migrar_SVN2Bitbucket SESE13R12113
# migrar_SVN2Bitbucket SIDE13P12333
# migrar_SVN2Bitbucket SIDE13P286PC
# migrar_SVN2Bitbucket SIDE13PCTZMMG
# migrar_SVN2Bitbucket SIDE13PGESTAUT
# migrar_SVN2Bitbucket SIDE13PMVSAMDB2
# migrar_SVN2Bitbucket SIDE13PREFASEII
# migrar_SVN2Bitbucket SIDE13R799
# migrar_SVN2Bitbucket SIDE13RINDEXDAT
# migrar_SVN2Bitbucket SIOF13PACCESOS
# migrar_SVN2Bitbucket SIOF13PGCONFIGU
# migrar_SVN2Bitbucket SIOF13PMEJSDESK
# migrar_SVN2Bitbucket SIOF13RPCSQL
# migrar_SVN2Bitbucket SISI13PGESTASK
# migrar_SVN2Bitbucket SISI13RMIGSEG
# migrar_SVN2Bitbucket SITE13P12531
# migrar_SVN2Bitbucket SITE13P12532
# migrar_SVN2Bitbucket SITE13PWAS8
# migrar_SVN2Bitbucket SITE13R11743
# 
# migrar_SVN2Bitbucket ASMU14PPPHF2
# migrar_SVN2Bitbucket ASMU14RHERRCOMU
# migrar_SVN2Bitbucket COCO14RSUBSOLID
# migrar_SVN2Bitbucket COFU14R13747
# migrar_SVN2Bitbucket DICA14PCTIMULTI
# migrar_SVN2Bitbucket DIDI14P21572
# migrar_SVN2Bitbucket DIDI14PMANTEVOL
# migrar_SVN2Bitbucket DIDI14PMOVITIEN
# migrar_SVN2Bitbucket DIPR14P11855
# migrar_SVN2Bitbucket DIPR14P12122
# migrar_SVN2Bitbucket DIPR14PMODCONS
# migrar_SVN2Bitbucket DIPR14RSINANAL
# migrar_SVN2Bitbucket DIWE14PPREFOR
# migrar_SVN2Bitbucket DIWE14PPRIVCRM
# migrar_SVN2Bitbucket DIWE14PWACM
# migrar_SVN2Bitbucket INGE14O19051
# migrar_SVN2Bitbucket PRGE14SSPXVYA0
# migrar_SVN2Bitbucket SESE14R12113
# migrar_SVN2Bitbucket SICA14RFNE8CK3
# migrar_SVN2Bitbucket SICA14RRECOM06
# migrar_SVN2Bitbucket SIDE14P11753
# migrar_SVN2Bitbucket SIDE14PCMSCONN
# migrar_SVN2Bitbucket SIDE14PPOCTERM
# migrar_SVN2Bitbucket SIDE14PSEGCOPC
# migrar_SVN2Bitbucket SIDE14RASDF3434
# migrar_SVN2Bitbucket SIDE14RAUMEGTPI
# migrar_SVN2Bitbucket SIDE14RBUROFAX
# migrar_SVN2Bitbucket SIDE14RTARIFS
# migrar_SVN2Bitbucket SIOF14APCARGA
# migrar_SVN2Bitbucket SIOF14PMEJSDESK
# migrar_SVN2Bitbucket SIOF14R19845
# migrar_SVN2Bitbucket SIOF14RDEGCAMBI
# migrar_SVN2Bitbucket SIOF14RGIMPLANT
# migrar_SVN2Bitbucket SIOF14RGPRYREPO
# migrar_SVN2Bitbucket SIOF14RPCSQL
# migrar_SVN2Bitbucket SIOF14STXTSEAR
# migrar_SVN2Bitbucket SITE14A19961
# migrar_SVN2Bitbucket SITE14AADFASDF3

# migrar_SVN2Bitbucket ASCA15RVISOR
# migrar_SVN2Bitbucket ASSI15R0000401
# migrar_SVN2Bitbucket ASSI15R0000511
# migrar_SVN2Bitbucket AUCU15RBLQSINI
# migrar_SVN2Bitbucket COCO15RREDSUBA
# migrar_SVN2Bitbucket DICA15P26792
# migrar_SVN2Bitbucket DICA15PCTIMULTI
# migrar_SVN2Bitbucket DIGE15PVISIONE
# migrar_SVN2Bitbucket DIGE15RDEPRIUN
# migrar_SVN2Bitbucket DIGE15RGTAREAS
# migrar_SVN2Bitbucket DIGE15RPR2014
# migrar_SVN2Bitbucket DIGE15SNOTIFIC
# migrar_SVN2Bitbucket DIPR15P27216
# migrar_SVN2Bitbucket DIPR15PBPSA
# migrar_SVN2Bitbucket ESES15P31974
# migrar_SVN2Bitbucket ESES15P31975
# migrar_SVN2Bitbucket ESES15R31942
# migrar_SVN2Bitbucket ESES15RAGR2014
# migrar_SVN2Bitbucket INAD15RMANTEMI
# migrar_SVN2Bitbucket REPR15REMEGENC
# migrar_SVN2Bitbucket SIDE15R26719
# migrar_SVN2Bitbucket SIDE15R28495
# migrar_SVN2Bitbucket SIDE15RID26718
# migrar_SVN2Bitbucket SIGE15RCMSCATS
# migrar_SVN2Bitbucket SIOF15RSDARQUI
# migrar_SVN2Bitbucket SISI15PID29182
# migrar_SVN2Bitbucket SITE15PPRUSESIO
# 
# migrar_SVN2Bitbucket AUAU16R4ND5FPC
# migrar_SVN2Bitbucket AUAU16R4ND5GPC
# migrar_SVN2Bitbucket AUAU16R4ND5HPC
# migrar_SVN2Bitbucket AUAU16R4ND5IPC
# migrar_SVN2Bitbucket AUAU16R4ND5JPC
# migrar_SVN2Bitbucket AUAU16R4ND5KPC
# migrar_SVN2Bitbucket AUAU16R4ND5LPC
# migrar_SVN2Bitbucket AUAU16RBLOLOPD
# migrar_SVN2Bitbucket AUAU16SQTARDEV
# migrar_SVN2Bitbucket AUGE16R2QUM9ZK
# migrar_SVN2Bitbucket COCO16SSUBAS17
# migrar_SVN2Bitbucket DIDI16OEVOLUTI
# migrar_SVN2Bitbucket ESES16P35184
# migrar_SVN2Bitbucket HOAC16P38040
# migrar_SVN2Bitbucket HOCO16P36576
# migrar_SVN2Bitbucket HOHO16PEACAL
# migrar_SVN2Bitbucket NEGE16R4ND5EPX
# migrar_SVN2Bitbucket NEGE16RCAJ2KBI
# migrar_SVN2Bitbucket NENE16P35109
# migrar_SVN2Bitbucket PRPR16RAUTALLE
# migrar_SVN2Bitbucket SIAP16P37372
# migrar_SVN2Bitbucket SIAP16REACA3PC
# migrar_SVN2Bitbucket SIAP16RPOMEDPC
# migrar_SVN2Bitbucket SICE16RCOMCOPC
# migrar_SVN2Bitbucket SICE16RENTTEPC
# migrar_SVN2Bitbucket SICE16RNOTGAPC
# migrar_SVN2Bitbucket SIGO16P35180
# migrar_SVN2Bitbucket SIGO16P35277
# migrar_SVN2Bitbucket SIPR16RJUNTA
# migrar_SVN2Bitbucket SISI16PEACAL
# migrar_SVN2Bitbucket SISI16RAPITJ
# migrar_SVN2Bitbucket SISI16SMIGRPOR
# migrar_SVN2Bitbucket SISI16SSOPSIST
# migrar_SVN2Bitbucket SURI16P35734
# migrar_SVN2Bitbucket TRTR16P35072
# migrar_SVN2Bitbucket TRTR16P43709
# migrar_SVN2Bitbucket TRTR16PAPIHO
# migrar_SVN2Bitbucket TRTR16RAPICOPC
# migrar_SVN2Bitbucket TRTR16RCOTVIDA
# migrar_SVN2Bitbucket TRTR16RNUWEBPC

migrar_SVN2Bitbucket AUAU17P47584
migrar_SVN2Bitbucket AUGE17R3Y9MGMC
migrar_SVN2Bitbucket AUGE17RL4AQWWT
migrar_SVN2Bitbucket COCO17SSUBAS18
migrar_SVN2Bitbucket COPR17P48738
migrar_SVN2Bitbucket ESES17P35194
migrar_SVN2Bitbucket NENE17P39723
migrar_SVN2Bitbucket PRTE17P37238
migrar_SVN2Bitbucket SIAP17RBOT01PC
migrar_SVN2Bitbucket SIAP17RBOT02PC
migrar_SVN2Bitbucket SIAP17RCOMCOPC
migrar_SVN2Bitbucket SIAP17RFUN01PC
migrar_SVN2Bitbucket SIAP17SMOXB62B
migrar_SVN2Bitbucket SICE17RCOMCOPC
migrar_SVN2Bitbucket SICE17RENTTEPC
migrar_SVN2Bitbucket SICE17RNOTGAPC
migrar_SVN2Bitbucket SICE17RPLEMPPC
migrar_SVN2Bitbucket SIDI17RWSINFPC
migrar_SVN2Bitbucket SITE17RDRVDBPC
migrar_SVN2Bitbucket TRCA17P43970
migrar_SVN2Bitbucket TRCA17P43974
migrar_SVN2Bitbucket TRCA17P44127
migrar_SVN2Bitbucket TRCA17PPARRILL
migrar_SVN2Bitbucket TRDA17P45213

migrar_SVN2Bitbucket SIAP18RAU001PC
migrar_SVN2Bitbucket SIAP18RAU002PC
migrar_SVN2Bitbucket SIAP18RAU003PC
migrar_SVN2Bitbucket SIAP18RAU004PC
migrar_SVN2Bitbucket SIAP18RAU005PC
migrar_SVN2Bitbucket SIAP18RAU006PC
migrar_SVN2Bitbucket SIAP18RAU007PC
migrar_SVN2Bitbucket SIAP18RAU008PC
migrar_SVN2Bitbucket SIAP18RAU009PC
migrar_SVN2Bitbucket SIAP18RCO001PC
migrar_SVN2Bitbucket SIAP18RCO004PC
migrar_SVN2Bitbucket SIAP18RES001PC
migrar_SVN2Bitbucket SIAP18RES002PC
migrar_SVN2Bitbucket SIAP18RHO001PC
migrar_SVN2Bitbucket SIAP18RHO002PC
migrar_SVN2Bitbucket SIAP18RPR002PC
migrar_SVN2Bitbucket SIAP18RPR003PC
migrar_SVN2Bitbucket SIAP18RPR004PC
migrar_SVN2Bitbucket SIAP18RPR005PC
migrar_SVN2Bitbucket SIAP18RPR006PC
migrar_SVN2Bitbucket SIAP18RSI001PC
migrar_SVN2Bitbucket SIAP18RSI002PC
migrar_SVN2Bitbucket SIAP18RSI004PC
migrar_SVN2Bitbucket SIAP18RSI005PC
migrar_SVN2Bitbucket SIAP18RSI006PC
migrar_SVN2Bitbucket SIAP18RSI007PC
migrar_SVN2Bitbucket SIAP18RSI008PC
migrar_SVN2Bitbucket SIAP18RSI009PC
migrar_SVN2Bitbucket SIAP18RSI010PC
migrar_SVN2Bitbucket SIAP18RSI011PC
migrar_SVN2Bitbucket SIAP18RSI015PC
migrar_SVN2Bitbucket SIAP18RVI001PC
migrar_SVN2Bitbucket SICE18RAU003PC
migrar_SVN2Bitbucket SICE18RCO001PC
migrar_SVN2Bitbucket SICE18RCO002PC
migrar_SVN2Bitbucket SICE18RCO003PC
migrar_SVN2Bitbucket SICE18RCO004PC
migrar_SVN2Bitbucket SICE18RTR005PC
migrar_SVN2Bitbucket SIDE18RTR001PC
migrar_SVN2Bitbucket SIDE18RTR002PC
migrar_SVN2Bitbucket SIDE18RTR003PC
migrar_SVN2Bitbucket SIDE18RTR004PC
migrar_SVN2Bitbucket SIDI18RTR001PC
migrar_SVN2Bitbucket SIDI18RTR006PC
migrar_SVN2Bitbucket SITE18RPR001PC
migrar_SVN2Bitbucket TRDE18SGEDESMU

# actualizar_DIR_AppPAC /tmp/SIDX18RTR006PC SIDX18RTR006PC

exit 0
