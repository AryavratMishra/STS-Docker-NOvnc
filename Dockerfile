# Use a lightweight Ubuntu image with XFCE desktop and NoVNC
FROM accetto/ubuntu-vnc-xfce-g3:22.04

# Switch to root to install dependencies
USER 0

# Install Java 21 (required for STS 4.30) and other utilities
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk wget curl tar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Environment variables for STS
ENV STS_VERSION=4.30.0.RELEASE
ENV STS_DOWNLOAD_URL=https://cdn.spring.io/spring-tools/release/STS4/4.30.0.RELEASE/dist/e4.35/spring-tools-for-eclipse-4.30.0.RELEASE-e4.35.0-linux.gtk.x86_64.tar.gz
ENV INSTALL_DIR=/opt/sts

# Create installation directory
RUN mkdir -p ${INSTALL_DIR}

# Download and extract STS
RUN wget -q ${STS_DOWNLOAD_URL} -O /tmp/sts.tar.gz && \
    tar -xzf /tmp/sts.tar.gz -C ${INSTALL_DIR} --strip-components=1 && \
    rm /tmp/sts.tar.gz

# Fix permissions for the headless user
RUN chown -R headless:headless ${INSTALL_DIR}

# Create workspace directory
RUN mkdir -p /home/headless/workspace

# Add STS to PATH
ENV PATH=${INSTALL_DIR}/sts-${STS_VERSION}:${PATH}

# Create a desktop shortcut (optional but nice for GUI)
RUN mkdir -p /home/headless/Desktop && \
    echo "[Desktop Entry]" > /home/headless/Desktop/STS.desktop && \
    echo "Version=1.0" >> /home/headless/Desktop/STS.desktop && \
    echo "Type=Application" >> /home/headless/Desktop/STS.desktop && \
    echo "Name=Spring Tool Suite 4" >> /home/headless/Desktop/STS.desktop && \
    echo "Exec=${INSTALL_DIR}/sts-${STS_VERSION}/SpringToolSuite4" >> /home/headless/Desktop/STS.desktop && \
    echo "Icon=${INSTALL_DIR}/sts-${STS_VERSION}/icon.xpm" >> /home/headless/Desktop/STS.desktop && \
    echo "Path=${INSTALL_DIR}/sts-${STS_VERSION}" >> /home/headless/Desktop/STS.desktop && \
    echo "Terminal=false" >> /home/headless/Desktop/STS.desktop && \
    echo "StartupNotify=true" >> /home/headless/Desktop/STS.desktop && \
    chmod +x /home/headless/Desktop/STS.desktop

# Fix permissions
RUN chown -R headless:headless /home/headless

# Switch back to the default non-root user
USER 1001

# Expose VNC and NoVNC ports (already exposed by base image, but good for documentation)
EXPOSE 5901 6901

# Set the working directory
WORKDIR /home/headless/workspace
