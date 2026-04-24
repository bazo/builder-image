FROM alpine:latest

ARG TARGETARCH
ARG TARGETOS
ARG TARGETPLATFORM

# Ensure all binaries are in PATH
ENV GOPATH=/root/go
ENV PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# Base tools
RUN apk add --no-cache bash curl wget git build-base ca-certificates openssl tar

# --- Node.js (LTS) + npm ---
RUN apk add --no-cache nodejs npm

# --- Bun ---
RUN curl -fsSL https://bun.sh/install | bash && \
    mv /root/.bun/bin/bun /usr/local/bin/ && \
    rm -rf /root/.bun

# --- Go (always latest stable version for the target architecture) ---
RUN GO_LATEST=$(curl -s https://go.dev/VERSION?m=text | head -n 1) && \
    wget -q https://go.dev/dl/${GO_LATEST}.${TARGETOS}-${TARGETARCH}.tar.gz && \
    tar -C /usr/local -xzf ${GO_LATEST}.${TARGETOS}-${TARGETARCH}.tar.gz && \
    rm ${GO_LATEST}.${TARGETOS}-${TARGETARCH}.tar.gz && \
    ln -s /usr/local/go/bin/* /usr/local/bin/

RUN go install github.com/GeertJohan/go.rice/rice@latest

# --- Verify installation ---
RUN echo "✅ Installed:" && \
    echo "- Node: $(node -v)" && \
    echo "- npm:  $(npm -v)" && \
    echo "- Bun:  $(bun -v)" && \
    echo "- Go:   $(go version)"

CMD ["bash"]
