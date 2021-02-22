FROM openjdk:15

ARG LS_ARCHIVE_FILE="jdt-language-server-0.68.0-202012242230.tar.gz"
ARG LS_TEMP_FILE="/tmp/${LS_ARCHIVE_FILE}"

ADD http://download.eclipse.org/jdtls/snapshots/${LS_ARCHIVE_FILE} ${LS_TEMP_FILE}
RUN mkdir /eclipse-jdt-ls \
        && tar xzf ${LS_TEMP_FILE} -C /eclipse-jdt-ls \
        && rm ${LS_TEMP_FILE}

ADD https://projectlombok.org/downloads/lombok.jar /eclipse-jdt-ls/

RUN mkdir /var/eclipse-jdt-ls-data

COPY com.microsoft.java.debug.plugin-0.30.0.jar /java-debug/

ENTRYPOINT ["java", \
                   "-Declipse.application=org.eclipse.jdt.ls.core.id1", \
                   "-Dosgi.bundles.defaultStartLevel=4", \
                   "-Declipse.product=org.eclipse.jdt.ls.core.product", \
                   "-Dlog.protocol=true", \
                   "-Dlog.level=ALL", \
                   "-Xmx1G", \
                   "-javaagent:/eclipse-jdt-ls/lombok.jar", \
                   "-Xbootclasspath/a:/eclipse-jdt-ls/lombok.jar", \
                   "-jar", \
                   "/eclipse-jdt-ls/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar", \
                   "-configuration", \
                   "/eclipse-jdt-ls/config_linux", \
                   "-data", \
                   "/var/eclipse-jdt-ls-data"]
