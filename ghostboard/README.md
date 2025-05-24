<!-- README.md -->
# Ghostboard Add-on for Home Assistant

This add‑on packages [jon6fingrs’ Ghostboard](https://github.com/jon6fingrs/ghostboard) into a Home Assistant OS add‑on, giving you a lightweight, self‑hosted, real‑time text‑sharing “board” right on your network. 

**NOT YET FUNCTIONAL** 

## 🔗 Usage

Once installed, open:
`http://<YOUR_HOME_ASSISTANT_IP>:PORT:8765/`

Type anywhere in the page and your text will sync instantly across all browsers and clients.

## 🛠️ Configuration

No extra options—just install and go. If you need to tweak behavior, SSH into the add‑on container and edit:

- `/etc/nginx/conf.d/ghostboard.conf`  
- `/etc/supervisor/conf.d/supervisord.conf`

## ⚙️ Advanced

Ghostboard also provides a CLI client in its Docker image for scripted updates/retrievals:

```bash
# Retrieve
docker run --rm homeassistant/ghostboard:$(arch)-1.0.0 <server-ip>

# Update
docker run --rm homeassistant/ghostboard:$(arch)-1.0.0 <server-ip> "Some new text"
```
---

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg