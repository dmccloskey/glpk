# Dockerfile to build glpk container images
# Based on Ubuntu

# Set the base image to Ubuntu
FROM ubuntu:latest

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

# switch to root for install
USER root

# Install wget
RUN apt-get update && apt-get install -y wget

# Install glpk from http
# instructions and documentation for glpk: http://www.gnu.org/software/glpk/
WORKDIR /user/local/
RUN wget http://ftp.gnu.org/gnu/glpk/glpk-4.57.tar.gz
RUN tar -zxvf glpk-4.57.tar.gz

# Verify package contents
#gpg --verify glpk-4.57.tar.gz.sig
#gpg --keyserver keys.gnupg.net --recv-keys 5981E818

WORKDIR /user/local/glpk-4.57
RUN ./configure
RUN make
RUN make check
#RUN make install
RUN sudo make install
RUN make distclean

# add glpk libraries to path
ENV PATH /usr/local/lib/libglpk.so:$PATH

# Cleanup
WORKDIR /
RUN rm -rf /user/local/glpk-4.57.tar.gz
RUN apt-get clean

#create a glpk user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
    && chmod -R u+rwx $HOME \
    && chown -R user:user $HOME
    
#Return app user
WORKDIR $HOME
USER user
