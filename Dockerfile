# 1. 톰캣 9 버전 사용
FROM tomcat:9.0-jdk11-openjdk-slim

# 2. 기본 앱 제거
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. JSP 및 정적 파일 복사 (webapp 폴더 전체)
COPY ./src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# 4. 자바 소스 파일 복사 (빌드 결과물이 깃에 없을 경우를 대비)
# 만약 .class 파일이 깃에 없다면, 톰캣이 실행될 때 필요한 라이브러리 위치를 확인합니다.
# 보통 이클립스 프로젝트는 WEB-INF/lib 안에 필요한 jar들이 들어있어야 합니다.
# 만약 수동으로 빌드된 결과물을 올리고 싶다면 이클립스에서 'Export -> WAR file'을 한 뒤 
# 그 파일을 올리는 게 정석이지만, 일단은 아래처럼 경로를 단순화해볼게요.

# 에러 났던 빌드 복사 줄을 주석 처리하거나 삭제합니다.
# COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]