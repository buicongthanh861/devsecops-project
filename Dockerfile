# --- Stage 1: Build ứng dụng ---
FROM maven:3.8-jdk-8 AS builder
WORKDIR /usr/src/easybuggy
COPY . .
RUN mvn -B package

# --- Stage 2: Chạy ứng dụng với Tomcat ---
FROM tomcat:8.5-jdk8-corretto

# Xóa webapps mặc định để tránh lỗi
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file đã build từ stage trước
COPY --from=builder /usr/src/easybuggy/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Mở port mặc định của Tomcat
EXPOSE 8080

# Lệnh khởi động Tomcat
CMD ["catalina.sh", "run"]