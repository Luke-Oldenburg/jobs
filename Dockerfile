# ---- build stage ----
FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o jobs .

# ---- runtime stage ----
FROM alpine:3.22

# openssh provides ssh-keygen, used by the entrypoint to generate
# host keys at runtime (NOT at build time, so keys survive image rebuilds)
RUN apk add --no-cache openssh

WORKDIR /app

COPY --from=builder /app/jobs .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# The SSH server listens on :1337 by default.
# Override with the SSH_PORT env var if needed.
ENV SSH_PORT=1337
EXPOSE 1337

ENTRYPOINT ["./entrypoint.sh"]
