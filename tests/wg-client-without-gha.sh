#!/bin/bash
set -o errexit -o pipefail -o nounset -o xtrace

# This file is for local test purposes only. You can do the following to test:
# ./wg-server.sh CREATE
# .wg-client-without-gha.sh
# ./wg-server.sh DESTROY
# Note: this leak a wireguard client interface at each run.

#WG_SERV_PRIV_KEY="OFQrPNwnwIEYxn7roNLCnrKXCN8dkaoSYwPh7REvkmg="
WG_SERV_PUB_KEY="gHF6vSiGLl/qbZQDSb6kC65RxQq5bEIGDJIuyWxxgy0="
WG_CLIENT_PRIV_KEY="IKgP085Cw91kP73B/76dRUxjJ6Rrz8azfavtj9SDzHA="
#WG_CLIENT_PUB_KEY="H1UIXYpjv1qBrT3JtK5DEcGtGYMcCEBL5jfj+bEXEl0="
WG_PSK="G0gmiQgbUDUR92M2WwsHgt3LCIjCzhsS16xwHBbN2MM="

export ARG_ENDPOINT="10.1.1.1:51820"
export ARG_ENDPOINT_PUBLIC_KEY="${WG_SERV_PUB_KEY}"
export ARG_ASSIGNED_IPS="10.10.1.2"
export ARG_ALLOWED_IPS="10.10.1.0/24,10.2.1.0/24"
export ARG_PRIVATE_KEY="${WG_CLIENT_PRIV_KEY}"
export ARG_PRESHARED_KEY="${WG_PSK}"
export ARG_KEEPALIVE="25"

../wg-setup.sh

sleep 5 # Give some time to wireguard to establish the connection
ping -c1 10.10.1.1
ping -c1 10.2.1.2
