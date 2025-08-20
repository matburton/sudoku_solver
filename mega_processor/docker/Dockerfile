FROM ubuntu:24.04

ADD https://www.megaprocessor.com/Megaprocessor_sw.zip /downloads/mega.zip

RUN ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

RUN dpkg --add-architecture i386

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y tzdata \
    && apt install -y unzip wine32:i386

WORKDIR /mega

RUN unzip /downloads/mega.zip

ENV XCURSOR_SIZE=24

ENTRYPOINT ["wine"]

CMD ["MPsimulator.exe"]
