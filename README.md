# scripts

Personal automation scripts and Linux setup notes. Each folder is self-contained, with its own README.

| Folder | What it is |
|---|---|
| [`tvplay/`](tvplay/README.md) | Play a YouTube video or local file fullscreen on the TV with on-screen controls, from a terminal, SSH, cron or a KDE Connect button. Also works as a video alarm. |
| [`kdeconnect/`](kdeconnect/README.md) | Keep KDE Connect from dropping: Wi-Fi power saving, phone battery settings, add-by-IP, an auto-refresh cron job, firewall rules |
| [`investing-tasks/`](investing-tasks/README.md) | Prompts for two Claude scheduled tasks: a weekly portfolio, earnings and policy review and a monthly opportunity scan (India + US), emailed as HTML |

## Conventions

- Scripts install to `/usr/local/bin` through each folder's `install.sh`, which needs `sudo`.
- Per-user cron jobs go in `crontab -e` as your own user, never root's crontab.
- Tested on Ubuntu. Most things work on any systemd-based distro.

## License

MIT, see [LICENSE](LICENSE).
