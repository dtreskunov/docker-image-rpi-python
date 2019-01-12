FROM balenalib/raspberrypi3-alpine-python:3.7-edge-build AS build
ARG PROTOBUF_VERSION=3.6.1.3

RUN [ "cross-build-start" ]

RUN apk update
RUN apk add protobuf-dev

WORKDIR /protobuf
RUN git clone https://github.com/protocolbuffers/protobuf.git .
RUN git checkout tags/v${PROTOBUF_VERSION}
WORKDIR /protobuf/python
RUN python3 setup.py build --cpp_implementation
RUN python3 setup.py install --cpp_implementation

RUN apk add cmake
RUN pip3 install dlib
# RUN pip3 install numpy
# RUN pip3 install scikit-learn

RUN [ "cross-build-end" ]


FROM balenalib/raspberrypi3-alpine-python:3.7-edge-run
RUN [ "cross-build-start" ]
RUN apk update
RUN apk upgrade
RUN apk add protobuf
COPY --from=build /usr/local/ /usr/local/
RUN [ "cross-build-end" ]

ENTRYPOINT bash
