Set up WireGuard
================

[![Test](https://github.com/egor-tensin/setup-wireguard/actions/workflows/test.yml/badge.svg)](https://github.com/egor-tensin/setup-wireguard/actions/workflows/test.yml)

This GitHub action sets up a WireGuard connection in your workflow run.

1. Installs WireGuard if it's missing.
2. Sets up a connection using the provided credentials.

Use it your workflow like this:

    - name: Set up WireGuard
      uses: egor-tensin/setup-wireguard@v1
      with:
        endpoint: 46.46.46.46:51820
        endpoint_public_key: 9IHlvJqgkVWMq57a0A56XI5IjhnL5gaRhI1Pszk7S24=
        ips: 192.168.143.254/24,fd8c:bc10:5021::192.168.143.254/48
        allowed_ips: 192.168.143.0/24,fd8c:bc10:5021::/48
        private_key: GLEiXhRwFuhw8aPy+HQfSMwwoLU0Sw8jE8MOxZ8GV3w=
        preshared_key: PWAfvVWCjiNV0Uh2DhmXhdRaT326qosSOcaDB3j9dwI=

Of couse it's highly advised to store all sensitive data in your repository's
secrets.
It could then become something like:

    - name: Set up WireGuard
      uses: egor-tensin/setup-wireguard@v1
      with:
        endpoint: '${{ secrets.ENDPOINT }}'
        endpoint_public_key: '${{ secrets.ENDPOINT_PUBLIC }}'
        ips: '${{ secrets.IPS }}'
        allowed_ips: '${{ secrets.ALLOWED_IPS }}'
        private_key: '${{ secrets.PRIVATE }}'
        preshared_key: '${{ secrets.PRESHARED }}'

API
---

| Input               | Example                                               | Description
| ------------------- | ----------------------------------------------------- | -----------
| endpoint            | 46.46.46.46:51820                                     | Endpoint to connect to in the HOST:PORT format.
| endpoint_public_key | 9IHlvJqgkVWMq57a0A56XI5IjhnL5gaRhI1Pszk7S24=          | Endpoint's public key.
| ips                 | 192.168.143.254/24,fd8c:bc10:5021::192.168.143.254/48 | Comma-separated list of IP addresses to assign to the VM.
| allowed_ips         | 192.168.143.0/24,fd8c:bc10:5021::/48                  | Comma-separated list of netmasks.
| private_key         | GLEiXhRwFuhw8aPy+HQfSMwwoLU0Sw8jE8MOxZ8GV3w=          | Private key of the VM.
| preshared_key       | PWAfvVWCjiNV0Uh2DhmXhdRaT326qosSOcaDB3j9dwI=          | Preshared key assigned to the VM.

License
-------

Distributed under the MIT License.
See [LICENSE.txt] for details.

[LICENSE.txt]: LICENSE.txt
