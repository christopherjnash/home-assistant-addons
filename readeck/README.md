# Readeck for Home Assistant

11:17 AM

This add-on is a Home Assistant version of [Readeck](https://codeberg.org/readeck/readeck). Readeck is a lightweight, self-hosted read-it-later app that lets you save, organize, and export web content—ideal for privacy-conscious users who want full control over their reading list.

## 🔗 Usage

Once installed, access the Web UI via:
`http://<YOUR_HOME_ASSISTANT_IP>:8001/`

## 🛠️ Configuration

The following options are available:

- **allowed_hosts**:
  A list of hostnames or IP addresses that are allowed to access the server. Example:

- **use_x_forwarded_for** _(true/false)_:
  Enable or disable trusting the `X-Forwarded-For` header (for use behind a reverse proxy).

- **use_x_forwarded_host** _(true/false)_:
  Enable or disable trusting the `X-Forwarded-Host` header.

- **use_x_forwarded_proto** _(true/false)_:
  Enable or disable trusting the `X-Forwarded-Proto` header.

### Example configuration

```yaml
allowed_hosts:
  - readeck.domain.com
  - domain.com
  - 192.168.1.100
  - homeassistant.local
use_x_forwarded_for: true
use_x_forwarded_host: true
use_x_forwarded_proto: true
```

If you are running Readeck behind a reverse proxy or want to restrict access to certain hosts, set these options as needed in the add-on configuration panel.

---

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
