# Imagem da aplicação Easy Notes a partir do JAR gerado no app01
# A versão do Java da imagem deve ser compatível com a usada para compilar o JAR (Java 21)
FROM eclipse-temurin:21-jre-alpine

# Usuário sem privilégios para executar a aplicação (não roda como root)
RUN addgroup -S notes && adduser -S notes -G notes
USER notes:notes

ARG JAR_FILE=*.jar
COPY ${JAR_FILE} easy-notes.jar
COPY application.properties application.properties

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/easy-notes.jar" ]
