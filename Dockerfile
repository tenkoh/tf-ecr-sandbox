FROM golang:1.24.1-bullseye AS builder

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY ./src/main.go .
RUN CGO_ENABLED=0 go build --trimpath -ldflags="-s -w" -o /app/main

FROM gcr.io/distroless/static-debian12:latest AS image1
COPY --from=builder /app/main /
CMD ["/main"]

FROM gcr.io/distroless/static-debian12:nonroot AS image2
COPY --from=builder /app/main /
CMD ["/main"]
