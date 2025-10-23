FROM python:3.14-slim

COPY ./ ./

RUN apt-get update && apt-get install -y postgresql-client && pip install -r requirements.txt

CMD ["python", "scripts/etl_process.py"]
