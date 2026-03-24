#!/bin/bash

rm -rf tempdir
docker rm -f samplerunning 2>/dev/null || true
docker rmi -f sampleapp 2>/dev/null || true

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "FROM python:3.11-slim" >> tempdir/Dockerfile
echo "ENV PIP_PROGRESS_BAR=off" >> tempdir/Dockerfile
echo "RUN pip install flask" >> tempdir/Dockerfile
echo "WORKDIR /home/myapp" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo 'CMD ["python3","sample_app.py"]' >> tempdir/Dockerfile

cd tempdir

docker build --no-cache -t sampleapp .
docker run --privileged --pids-limit=-1 -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a