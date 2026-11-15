# KDE Connect: keep it connected

Use this when KDE Connect keeps disconnecting and `kdeconnect-cli --refresh` brings it back.

If a refresh fixes it, the pairing is fine and **discovery** is what's failing. KDE Connect finds devices with UDP broadcasts on ports 1714–1764, and those are the first packets dropped by a sleeping Wi-Fi card, an aggressive phone battery manager, or a router with client isolation (common on PG or shared Wi-Fi).

## 1. Turn off Wi-Fi power saving on the laptop

```bash
sudo cp wifi-powersave-off.conf /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
sudo systemctl restart NetworkManager
iw dev                                # find your interface, e.g. wlp2s0
iw dev wlp2s0 get power_save          # should print: Power save: off
```

`wifi.powersave` values in NetworkManager: `0` default, `1` ignore, `2` **disable**, `3` **enable**.

## 2. Phone settings

- Settings → Apps → KDE Connect → Battery → **Unrestricted**
- Allow **Autostart** (Xiaomi, Realme, Oppo, Vivo)
- Lock KDE Connect in the recent-apps screen
- Turn off "Wi-Fi sleep", "smart network switch" and similar options

## 3. Add devices by IP

In KDE Connect on both the laptop and the phone, use **Add devices by IP** so each side contacts the other directly instead of waiting for broadcasts. Give both devices fixed IPs, using a DHCP reservation on the router or a static IP on the phone.

## 4. Refresh automatically with cron

`crontab -e` (as your user):

```cron
*/2 * * * * DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus /usr/bin/kdeconnect-cli --refresh >/dev/null 2>&1
```

cron runs without your desktop session's environment, so the `DBUS_SESSION_BUS_ADDRESS` part is required. Without it, `kdeconnect-cli` can't reach the daemon.

## 5. Firewall (only if ufw is active)

Check with `sudo ufw status`. If it's active, open the ports to your LAN only:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 1714:1764 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 1714:1764 proto udp
```

Replace `192.168.1.0/24` with your subnet (`ip route` shows it). ufw rules are saved in `/etc/ufw/user.rules` and persist across reboots while ufw is enabled.

## Diagnosing a drop

```bash
ping -c 5 <phone-ip>                   # no reply = network or phone asleep
kdeconnect-cli -l                      # paired / reachable?
journalctl --user -f | grep -i kdeconnect
```
