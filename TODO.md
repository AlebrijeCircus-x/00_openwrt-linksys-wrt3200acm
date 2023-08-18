## Update Jul, 11th 2022

I no longer recommend using 53 listening port in configuration profiles. I suggest to use 443 port. Also, on mobile devices, it appears that changing port to 443 and removing MTU line from configuration profiles make the connection more reliable. So, use 443 port for `ListenPort` field and remove `MTU` field.

_You can skip all the prior explainations and go to the tutorial by [clicking here](https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#the-3rd-way-the-good-way)._

## Introduction

Whoever you are reading this, you probably already felt concerned about whether your Internet browsing was safe from unwelcome eyes… or ears.

The topic of today’s post is the [Wireguard®](https://wireguard.com/) [VPN](https://www.cloudflare.com/learning/access-management/what-is-a-vpn/) protocol and how to completely browse the Web without worrying about your privacy, for free thanks to [Cloudflare WARP](https://1.1.1.1/) VPN, [NextDNS](https://nextdns.io/) DNS service, and [WGCF tool](https://github.com/ViRb3/wgcf).

### WireGuard®

> WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache. It intends to be considerably more performant than OpenVPN.  
> — [WireGuard](https://www.wireguard.com/)

I can’t explain it better than that.

### Cloudflare WARP

Cloudflare WARP<sup id="fnref:1" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:1" rel="footnote">1</a></sup> is a cross-platform VPN, designed to be free and fast, using [1.1.1.1](https://www.cloudflare.com/learning/dns/what-is-1.1.1.1/)<sup id="fnref:2" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:2" rel="footnote">2</a></sup> DNS servers combined with WARP application to provide a secure connection using Cloudflare infrastructure. The 1.1.1.1 DNS service is claimed by Cloudflare to be the fastest DNS service around there. They state that they don’t log your IP address and don’t know whatever you’re doing on Internet. WARP is a software that redirects all the traffic from your device to the Cloudflare network, not just DNS traffic. WARP uses [BoringTun](https://github.com/cloudflare/boringtun)<sup id="fnref:3" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:3" rel="footnote">3</a></sup> which consists of a _userspace WireGuard implementation_.

However, WARP is not a _kind of flexible_ VPN. You can’t change your location. You have no control over your outbound IP address and Cloudflare does not even guarantee that your IP address will be different from the requested website point-of-view. The IP address it will see when you’ll be visiting it may be the same as your real IP address. So, don’t expect to virtually travel around the world, you won’t be circumventing RTBF restrictions to watch Formula 1 Grand Prix from France.

### NextDNS

NextDNS is a freemium DNS service that provides a secure DNS resolution that can be set to block domain lists (like ads-related ones) and that can provide on-demand analytics. NextDNS is free until you reach your monthly quota of 300,000 DNS requests. You can pay for unlimited DNS requests.

## Why using NextDNS in place of 1.1.1.1?

1.1.1.1 is a great and fast DNS service but it differs from NextDNS in some ways:

1.1.1.1. and NextDNS:

-   ✅ are free, fast, reliable
-   ✅ support IPv4 and IPv6
-   ✅ support **DNS over TLS**<sup id="fnref:4" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:4" rel="footnote">4</a></sup>/QUIC<sup id="fnref:5" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:5" rel="footnote">5</a></sup>
-   ✅ support **DNS over HTTPS**<sup id="fnref:6" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:6" rel="footnote">6</a></sup><sup id="fnref:7" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:7" rel="footnote">7</a></sup>
-   ✅ offer DNS\-level malware threat protection
-   ✅ offer child-safety/parental control mode

Only NextDNS:

-   ✅ lets you **set your own allow/block domain lists alongside popular Ad-blocking domain lists**
-   ✅ lets you **turn on/off analytics and/or DNS request logging**  
    _You can enable DNS client-side request logging on Cloudflare WARP application but it’s far from comparable to what proposes NextDNS_
-   ✅ lets you **customize parental control**
-   ✅ lets you **create multiple preferences profile**
-   ✅ is Web3<sup id="fnref:8" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:8" rel="footnote">8</a></sup><sup id="fnref:9" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:9" rel="footnote">9</a></sup> ready  
    _This is not clear for Cloudflare<sup id="fnref:10" role="doc-noteref"><a href="https://gcqd.fr/22/07/04/Wireguard-full-power-with-warp-and-nextdns#fn:10" rel="footnote">10</a></sup>_

I can’t guarantee you I didn’t forget some features but you’ll figure out if you use them.

## How to combine both? It seems tricky…

Since I discovered both services, I kept looking for a way to combine them. As you may have noticed, there’s some convenience using Cloudflare WARP as a free VPN and to use NextDNS as a free customizable DNS service. However, using both at the same time is not easily possible.

### 1st Idea: Use both official client applications

You could install both applications on mobile and/or desktop and try to enable them alongside each other. You’ll figure out that it’s not working as you expected. NextDNS will be enabled but WARP, once active, will bypass NextDNS and redirect all traffic to Cloudflare WARP.

### 2nd Idea: Use Cloudflare WARP Proxy feature alongside NextDNS official client

[I wrote about it on Reddit weeks ago](https://www.reddit.com/r/nextdns/comments/v1kvmd/nextdns_and_cloudflare_warp_can_work_together/) and it’s an interesting solution. Cloudflare has a proxy feature that can be used alongside NextDNS. This feature is designed to redirect traffic from a specific application to the Cloudflare network with the downside that 1.1.1.1 DNS resolution is disabled. But as you can understand, we’re not interested in Cloudflare DNS resolution, so this is not a problem.

Now, the only thing you have to do is to use NextDNS official client application and set WARP as a proxy on OS level. You can also change your Network Settings and manually replace DNS addresses by ones from NextDNS. To ensure that every interface will use WARP Proxy, I made a script (in fish language, sorry) to set the proxy and DNS addresses on every interface on macOS:

```
#!/bin/zsh

# Author: Guillaume COQUARD
# This script only accepts "on" or "off" as argument.

WAPR_CLI_DIR="/usr/local/bin"

PROXY_PORT="____"       # Change this with the port you want to use
PROXY_ADDR="127.0.0.1"  # This can also be 0.0.0.0

# Test if warp-cli is installed
if ! which warp-cli > /dev/null; then
    echo "Cloudflare WARP is not installed or not in your PATH. Please install it first."
    # Test if brew is installed
    if ! which brew > /dev/null; then
        echo "You can install it via brew install --cask cloudflare-warp."
        echo "Homebrew is not installed or not in your PATH. Please install Homebrew first."
        echo "Visit https://brew.sh/."
        exit 1
    else
        echo "You can install it via brew install --cask cloudflare-warp."
        exit 1
    fi
fi

sudo "${WAPR_CLI_DIR}/warp-cli" set-mode proxy;
sudo "${WAPR_CLI_DIR}/warp-cli" set-proxy-port "${PROXY_PORT}";

# These IPs are set by NextDNS and specific for each preference profile
NEXTDNSDNS_IPV6=("2a07:a8c0::__:__" "2a07:a8c1::__:__");
NEXTDNSDNS_IPV4=("45.90.__.__" "45.90.__.__");

CLOUDFLAREDNS_IPV6=("2606:4700:4700::1111" "2606:4700:4700::1001");
CLOUDFLAREDNS_IPV4=("1.1.1.1" "1.0.0.1");


# Set proxy for every interfaces
for interface in "$(sudo networksetup -listallnetworkservices | grep -v "*")"; do

    # Set proxy for every proxy type
    sudo networksetup -setwebproxy "${interface}" "${PROXY_ADDR}" "${PROXY_PORT}" off;
    sudo networksetup -setsecurewebproxy "${interface}" "${PROXY_ADDR}" "${PROXY_PORT}" off;
    sudo networksetup -setsocksfirewallproxy "${interface}" "${PROXY_ADDR}" "${PROXY_PORT}" off;
    sudo networksetup -setdnsservers "${interface}" ${NEXTDNSDNS_IPV6[@]} ${NEXTDNSDNS_IPV4[@]} ${CLOUDFLAREDNS_IPV6[@]} ${CLOUDFLAREDNS_IPV4[@]};

    # Turn on/off every proxy
    sudo networksetup -setwebproxystate "${interface}" $1;
    sudo networksetup -setsecurewebproxystate "${interface}" $1;
    sudo networksetup -setsocksfirewallproxystate "${interface}" $1;

done
```

You can also check the proxy status for every interface with:

```
#!/bin/zsh

# Author: Guillaume COQUARD

# Get proxy status for every interfaces
for interface in "$(sudo networksetup -listallnetworkservices | grep -v "*")"; do

    sudo networksetup -getwebproxy "$interface";
    sudo networksetup -getsecurewebproxy "$interface";
    sudo networksetup -getsocksfirewallproxy "$interface";
    sudo networksetup -getdnsservers "$interface"

done
```

But there are many potential problems with this solution, starting from the fact that you can’t use other proxies at OS level without third-party software. And also the fact that this is not a reliable solution, requiring one to be confident in relying on Apple Networks Settings that can be buggy from time to time. But if you want to check this yourself, install Wireshark and capture your network.

## The 3rd Way: The Good Way

To ensure you’re using both services there’s only one method that guarantees it. Using [`wgcf`](https://github.com/ViRb3/wgcf) tool. This tool has been made by ViRb3, is open-source, and written in Go. The main purpose of `wgcf` is to generate WireGuard profile from Cloudflare WARP connection.

You just have to:

1.  Register your Cloudflare WARP “environment” with `wgcf register` ;
2.  Generate a WireGuard profile with `wgcf generate --config wgcf-account.toml` from the previously registered environment ;
3.  Set the custom DNS IP addresses directly in the generated profile ;
4.  Use the generated profile within the WireGuard client ;
5.  Enable your newly created WireGuard configuration within the WireGuard client.

```
[Interface]
PrivateKey = [base64-encoded-private-key]
Address = 172.16.0.2/32
Address = fd01:5ca1:ab1e:8a29:f19:cf4:a32:298/128
DNS = 1.1.1.1
MTU = 1280
[Peer]
PublicKey = [base64-encoded-public-key]
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
```

This is the file generated in step 2.

For the remaining steps we need to use a WireGuard client and to do so we’ll use [the official one for macOS](https://apps.apple.com/fr/app/wireguard/id1451685025).

    ![WireGuard on the macOS App Store](https://gcqd.fr/assets/images/attached/22/07/04/Capture-AppStore-1.png)

WireGuard on the macOS App Store

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-WireGuard-1.png)

Screenshot of WireGuard application

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-WireGuard-2.png)

Import a "Tunnel" from a file

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-WireGuard-3.png)

You should obtain something like that

Then you add your custom NextDNS IP addresses as shown below:

```
[Interface]
PrivateKey = [base64-encoded-private-key]
Address = 172.16.0.2/32
Address = fd01:5ca1:ab1e:8a29:f19:cf4:a32:298/128
DNS = 2a07:a8c0::__:__, 2a07:a8c1::__:__
DNS = 45.90.__.__, 45.90.__.__
DNS = 2606:4700:4700::1111, 2606:4700:4700::1001
DNS = 1.1.1.1, 1.0.0.1
MTU = 1280
[Peer]
PublicKey = [base64-encoded-public-key]
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
```

Once everything is set up, you should not see any red-underlined text. I also recommend adding standard listening port in the “Interface” configuration block:

```
[Interface]
...
ListenPort = 53
...
```

It should prevent anyone who tries to block your VPN to achieve it. Your Internet traffic will be shown as DNS packets on the network.

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-WireGuard-4.png)

Eventually, you'll likely get this

Now, you can enable “On-Demand” for Ethernet or WiFi mode to ensure your device connects to this tunnel whatever you’re doing. Click “Save”.

Finally, you’ll get your profile set:

    ![WireGuard with Mixed Profile Saved](https://gcqd.fr/assets/images/attached/22/07/04/Capture-WireGuard-5.png)

WireGuard with Mixed Profile Saved

And now, you just have to enable it:

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-WireGuard-6.png)

WireGuard with Mixed Profile Enabled

## Results

To illustrate it better, I have set my NextDNS profile to block most of the ads thanks to the NextDNS predefined ad-blocking domain lists. Here are some french press websites, on the left the Home profile is enabled, on the right, it is disabled:

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-Browser-1-Liberation.png)

Comparison on liberation.fr: Left: Enabled / Right: Disabled

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-Browser-2-Figaro.png)

Comparison on figaro.fr: Left: Enabled / Right: Disabled

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-Browser-3-LeMonde.png)

Comparison on lemonde.fr: Left: Enabled / Right: Disabled

    ![](https://gcqd.fr/assets/images/attached/22/07/04/Capture-Wireshark-1.png)

Comparison of packet traffic from/to current device: Left: Enabled / Right: Disabled

## Conclusion

Your traffic is now _mostly_ private and nobody can see what you’re doing on the network. The cool thing is that `wgcf` tool is cross-platform, as WireGuard client is, so you can use the same WireGuard profile on all your computers but also on your mobile devices.
