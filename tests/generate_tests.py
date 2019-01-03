#!/usr/bin/env python3

''' generates a tests.pro file by crawling the directory and generating a subdirs
	entry for each subdirectory '''

import os

with open(os.path.dirname(os.path.realpath(__file__)) + "/tests.pro", "w") as projectfile:
    projectfile.write("TEMPLATE=subdirs\nSUBDIRS= \\\n")
    PATH = os.path.dirname(os.path.realpath(__file__))
    for item in os.listdir(PATH):
        if os.path.isdir(os.path.join(PATH, item)):
            projectfile.write(item + " \\\n")
