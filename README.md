See the [organization page](https://github.com/HandLeVR) for a complete description of the HandLeVR project or the [Authoring Tool](https://github.com/HandLeVR/autorenwerkzeug) for a complete description of the structure and building process of the applications emerged from the the HandLeVR project.

# Server

The server is responsible for saving and sending data when requested. It is developed with Java and Spring Boot and provides different REST Webservices to request and save data. It is possible to use a dedicated server or a local instance.

## Build
With the command `mvn package` a executable Jar is created. It is important that the folder `Files` resides beside the Jar. In this folder all files (images, videos, audio and recordings) are managed by the server. If there is also a folder `config` containing a file with the name `application.properties`, this file is used for the configuration of the server (see below).

## Configuration
The server requires at least Java 13. Either a database server based on PostgresSQL (at least version 14.1) or a file-based H2 database can be used as a database. Below the needed changes in the configuration file (`config/application.properties`) are described if you want to run the server a dedicated server.


### Database Connection
In a productive environment, it is recommended to set up a PostgresSQL database. Please refer to the PostgresSQL documentation for the necessary steps. For the server to be able to connect to the database, the following settings must be made in the configuration file: 

```
spring.datasource.url=jdbc:postgresql://localhost:5432/handlevr 
spring.datasource.username=postgres 
spring.datasource.password=passwort 
spring.datasource.driver-class-name=org.postgresql.Driver
```

The properties `spring.datasource.url`, `spring.datasource.username` and `spring.datasource.password` must be replaced with the database settings accordingly. 

To use a file-based H2 database the following settings must be made in the configuration file: 

```
spring.datasource.url=jdbc:h2:file:~/spring-boot-h2-db 
spring.datasource.username=sa 
spring.datasource.password= 
spring.datasource.driver-class-name=org.h2.Driver 
```


The path for the file in which the database is stored can be set via `spring.datasource.url`.

### Database Initialization

When the server is started for the first time, the database is initialized with the default data. The scripts used for this are located in the jar file of the server. If you want to use a different script, it can be specified via the following property: 

```
spring.flyway.locations=classpath:db/migration/{vendor} 
```

### SSL

By default, HTTPS is not used when communicating with the server. To set up SSL, an SSL certificate must be available. If this is not the case, you can also create your own certificate. In the following it is explained how the certificate can be generated and which settings must be made in the configuration file to use HTTPS. 

To create the certificate, the program keytool is used here, which comes with Java. PKCS12 (Public-Key Cryptography Standards) is used as the certificate format. The following command creates a certificate: 

```
keytool -genkeypair -alias handlevr -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore handlevr.p12 -validity 3650 
````


The resulting `handlevr.p12` file or an existing certificate should be placed in the folder `config/keystore` relative to the server's jar file. Now the following settings must be made in the configuration file: 

```
server.ssl.key-store-type=PKCS12 
server.ssl.key-store=./config/keystore/handlevr.p12 
server.ssl.key-store-password=password 
server.ssl.key-alias=handlevr 
server.ssl.enabled=true 
```

The path to the certificate can be specified via `server.ssl.key-store`. This path is relative to the server's jar file, but can also be specified as an absolute path. If the password and alias were changed when the certificate was generated, `server.ssl.key-store-password` and `server.ssl.key-alias` must be changed. With `server.ssl.enable` SSL is activated. Subsequently, changes must also be made to the [configuration](https://github.com/HandLeVR/autorenwerkzeug/blob/master/README.md#server-connection) of the client application so that HTTPS can be used. 

### OAuth

After logging in to the server, a token is used to authorize subsequent requests. The OAuth protocol is used for logging in and refreshing the token. The is controlled by the following settings: 

```
security.oauth2.resource.filter-order=3 
security.signing-key=MaYzkSjmkzPC57L 
security.encoding-strength=256 
security.security-realm=HandLeVR Realm 
security.jwt.client-id=handlevrclient 
security.jwt.client-secret=XY7kmzoNzl100 
security.jwt.scope-read=read 
security.jwt.scope-write=write 
security.jwt.resource-ids=handlevrresourceid 
```

These settings do not need to be adjusted, but for security reasons it is recommended to change the `security.signing-key` and `security.jwt.client-secret` properties. This must also be reflected in the [client configuration](https://github.com/HandLeVR/autorenwerkzeug/blob/master/README.md#server-connection). 

### Maximum File Size
The maximum file size of uploaded files (e.g. images and videos) is currently limited to 1000 MB. This can be changed with the following properties: 

```
spring.servlet.multipart.max-file-size=1000MB 
spring.servlet.multipart.max-request-size=1000MB 
```