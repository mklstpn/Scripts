FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt 

RUN adduser --disabled-password nonroot

RUN chown -R nonroot:nonroot /app

USER nonroot

EXPOSE 8000

CMD gunicorn --chdir /app -w 4 -b 0.0.0.0:8000 'main:app'

