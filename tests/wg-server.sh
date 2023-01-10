#!/bin/bash
set -o errexit -o pipefail -o nounset -o xtrace

# Use the argument "CREATE" in order to create the server and "DESTROY" to
# clean up.

# This script installs wireguard and create a wireguard server in the network
# namespace "wg-server". Routing and IPs are set such that the main netns can
# speak to the wireguard server IP 10.1.1.1/24 via its own IP 10.1.1.2/24. A
# dummy target 10.2.1.2/24 is only accessible from the namespace "wg-server".

# The keys used by this script are hardcoded as we don't care to leak them and
# it eases everything.
WG_SERV_PRIV_KEY="OFQrPNwnwIEYxn7roNLCnrKXCN8dkaoSYwPh7REvkmg="
#WG_SERV_PUB_KEY="gHF6vSiGLl/qbZQDSb6kC65RxQq5bEIGDJIuyWxxgy0="
#WG_CLIENT_PRIV_KEY="IKgP085Cw91kP73B/76dRUxjJ6Rrz8azfavtj9SDzHA="
WG_CLIENT_PUB_KEY="H1UIXYpjv1qBrT3JtK5DEcGtGYMcCEBL5jfj+bEXEl0="
WG_PSK="G0gmiQgbUDUR92M2WwsHgt3LCIjCzhsS16xwHBbN2MM="

ACTION="${1}"
shift

install_wg_tools() {
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends wireguard-tools
}

configure_ns() {
    # Configure net ns wg-server and links
    sudo ip netns add wg-server
    sudo ip link add wg-link-client type veth peer name wg-link-server
    sudo ip link set wg-link-server netns wg-server
    sudo ip netns exec wg-server ip addr add 10.1.1.1/24 dev wg-link-server
    sudo ip netns exec wg-server ip link set wg-link-server up
    sudo ip addr add 10.1.1.2/24 dev wg-link-client
    sudo ip link set wg-link-client up

    # In order to have an IP that cannot be joined without being on the netns,
    # we use the loopback interface and assign a new ip to it.
    sudo ip netns exec wg-server ip link set lo:100 up
    sudo ip netns exec wg-server ip addr add 10.2.1.2/24 dev lo:100

    sudo ip netns exec wg-server sysctl net.ipv4.ip_forward=1
}

cleanup_ns() {
    sudo ip netns del wg-server
    sudo ip link del wg-link-client
}

configure_wg() {
    cat <<EOF | sudo tee /etc/wireguard/wg0.conf
[Interface]
PrivateKey = ${WG_SERV_PRIV_KEY}
Address = 10.10.1.1/24
ListenPort = 51820

[Peer]
PublicKey = ${WG_CLIENT_PUB_KEY}
PresharedKey = ${WG_PSK}
AllowedIPs = 0.0.0.0/0
EOF
    sudo ip netns exec wg-server wg-quick up wg0
}

check_ns_connectivity() {
    if ping -c 1 10.1.1.1 > /dev/null; then
      echo "Ping successful, wg network ready to be used"
    else
      echo "Error: Unable to ping 10.1.1.1"
    fi
}

if [ "$ACTION" == "CREATE" ]; then
    install_wg_tools
    configure_ns
    check_ns_connectivity
    configure_wg
fi

if [ "$ACTION" == "DESTROY" ]; then
    cleanup_ns
fi
