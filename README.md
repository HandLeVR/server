**For an english version see below.**

Eine Beschreibung des kompletten HandLeVR-Projekts und die nötigen Schritte um die Anwendungen, die aus dem Projekt hervorgegangen sind, zu kompilieren, können auf der [Organisationsseite](https://github.com/HandLeVR) gefunden werden.

# Server
Der Server stellt REST-Webservices zur Verfügung über die Daten gespeichert und geladen werden können. Er wurde mit Java und Spring Boot umgesetzt. Es ist möglich einen dedizierten Server einzurichten oder den Server lokal auf dem gleichen System wie die Anwendungen laufen zu lassen.

## Kompilieren

### Voraussetzungen
- Java JDK 13+
- Maven

### Schritte
Mit dem Befehl `mvn package` wird eine ausführbare Jar erstellt. Es ist wichtig, dass der Ordner `Files` im gleichen Verzeichnis wie die Jar liegt. In diesem Ordner befinden sich alle Dateien (Bilder, Videos, Audiodateien und Aufnahmen), die vom Server verwaltet werden. Befindet sich außerdem ein Ordner im selben Ordner wie die Jar, der eine Datei mit Namen `application.properties` enthält, wird diese Datei für die Konfiguration des Servers verwendet (siehe unten).

## Konfiguration
Der Server benötigt mindestens Java 13. Als Datenbank kenn entweder ein Datenbank-Server auf Basis von PostgresSQL (mindesten Version 14.1) oder eine dateibasierte H2 Datenbank verwendet werden. Im Folgenden wird beschrieben welche Einstellungen an der  Konfigurationsdatei (application.properties) vorgenommen werden müssen, um einen dedizierten Server einzurichten. 
 
### Datenbankverbindung 

In einer Produktivumgebung wird empfohlen eine PostgresSQL-Datenbank einzurichten. Die hierfür nötigen Schritte entnehmen sie bitte der Dokumentation zu PostgresSQL. Damit der Server eine Verbindung zur Datenbank aufnehmen kann müssen folgende Einstellungen in der Konfigurationsdatei vorgenommen werden: 

```
spring.datasource.url=jdbc:postgresql://localhost:5432/handlevr 
spring.datasource.username=postgres 
spring.datasource.password=passwort 
spring.datasource.driver-class-name=org.postgresql.Driver 
```

Die Felder `spring.datasource.url`, `spring.datasource.username` und `spring.datasource.password` müssen entsprechend durch die Einstellungen der Datenbank ersetzt werden. 

Um eine dateibasierte H2 Datenbank zu verwenden, müssen folgende Einstellungen in der Konfigurationsdatei vorgenommen werden: 

```
spring.datasource.url=jdbc:h2:file:~/spring-boot-h2-db 
spring.datasource.username=sa 
spring.datasource.password= 
spring.datasource.driver-class-name=org.h2.Driver 
```

Der Pfad für die Datei in der die Datenbank gespeichert wird, kann über `spring.datasource.url` eingestellt werden.

 
### Initialisierung der Datenbank 

Beim ersten Start des Servers wird die Datenbank mit den Standarddaten initialisiert. Die dafür verwendeten Skripte liegen in der Jar-Datei des Servers. Soll ein anderes Skript verwendet werden, kann dieses über folgendes Feld angegeben werden: 

```
spring.flyway.locations=classpath:db/migration/{vendor} 
``` 

### SSL 

Standardmäßig wird bei den Zugriffen auf den Server kein HTTPS verwendet. Um SSL einzurichten, muss ein SSL Zertifikat vorhanden sein. Falls dies nicht der Fall ist, kann auch ein eigenes Zertifikat erstellt werden. Im Folgenden wird erklärt, wie das Zertifikat generiert werden kann und welche Einstellungen in der Konfigurationsdatei vorgenommen werden müssen, damit HTTPS verwendet wird. 

Zur Erstellung des Zertifikats wird hier das Programm keytool verwendet, welches mit Java geliefert wird. Als Format wird PKCS12 (Public-Key Cryptography Standards) verwendet. Zur Erstellung des Zertifikats muss folgender Befehl ausgeführt werden: 

```
keytool -genkeypair -alias handlevr -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore handlevr.p12 -validity 3650 
```

Die resultierende Datei `handlevr.p12` oder ein existierendes Zertifikat sollte in den Ordner `config/keystore/handlevr.p12` relativ zur Jar-Datei des Servers gelegt werden. Nun müssen folgende Einstellungen in der Konfigurationsdatei vorgenommen werden: 

```
server.ssl.key-store-type=PKCS12 
server.ssl.key-store=./config/keystore/handlevr.p12 
server.ssl.key-store-password=passwort 
server.ssl.key-alias=handlevr 
server.ssl.enabled=true 
```

Der Pfad zum Zertifikat kann über `server.ssl.key-store` festgelegt werden. Dieser Pfad ist relativ zur Jar-Datei des Servers, kann aber auch als absoluter Pfad angegeben werden. Wurde das Passwort und der Alias beim Generieren des Zertifikats geändert, müssen die Felder `server.ssl.key-store-password` und `server.ssl.key-alias` angepasst werden. Mit `server.ssl.enable` wird SSL aktiviert. Anschließend müssen beim Client ebenfalls Änderungen an der Konfiguration vorgenommen werden, damit HTTPS genutzt werden kann (siehe [Konfiguration Autorenwerkzeug](https://github.com/HandLeVR/autorenwerkzeug/blob/master/README.md). 

 

### OAuth 

Nach der Anmeldung beim Server wird ein Token verwendet, um nachfolgende Anfragen zu autorisieren. Für die Anmeldung und das Auffrischen des Tokens wird das OAuth-Protokoll verwendet. Folgende Einstellungen haben hierauf Einfluss: 

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

Diese Einstellungen müssen nicht angepasst werden, aus Sicherheitsgründen wird aber empfohlen die Felder `security.signing-key` und `security.jwt.client-secret` zu ändern. Dies muss sich auch in der Konfiguration des Clients widerspiegeln (siehe [Konfiguration Autorenwerkzeug](https://github.com/HandLeVR/autorenwerkzeug/blob/master/README.md)).

 

### Maximale Dateigröße 

Die maximale Dateigröße von hochgeladenen Dateien (z.B. Bilder und Videos) ist momentan auf 1000 MB beschränkt. Eine Anpassung kann über folgende Felder vorgenommen werden: 
 
```
spring.servlet.multipart.max-file-size=1000MB 
spring.servlet.multipart.max-request-size=1000MB 
```

---
See the [organization page](https://github.com/HandLeVR) for a complete description of the HandLeVR, the structure and building process of the applications emerged from the the HandLeVR project.

# Server

The server is responsible for saving and sending data when requested. It is developed with Java and Spring Boot and provides different REST Webservices to request and save data. It is possible to use a dedicated server or a local instance.

## Build

### Requirements
- Java JDK 13+
- Maven

### Steps

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