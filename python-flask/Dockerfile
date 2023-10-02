FROM python:3.11-slim-bookworm 
LABEL description="Python Flask benchmark"

WORKDIR /app
COPY . .
RUN pip install --no-cache -r requirements.txt

EXPOSE 2000
CMD ["gunicorn", "-b", "0.0.0.0:2000", "--chdir", "src", "main:app"]

