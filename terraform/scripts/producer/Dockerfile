FROM python:3.12-slim

WORKDIR /app

COPY producer.py .

RUN pip install kafka-python
HEALTHCHECK --interval= --timeout=30s --start-period=5s --retries=3 CMD [ "executable" ]
USER daemon

CMD ["python", "producer.py"]
