#!/bin/bash

set -ex

: ${HOST_IN:=0}
: ${PORT_IN:=8100}
: ${LANG:='C.UTF-8'}

SOFFICE_ARGS=(
    "--accept=socket,host=${HOST_IN},port=${PORT_IN},tcpNoDelay=1;urp"
    "--headless"
    "--invisible"
    "--nodefault"
    "--nofirststartwizard"
    "--nolockcheck"
    "--nologo"
    "--norestore"
)

soffice "${SOFFICE_ARGS[@]}"
