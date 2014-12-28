FROM ubuntu:trusty
MAINTAINER Anil Madhavapeddy <anil@recoil.org>
RUN apt-get -y update
RUN apt-get -y install sudo pkg-config git build-essential m4 software-properties-common aspcud unzip curl libx11-dev
RUN git config --global user.email "docker@example.com"
RUN git config --global user.name "Docker CI"
RUN apt-get -y install ocaml ocaml-native-compilers camlp4-extra
RUN echo "deb http://download.opensuse.org/repositories/home:/ocaml/xUbuntu_14.04/ /" > /etc/apt/sources.list.d/opam.list
RUN curl -OL http://download.opensuse.org/repositories/home:/ocaml/xUbuntu_14.04/Release.key
RUN apt-key add - < Release.key
RUN apt-get -y update
RUN git clone -b 1.2 git://github.com/ocaml/opam
RUN sh -c "cd opam && make cold && make install"
RUN adduser --disabled-password --gecos '' opam
RUN passwd -l opam
RUN echo "opam ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/opam
RUN chmod 440 /etc/sudoers.d/opam
RUN chown root:root /etc/sudoers.d/opam
RUN chown -R opam:opam /home/opam
USER opam
ENV HOME /home/opam
ENV OPAMYES 1
WORKDIR /home/opam
RUN sudo -u opam sh -c "git clone git://github.com/ocaml/opam-repository"
RUN sudo -u opam sh -c "opam init -a -y /home/opam/opam-repository"
RUN sudo -u opam sh -c "opam switch -y 4.02.1"
WORKDIR /home/opam/opam-repository
ONBUILD RUN sudo -u opam sh -c "cd /home/opam/opam-repository && git pull && opam update -u -y"
