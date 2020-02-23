ARG VERSION="v1.5.10"
# Builder
FROM alpine as builder
ARG VERSION
ENV VERSION=${VERSION}
ENV RELEASE="https://github.com/vector-im/riot-web/releases/download/${VERSION}/riot-${VERSION}.tar.gz"
ENV FOLDER="riot-${VERSION}"
ENV TARBALL="${FOLDER}.tar.gz"


WORKDIR /bake
RUN wget ${RELEASE}
RUN tar xvf ${TARBALL}

FROM nginx:alpine

ARG VERSION
ENV VERSION=${VERSION}
ENV RELEASE="https://github.com/vector-im/riot-web/releases/download/${VERSION}/riot-${VERSION}.tar.gz"
ENV FOLDER="riot-${VERSION}"
ENV TARBALL="${FOLDER}.tar.gz"

RUN rm -rf /app
COPY --from=builder /bake/${FOLDER} /app

# Insert wasm type into Nginx mime.types file so they load correctly.
RUN sed -i '3i\ \ \ \ application/wasm wasm\;' /etc/nginx/mime.types

RUN rm -rf /usr/share/nginx/html \
 && ln -s /app /usr/share/nginx/html
