FROM golang:1.22 AS builder
LABEL "language"="go"

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=1 go build -o main .

FROM debian:bookworm-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    sqlite3 \
    p7zip-full \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/main .
COPY _data/ _data/

EXPOSE 8080
CMD ["./main"]
