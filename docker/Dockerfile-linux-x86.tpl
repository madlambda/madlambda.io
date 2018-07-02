MAINTAINER Madlab team (noreply@madlambda.io)

COPY . /work

WORKDIR /work
ENV SYSHOST Linux
ENV OBJTYPE 386
ENV ROOT /work
ENV PATH $PATH:$ROOT/$SYSHOST/$OBJTYPE/bin
ENV MKFLAGS "SYSHOST=$SYSHOST OBJTYPE=$OBJTYPE ROOT=$ROOT"
RUN mk $MKFLAGS mkdirs
RUN mk $MKFLAGS emuinstall
RUN mk $MKFLAGS emunuke

# inside inferno, run 'grep <port> /lib/ndb/services' to discover
# the purpose of each one.
EXPOSE 6666/tcp
EXPOSE 6667/tcp
EXPOSE 6668/tcp
EXPOSE 6669/tcp
EXPOSE 6670/tcp
EXPOSE 6671/tcp
EXPOSE 6672/tcp
EXPOSE 6673/tcp
EXPOSE 6674/tcp
EXPOSE 6675/tcp
EXPOSE 6676/tcp
EXPOSE 2202/udp
EXPOSE 6660/tcp

ENTRYPOINT ["emu"]