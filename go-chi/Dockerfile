FROM golang:1.21-bookworm 
LABEL description="Go Chi benchmark"

WORKDIR /app
COPY . .

RUN go mod download && go mod verify
RUN go build -v -o /usr/local/bin/app /app/src

EXPOSE 2000
CMD ["app"]

