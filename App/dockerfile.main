#Dockerfile

FROM python:3.8-slim

WORKDIR /usr/src/app


RUN apt-get update -y
RUN apt-get install dos2unix -y

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY  ./ /usr/src/app

RUN mkdir /root/Downloads
RUN touch /root/DownloadsItJobsWatchTop30.csv

CMD [ "python",  "main.py"]