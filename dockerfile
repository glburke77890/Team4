FROM python:3.8-slim-buster

WORKDIR /app

COPY . .

RUN pip install -r Requirements.txt


CMD ["python","-m","flask", "run", "--host=0.0.0.0"]
