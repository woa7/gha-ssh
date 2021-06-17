FROM debian:buster-slim
COPY entrypoint.bash /entrypoint.bash
RUN apt-get -y update && \
    apt-get -y install curl locales-all openssh-client openssh-server vim wget xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    HFILE=xvf tmate-2.4.0-static-linux-amd64.tar.xz HASHcmd=sha256sum HASHSUM=c21f07356de93a4fa5d1b7998252ea5f518dbe94ae781e0edeec7d7e29fdf899 HURL=https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz \
    printf "HFILE=$HFILE HASHcmd=$HASHcmd HASHSUM=$HASHSUM HURL=$HURL" %% \
    curl -o $HFILE -LR -C- -f -S --connect-timeout 15 --max-time 600 --retry 3 --dump-header - --compressed --verbose $HURL ; (printf %b CHECKSUM\\072\\040expect\\040this\\040$HASHcmd\\072\\040$HASHSUM\\040\\052$HFILE\\012 ; printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c - ;) || (printf %b ERROR\\072\\040CHECKSUMFAILD\\072\\040the\\040file\\040has\\040this\\040$HASHcmd\\072\\040 ; $HASHcmd -b $HFILE ; exit 1) && \
    tar xvf tmate-2.4.0-static-linux-amd64.tar.xz && \
    mv tmate-2.4.0-static-linux-amd64/tmate /usr/bin && \
    tmate -V
ENTRYPOINT ["/entrypoint.bash"]
