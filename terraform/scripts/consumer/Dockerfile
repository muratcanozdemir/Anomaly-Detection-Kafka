FROM python:3.12-slim

WORKDIR /app

COPY consumer.py .

RUN pip install kafka-python tensorflow
HEALTHCHECK --interval= --timeout=30s --start-period=5s --retries=3 CMD [ "executable" ]
USER daemon

CMD ["python", "consumer.py"]
