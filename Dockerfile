# Use the small IBM java JRE
FROM ibmjava:sfj

# Set configuration, default to some basic (light) examples
ENV MAPS_LIST "antarctica;europe/andorra;europe/france/guyane"
# Map style and typ, currently supported : default,motomap,roue-libre
ENV MAPS_DESIGN "default"
# Map builder versions
ENV MKGMAP_VERSION="r4918"
ENV SPLITTER_VERSION="r653"

# Prepare helper software in image
RUN apt-get update ; apt-get -y install curl unzip

# Download needed software in image and extract them
# mkgmap
RUN mkdir -p /motomap/mkgmap && \
    curl --output /motomap/mkgmap/mkgmap.zip https://www.mkgmap.org.uk/download/mkgmap-${MKGMAP_VERSION}.zip && \
    unzip -d /motomap/mkgmap/ /motomap/mkgmap/mkgmap.zip

# splitter
RUN mkdir -p /motomap/splitter && \
    curl --output /motomap/splitter/splitter.zip https://www.mkgmap.org.uk/download/splitter-${SPLITTER_VERSION}.zip && \
    unzip -d /motomap/splitter/ /motomap/splitter/splitter.zip

# Download global useful dataset
# precomp-sea
RUN mkdir -p /motomap/precomp-sea && \
    curl --output /motomap/precomp-sea/sea-latest.zip https://www.thkukuk.de/osm/data/sea-latest.zip

# bounds
RUN mkdir -p /motomap/bounds && \
    curl --output /motomap/bounds/bounds-latest.zip https://www.thkukuk.de/osm/data/bounds-latest.zip

# Add our scripts
COPY motomap /motomap/motomap

# Run script
CMD ["/bin/bash", "/motomap/motomap/motomap.sh"]