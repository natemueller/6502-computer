FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install wget build-essential

RUN wget http://90.153.13.213/vasm/release/vasm.tar.gz && tar xvfz vasm.tar.gz
WORKDIR /vasm
RUN make CPU=6502 SYNTAX=oldstyle

ENTRYPOINT ["/vasm/vasm6502_oldstyle"]
