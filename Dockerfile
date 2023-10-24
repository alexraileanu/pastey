FROM python:3.10-slim-bullseye
WORKDIR /app
COPY requirements.txt /app
RUN mkdir -p /app/data && \
    pip install -r /app/requirements.txt
COPY . /app/
EXPOSE 5000
ENV PASTEY_DATA_DIRECTORY=/app/data  
CMD ["python3", "app.py"]
