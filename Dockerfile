FROM debian:sid
LABEL maintainer="Ivo Woltring <webmaster@ivonet.nl>"

RUN apt-get update && apt-get install -y --no-install-recommends\
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	hicolor-icon-theme \
	libcanberra-gtk* \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libpango1.0-0 \
	libpulse0 \
	libv4l-0 \
	fonts-symbola \
	pulseaudio \
	&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
	&& apt-get update && apt-get install -y --no-install-recommends \
	google-chrome-stable \
	&& apt-get purge --auto-remove -y curl \
	&& rm -rf /var/lib/apt/lists/*

# Add chrome user and set a secret password for the root user
RUN groupadd -r chrome \
    && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome/Downloads \
    && chown -R chrome:chrome /home/chrome \
    && echo "root:secret" | chpasswd

# Run Chrome as non privileged user
# pulseaudio also needs a non system user
USER chrome

# Autorun chrome
ENTRYPOINT [ "google-chrome" ]
CMD [ "--user-data-dir=/data" ]
VOLUME ["/data"/]
