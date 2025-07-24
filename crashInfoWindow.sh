#!/bin/bash
#eton@240914 using add LD_LIBRARY_PATH as function
#eton@250425 add dbus env variable
#eton@250509 add display check before run scd.
#eton@250724 add crashInfoWindow support.


if grep -q -P 'screenDisplay|crashInfoWindow' <<< $(basename $0) ;then
	echo -e -n "GUI-App: checkDisplay..."
	test ${DISPLAY:-None} == 'None' && echo "No Display exit 1" && exit 1
	echo "GUI-APP: Display present=${DISPLAY}"
else
	echo "not GUI-APP, ignore display check."
fi

BASE_DIR=$(dirname "$(readlink -f "$0")")
source "${BASE_DIR}/02-addLocalRPath.sh"
#source "${BASE_DIR}/03-color-msg.sh"

IS_PRODUCTION=${SIHO_PROD:-0}
if test ${IS_PRODUCTION} -eq 0;then 
	echo "In Development ENV, set unlimited..."
	ulimit -c unlimited
else
	echo "In Production ENV, set ulimit=0"
	ulimit -c 0 
fi

_APP="${SIHOBIN_DIR}/${AppName}"

#export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus #not needed when in user section
chmod +x ${_APP} 
${_APP} "$@"
AppReturn=$?
chmod -x ${_APP} 
echo "<$0> run return=[$AppReturn] end."
exit $AppReturn

