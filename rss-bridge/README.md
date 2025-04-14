# RSS-Bridge Add-on for Home Assistant

![RSS-Bridge](logo.png)

This add-on runs [RSS-Bridge](https://github.com/RSS-Bridge/rss-bridge) as a self-hosted RSS feed generator within Home Assistant OS.

## Usage

Once installed, access the Web UI via:  
`http://<YOUR_HOME_ASSISTANT_IP>:8085/`

## Build and Install

This add-on is built using the official Home Assistant add-on structure. It uses the base image from `ghcr.io/hassio-addons/base:12.2.7` and installs all dependencies via apk.

## Configuration

No additional user configuration is required for basic usage.

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
