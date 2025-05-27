# ==============================================================================
# Home Assistant Community Add-on: Readeck
#
# Builds the Readeck addon based on Home Assistant base images.
# ==============================================================================
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set shell for enhanced command execution
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# --- Environment Variables ---
# Set Readeck version to download
ARG READECK_VERSION="0.19.1" # Updated version
# Get build architecture from the build environment
ARG BUILD_ARCH

# --- Package Installation ---
# Install curl for downloading Readeck
RUN \
    apk add --no-cache curl

# --- Readeck Installation ---
# Determine the Readeck binary architecture based on BUILD_ARCH
# Download the binary, place it in /bin, and make it executable
RUN \
    echo "Building for architecture: ${BUILD_ARCH}" \
    && case "${BUILD_ARCH}" in \
        "aarch64") READECK_ARCH="arm64"; ;; \
        "amd64") READECK_ARCH="amd64"; ;; \
        "i386") READECK_ARCH="386"; ;; \
        *) echo "ERROR: Unsupported architecture ${BUILD_ARCH}"; exit 1 ;; \
    esac \
    && echo "Downloading Readeck v${READECK_VERSION} for ${READECK_ARCH}..." \
    # Updated URL and filename format for 0.19.1
    && curl -L -f -o /bin/readeck \
       "https://codeberg.org/readeck/readeck/releases/download/${READECK_VERSION}/readeck-${READECK_VERSION}-linux-${READECK_ARCH}" \
    && echo "Download complete. Verifying file type..." \
    # Check if the downloaded file starts with 'HTML' or 'Not Found', if so, it's an error.
    && if [ "$(head -c 5 /bin/readeck)" = "<!DOC" ] || [ "$(head -c 4 /bin/readeck)" = "<HTM" ] || [ "$(head -c 9 /bin/readeck)" = "Not Found" ]; then \
        echo "ERROR: Downloaded file appears to be an HTML/Error page, not a binary."; \
        echo "--- File Content Start ---"; \
        head -n 5 /bin/readeck; \
        echo "--- File Content End ---"; \
        exit 1; \
    fi \
    && echo "File seems okay. Setting execute permissions for /bin/readeck..." \
    && chmod a+x /bin/readeck

# --- Addon Setup ---
# Copy the root filesystem, including the s6-overlay service script
COPY rootfs/ /

# Ensure the run script is executable
RUN chmod a+x /etc/services.d/readeck/run /etc/services.d/readeck/finish /etc/cont-init.d/10-config.sh

# --- Labels ---
# (Optional but recommended) Add labels for Home Assistant
ARG BUILD_DESCRIPTION="Readeck is a lightweight read-it-later app..."
ARG BUILD_NAME="Readeck"
ARG BUILD_VERSION="0.19.1" # Updated version
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.version=${BUILD_VERSION}