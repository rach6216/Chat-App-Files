# set base image (host OS)
FROM python:alpine
# --- NETFREE CERT INTSALL ---
# ADD https://netfree.link/dl/unix-ca.sh /home/netfree-unix-ca.sh 
# RUN cat  /home/netfree-unix-ca.sh | sh
# ENV NODE_EXTRA_CA_CERTS=/etc/ca-bundle.crt
# ENV REQUESTS_CA_BUNDLE=/etc/ca-bundle.crt
# ENV SSL_CERT_FILE=/etc/ca-bundle.crt
# --- END NETFREE CERT INTSALL ---
# set the working directory in the container
WORKDIR /chatApp
# copy the dependencies file to the working directory
COPY requirements.txt .
# install dependencies
RUN pip install -r requirements.txt
# Configure environment
ENV DATA_DIR='./data/'
ENV ROOMS_DIR=${DATA_DIR}'rooms/'
ENV TZ 'Israel'
ENV FLASK_ENV development
# copy the content of the local src directory to the working directory
COPY . .
# Helth check
HEALTHCHECK CMD ["curl", "-f", "http://localhost:5000/health"] INTERVAL=10s TIMEOUT=3s
# command to run on container start
CMD [ "python", "./chatApp.py" ]

