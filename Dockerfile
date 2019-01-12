FROM balenalib/raspberrypi3-alpine-python:3.7-edge-build AS build
ARG PROTOBUF_VERSION=3.6.1

ENV PREFIX_PATH=/opt

RUN [ "cross-build-start" ]

WORKDIR /protobuf
RUN curl --fail -L https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-python-${PROTOBUF_VERSION}.tar.gz | tar xz --strip-components=1
RUN ./configure --prefix=${PREFIX_PATH}
RUN make install
WORKDIR /protobuf/python
RUN python3 setup.py build --cpp_implementation
RUN python3 setup.py test --cpp_implementation
RUN python3 setup.py install --cpp_implementation --prefix=${PREFIX_PATH}

RUN [ "cross-build-end" ]


FROM balenalib/raspberrypi3-alpine-python:3.7-edge-run
COPY --from=build /opt/ /usr/local/

ENTRYPOINT bash
