# 1. 톰캣 9 버전 이미지를 베이스로 사용 (Java 11 환경)
FROM tomcat:9.0-jdk11-openjdk-slim

# 2. 톰캣 기본 기본 앱들(docs, examples 등) 제거하여 가볍게 만들기
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. 사장님의 JSP 및 정적 파일(src/main/webapp)을 톰캣 ROOT로 복사
# 폴더 뒤에 /를 붙여서 내용물만 복사되도록 합니다.
COPY ./src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# 4. 컴파일된 클래스 파일(.class) 복사
# 이클립스가 빌드한 결과물(WEB-INF/classes) 위치를 맞추어 복사합니다.
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# 5. 라이브러리(JAR) 파일 확인
# 만약 src/main/webapp/WEB-INF/lib 폴더에 ojdbc, jstl 등이 있다면 3번에서 같이 복사됩니다.
# 혹시 라이브러리가 다른 곳에 있다면 COPY 명령어를 추가해야 합니다.

EXPOSE 8080
CMD ["catalina.sh", "run"]