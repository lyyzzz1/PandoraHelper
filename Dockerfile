FROM golang:1.21-alpine AS builder

WORKDIR /app

# 安装编译所需的工具
RUN apk add --no-cache git

# 复制源代码
COPY . .

# 编译
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags='-extldflags "-static" -s -w' -o PandoraHelper ./cmd/server

# 最终镜像
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/PandoraHelper /app/PandoraHelper

# 创建数据目录
RUN mkdir -p /app/data

# 设置适当的权限
RUN chown -R 1000:1000 /app/data

# 使用您的应用程序作为入口点
CMD ["/app/PandoraHelper"]