FROM appliance-acr-registry.cn-zhangjiakou.cr.aliyuncs.com/base-image/alpine-3.20:openjdk1.8.0_402

# 更换国内源（加速）
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装必需工具：mysql客户端、curl、bc（无需cron）
RUN apk add --no-cache \
        mysql-client \
        curl \
        bc \
        tzdata

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 创建工作目录
WORKDIR /root

