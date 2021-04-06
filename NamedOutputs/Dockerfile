from python:3.8.1-alpine3.11
WORKDIR /server

COPY server.py /server
RUN pip install flask
EXPOSE 5000
ENTRYPOINT [ "python","server.py" ]
