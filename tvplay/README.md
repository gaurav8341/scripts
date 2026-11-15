# tvplay

Play a YouTube video or local file **fullscreen on your TV, with on-screen controls**, from a single command. It works the same from a terminal, over SSH, from cron, or as a KDE Connect button on your phone.

Built for a laptop connected to a TV and used as a home entertainment box: start videos from the couch, use a video as an audio-visual alarm, and pause or stop from your phone.

```bash
tvplay "https://www.youtube.com/watch?v=jNQXAC9IVRw"   # play
tvplay --toggle                                         # pause / resume
tvplay --stop                                           # quit
```

## Why this exists

Running `mpv URL` from SSH, cron or KDE Connect usually plays **audio only**. Those shells don't know about your graphical session, so mpv can't open a window. tvplay fixes that and a few other problems:

- **Finds your desktop session.** It copies `WAYLAND_DISPLAY`, `DISPLAY`, `DBUS_SESSION_BUS_ADDRESS` and related variables from your running desktop process (Plasma, GNOME, Xfce, Cinnamon or MATE), so the video window appears on screen no matter where you launched it.
- **Avoids AV1.** YouTube often serves AV1, and broken AV1 hardware decoding can crash FFmpeg before a single frame is shown. tvplay asks for VP9 or H.264 (up to 1080p) and uses `hwdec=auto-safe`.
- **Finds yt-dlp reliably.** It doesn't depend on `PATH` being set up, which cron and KDE Connect often don't do.
- **Detaches from the launcher.** Playback keeps going after your SSH session or KDE Connect command ends.
- **Shows controls.** mpv's on-screen controller is shown as a bottom bar that stays visible.
- **Remote control.** Each video opens a per-user IPC socket, so `--play`, `--pause`, `--toggle` and `--stop` work from anywhere.
- **Multi-user safe.** The log and socket live in `/run/user/<uid>/`, and `--stop` only affects your own player.

## Requirements

- Linux with a graphical desktop session (tested on Ubuntu)
- `mpv`, `socat`, `yt-dlp`, all installed by `install.sh`
- Optional: KDE Connect (or GSConnect on GNOME) for phone control

## Install

```bash
git clone https://github.com/gaurav8341/scripts.git
cd scripts/tvplay
sudo ./install.sh                  # mpv, socat, yt-dlp, tvplay
# or
sudo ./install.sh --with-mpv-conf  # also sets the same mpv defaults system-wide
```

The installer:
1. installs `mpv` and `socat` with apt
2. installs the official `yt-dlp` binary to `/usr/local/bin` (the apt version goes stale, and YouTube breaks old versions)
3. installs `tvplay` to `/usr/local/bin/tvplay`, so every user can run it

To keep yt-dlp current, run `sudo yt-dlp -U` occasionally. If YouTube playback suddenly stops working, do this first.

To uninstall, run `sudo ./uninstall.sh`.

## Usage

| Command | What it does |
|---|---|
| `tvplay "<url or file>"` | Play fullscreen on the TV, replacing anything already playing |
| `tvplay` | Play `~/Videos/alarm.mp4` |
| `tvplay --toggle` | Pause if playing, resume if paused |
| `tvplay --pause` | Pause (does nothing if already paused) |
| `tvplay --play` | Resume (does nothing if already playing) |
| `tvplay --stop` | Quit the player |

Use `--toggle` for a single remote button. Use `--play` or `--pause` in scripts, where you need a definite state.

### Choosing the screen

The script uses `--fs-screen=1` (usually the external TV). If the video opens on the laptop screen instead, edit `/usr/local/bin/tvplay` and change it to `--fs-screen=0`.

### Changing the on-screen controls

In the `--script-opts` line:
- `osc-visibility=always` keeps the controls visible. Change it to `auto` to show them only when the mouse moves.
- `osc-layout=bottombar` gives a full-width bar. You can also try `box` or `slimbox`.

## Phone remote with KDE Connect

On the laptop, open KDE Connect → your phone → Plugins → **Run commands**, and add:

| Name | Command |
|---|---|
| Play alarm video | `tvplay "https://www.youtube.com/watch?v=VIDEO_ID"` |
| Play / Pause | `tvplay --toggle` |
| Stop | `tvplay --stop` |

They appear as buttons in the KDE Connect app on your phone.

For seek and volume from the phone's **Multimedia control** screen, install `mpv-mpris`:

```bash
sudo apt install mpv-mpris
```

## Video alarm with cron

Run `crontab -e` as your user (not root) and add:

```cron
0 7 * * * /usr/local/bin/tvplay "https://www.youtube.com/watch?v=VIDEO_ID"
30 7 * * * /usr/local/bin/tvplay --stop
```

More examples are in [`examples/crontab.txt`](examples/crontab.txt).

**Alarm caveats:**
- **You must be logged in** to the desktop. tvplay plays on your running session and can't create one.
- **Screen lock:** on Wayland the video can't appear over the lock screen, so you'll hear it but not see it. Turn off auto-lock if you need the picture.
- **Sleep:** cron can't wake a suspended laptop. Keep it awake, set lid-close to "do nothing", or set a hardware wake time first, for example `sudo rtcwake -m mem -t $(date +%s -d 'tomorrow 06:58')`.
- **Internet:** a YouTube alarm depends on the network. For reliability, download the video once and use the local file:
  ```bash
  yt-dlp -f "bv*[height<=1080][vcodec!^=av01]+ba/b" -o ~/Videos/alarm.%(ext)s "URL"
  ```
- **Audio output:** make sure HDMI is the default sound output (`wpctl status`, then `wpctl set-default <id>`).

## Keeping KDE Connect connected

If KDE Connect keeps dropping, see [`../kdeconnect`](../kdeconnect/README.md).

## Troubleshooting

Check the log first:

```bash
cat /run/user/$(id -u)/tvplay.log
```

| Symptom | Cause | Fix |
|---|---|---|
| `No desktop session found` | Not logged in, run via `sudo`, or an unlisted desktop | Run as your user while logged in. For other desktops, add the shell process name to the loop in the script |
| Audio only, no window | mpv couldn't reach the display | Make sure you're using tvplay rather than plain `mpv` from SSH |
| Window opens, never plays | yt-dlp missing or blocked | `which yt-dlp`; `sudo yt-dlp -U` |
| `av1: HW accel end frame fail` / assertion failure | Broken AV1 hardware decoding | Already avoided by the default format. If it still happens, set `--hwdec=no` |
| `Sign in to confirm you're not a bot` / HTTP 403 | YouTube blocking requests | `sudo yt-dlp -U`. If that doesn't help, add `--ytdl-raw-options=cookies-from-browser=firefox` |
| `Nothing is playing` | `--pause` / `--toggle` used with no player running | Start a video first |
| `unexpected EOF while looking for matching '"'` | Script damaged by copy-paste | Reinstall with `sudo ./install.sh`, then check with `bash -n /usr/local/bin/tvplay` |
| Video on the wrong screen | Wrong screen index | Swap `--fs-screen=1` / `0` |

## How it works

1. **Control commands** (`--play`, `--pause`, `--toggle`) send a JSON command to mpv's IPC socket at `/run/user/<uid>/mpvsock` using `socat`. For example, `--toggle` sends `{"command":["cycle","pause"]}`. `--stop` uses `pkill -u $USER -x mpv`.
2. **Session discovery:** it finds your desktop shell process (`plasmashell`, `gnome-shell`, …), reads its environment from `/proc/<pid>/environ`, and exports only the display, D-Bus and audio variables.
3. **Screen wake:** it calls `kscreen-doctor --dpms on` (KDE), falling back to Mutter's D-Bus API (GNOME).
4. **Launch:** it stops your previous mpv, then starts a new one with `setsid -f`, so it survives the parent shell, with fullscreen, safe decoding, the non-AV1 format, an always-visible control bar and the IPC socket.

## License

MIT, see [LICENSE](../LICENSE).
