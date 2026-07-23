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
WORKDIR /data/workspace

# 复制脚本和配置文件
COPY check_usage.sh .
COPY .my.cnf /root/.my.cnf

# 赋予执行权限
RUN chmod +x check_usage.sh && chmod 600 /root/.my.cnf

# 默认执行脚本（CronJob 可通过 command 覆盖）
ENTRYPOINT ["/bin/sh", "/data/workspace/check_usage.sh"]
