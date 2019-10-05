#!/usr/bin/env python3

''' generates a tests.pro file by crawling the directory and generating a subdirs
	entry for each subdirectory. Additionally it generates a run script for the tests to get executed,
    assuming the binary produced is named like the directory'''

import os

with open(os.path.dirname(os.path.realpath(__file__)) + "/tests.pro", "w") as projectfile:
    with open(os.path.dirname(os.path.realpath(__file__)) + "/run-tests.sh", "w") as runscript:
        projectfile.write("TEMPLATE=subdirs\nSUBDIRS= \\\n")
        runscriptContent = "\
        #!/bin/sh\n\
        set -e\n\
        set -x\n\
        if [ ! -z $1 ]; then\n\
        TEST_ROOT=$1\n\
        else\n\
        TEST_ROOT=.\n\
        fi\n"
        runscript.write(runscriptContent)
        PATH = os.path.dirname(os.path.realpath(__file__))
        for item in os.listdir(PATH):
            if os.path.isdir(os.path.join(PATH, item)):
                projectfile.write(item + " \\\n")
                runscript.write("timeout 10s $TEST_ROOT/" +
                                item + "/" + item + "\n")
os.chmod(os.path.dirname(os.path.realpath(__file__)) + "/run-tests.sh", 0o744)
