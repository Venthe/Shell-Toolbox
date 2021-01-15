FROM busybox as build
ADD https://github.com/spotbugs/spotbugs/releases/download/4.2.0/spotbugs-4.2.0.tgz /spotbugs-4.2.0.tgz
RUN tar -xvzf /spotbugs-4.2.0.tgz

FROM openjdk:8
COPY --from=build /spotbugs-4.2.0/ /spotbugs
RUN chmod +x /spotbugs/bin/spotbugs
WORKDIR /spotbugs/workdir
ENTRYPOINT [ "/spotbugs/bin/spotbugs" ]
