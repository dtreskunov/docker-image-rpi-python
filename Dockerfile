FROM balenalib/raspberrypi3-alpine-python:3.7-build AS build
ARG PROTOBUF_VERSION=3.6.1

ENV PREFIX_PATH=/usr/local

WORKDIR /protobuf
RUN curl --fail -L https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-python-${PROTOBUF_VERSION}.tar.gz | tar xz --strip-components=1
RUN ./configure --prefix=${PREFIX_PATH}}
RUN make install
RUN cd python
RUN python3 setup.py build --cpp_implementation
RUN python3 setup.py test --cpp_implementation
RUN python3 setup.py install --cpp_implementation --prefix=${PREFIX_PATH}

FROM balenalib/raspberrypi3-alpine-python:3.7-run
COPY --from=build /usr/local/ /usr/local/

ENTRYPOINT bash
