FROM tomcat:9.0-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

# 3. JSP/정적 파일 복사
COPY ./src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# 4. 자바 클래스 파일 복사 (이 부분이 빠져서 에러가 난 겁니다!)
# 이클립스 빌드 경로가 build/classes 인지 확인 후 복사
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]