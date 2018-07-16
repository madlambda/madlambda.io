# Signer set up based on documentation at:
# http://doc.cat-v.org/inferno/4th_edition/release_notes/install

FROM madlambda/inferno-linux-x86:0.1

ADD ./start-emu.sh /start-emu.sh
ADD ./lib/ndb/local /work/lib/ndb/local
ADD ./usr/inferno/setup-auth.sh /work/usr/inferno/setup-auth.sh

# Default screen resolution
ENV WINRES 	1024x768
ENV TZ		Brazil_East
ENV DOMAIN	madlambda.io

RUN useradd -m inferno
ENTRYPOINT ["/start-emu.sh"]


