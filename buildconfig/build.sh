#!/bin/bash
set -x
CI_BUILD=$1
CORE_COUNT=$2
TAIL_LINECOUNT=500
if [ "$CI_BUILD" = 2 ]; then
	echo "Suppressing all make output for CI environments to decrease log size..."
	make -j${CORE_COUNT} > /dev/null 2>&1
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "Running make again to see errors with less output..."
		make > /tmp/makelog 2>&1
		echo "displaying last $TAIL_LINECOUNT lines..."
		tail -n $TAIL_LINECOUNT /tmp/makelog
		exit $RESULT
	fi
elif [ "$CI_BUILD" ]; then
	echo "Suppressing regular make output for CI environments to decrease log size..."
	make -j${CORE_COUNT} > /dev/null
else
	make -j${CORE_COUNT}
fi
