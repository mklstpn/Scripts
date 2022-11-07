FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt 

RUN adduser --disabled-password nonroot

RUN mkdir /app2/

COPY . /app2/

RUN chown -R nonroot:nonroot /app2

USER nonroot

RUN mkdir /app2/logs

EXPOSE 8000

CMD gunicorn --chdir /app -w 4 -b 0.0.0.0:8000 'main:app'

