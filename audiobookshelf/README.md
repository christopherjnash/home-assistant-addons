# udiobookshelf for Home Assistant

This add-on is based on [advplyr's audiobookshelf app](https://github.com/heussd/fivefilters-full-text-rss-docker), which is a self-hosted audiobook and podcast server.

## 🔗 Usage

Once installed, access the Web UI via:  
`http://<YOUR_HOME_ASSISTANT_IP>:8081/`

You can convert any feed URL to full text with: 
`http://<YOUR_HOME_ASSISTANT_IP>:8081/makefulltextfeed.php?url=<RSS_FEED_URL>`


### 🧪 Example with RSS-Bridge:

Combine with RSS-Bridge for sites without proper feeds:
`http://<YOUR_HOME_ASSISTANT_IP>:8081/makefulltextfeed.php?url=http://<YOUR_RSS_BRIDGE>/rss-bridge/?action=display&bridge=HtmlSelector&url=https%3A%2F%2Fexample.com`

## 🛠️ Configuration

No additional user configuration is required for basic usage. To customize parsing rules, edit the `site_config` directory inside the container (advanced users only).


_Example add-on to use as a blueprint for new add-ons._

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
