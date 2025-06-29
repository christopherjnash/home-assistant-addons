# Freetar Add-on for Home Assistant

This add-on runs [Freetar](https://github.com/kmille/freetar), an alternative front-end for Ultimate Guitar, as a Home Assistant add-on.

## Usage

After installation, access the web interface via:
`http://<YOUR_HOME_ASSISTANT_IP>:22000/`

## Configuration

Example configuration:
```yaml
port: 22000
username: myuser
password: mypass
```
Set the desired port and credentials to protect access with HTTP basic authentication.

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
