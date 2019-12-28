# Creating the environment populated with the package in mkconda takes
# takes up to 30 min to solve the dependencies, so TravisCI usually times out.
# So prebuild mkconda locally and export the run environment recipe and 
# have TravisCI build and mkconda env from that ... much quicker.
SHELL = /usr/bin/bash
$HOME = $(pwd)

mkconda:
	./scripts/create.sh

