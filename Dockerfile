# Dockerfile to build glpk container images
# Based on Ubuntu

# Set the base image to Ubuntu
FROM ubuntu:latest

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

# Install wget
RUN apt-get update && apt-get install -y wget

# Install glpk from http
# instructions and documentation for glpk: http://www.gnu.org/software/glpk/
WORKDIR /user/local/
RUN wget http://ftp.gnu.org/gnu/glpk/glpk-4.35.tar.gz
RUN tar -zxvf glpk-4.35.tar.gz

# Verify package contents
#gpg --verify glpk-4.32.tar.gz.sig
#gpg --keyserver keys.gnupg.net --recv-keys 5981E818

WORKDIR /user/local/glpk-4.35
RUN ./configure
RUN make
RUN make check
RUN make install
RUN make distclean

# Cleanup
WORKDIR /
RUN rm -rf /user/local/glpk-4.35.tar.gz
RUN apt-get clean
