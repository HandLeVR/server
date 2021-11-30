create table USER
(
    ID BIGINT auto_increment
        primary key,
    FULL_NAME VARCHAR(255),
    PWD VARCHAR(255),
    PASSWORD_CHANGED BOOLEAN not null,
    ROLE VARCHAR(255),
    USER_NAME VARCHAR(255)
);

create table PERMISSION
(
    ID BIGINT auto_increment
        primary key,
    EDITABLE BOOLEAN not null,
    VISIBLE BOOLEAN not null,
    AUTHOR_ID BIGINT,
    constraint FKPBOCWFS1FPUUC2EC2MHR77HU7
        foreign key (AUTHOR_ID) references USER (ID)
);

create table COAT
(
    ID BIGINT auto_increment
        primary key,
    COLOR VARCHAR(255),
    COSTS FLOAT not null,
    DESCRIPTION TEXT,
    DRYING_TEMPERATURE FLOAT not null,
    DRYING_TIME INTEGER not null,
    DRYING_TYPE VARCHAR(255),
    FULL_GLOSS_MIN_THICKNESS_DRY FLOAT not null,
    FULL_GLOSS_MIN_THICKNESS_WET FLOAT not null,
    FULL_OPACITY_MIN_THICKNESS_DRY FLOAT not null,
    FULL_OPACITY_MIN_THICKNESS_WET FLOAT not null,
    GLOSS_DRY FLOAT not null,
    GLOSS_WET FLOAT not null,
    HARDENER_MIX_RATIO VARCHAR(255),
    MAX_SPRAY_DISTANCE FLOAT not null,
    MIN_SPRAY_DISTANCE FLOAT not null,
    NAME VARCHAR(255),
    ROUGHNESS FLOAT not null,
    RUNS_START_THICKNESS_WET FLOAT not null,
    SOLID_VOLUME FLOAT not null,
    TARGET_MAX_THICKNESS_DRY FLOAT not null,
    TARGET_MAX_THICKNESS_WET FLOAT not null,
    TARGET_MIN_THICKNESS_DRY FLOAT not null,
    TARGET_MIN_THICKNESS_WET FLOAT not null,
    THINNER_PERCENTAGE FLOAT not null,
    TYPE VARCHAR(255),
    VISCOSITY FLOAT not null,
    PERMISSION_ID BIGINT,
    constraint FKB42GFXRFW76F1O12C1IQQ2F8A
        foreign key (PERMISSION_ID) references PERMISSION (ID)
);

create table MEDIA
(
    ID BIGINT auto_increment
        primary key,
    DATA TEXT,
    DESCRIPTION TEXT,
    NAME VARCHAR(255),
    TYPE VARCHAR(255),
    PERMISSION_ID BIGINT,
    constraint FKRYMA152GJMY0YAW8DED9L4YCH
        foreign key (PERMISSION_ID) references PERMISSION (ID)
);

create table TASK
(
    ID BIGINT auto_increment
        primary key,
    DESCRIPTION TEXT,
    NAME VARCHAR(255),
    PART_TASK_PRACTICE BOOLEAN not null,
    SUB_TASKS TEXT,
    TASK_CLASS VARCHAR(255),
    VALUES_MISSING BOOLEAN not null,
    PERMISSION_ID BIGINT,
    constraint FKEG9MDMS7TDIBA0UQHJ2K5K7GO
        foreign key (PERMISSION_ID) references PERMISSION (ID)
);

create table TASK_USED_COATS
(
    USED_IN_TASKS_ID BIGINT not null,
    USED_COATS_ID BIGINT not null,
    primary key (USED_IN_TASKS_ID, USED_COATS_ID),
    constraint FKKD48ALHINUG33SCPOQ4KCWSPX
        foreign key (USED_COATS_ID) references COAT (ID),
    constraint FKMAA9DM3HDSC33PXJ3LVOOKCD7
        foreign key (USED_IN_TASKS_ID) references TASK (ID)
);

create table TASK_USED_MEDIA
(
    USED_IN_TASKS_ID BIGINT not null,
    USED_MEDIA_ID BIGINT not null,
    primary key (USED_IN_TASKS_ID, USED_MEDIA_ID),
    constraint FK30VRY9LV4CR7A0OLCSIGXJ98Y
        foreign key (USED_IN_TASKS_ID) references TASK (ID),
    constraint FKJAD0OV20UQRWGHRLTJNJH5G24
        foreign key (USED_MEDIA_ID) references MEDIA (ID)
);

create table TASK_COLLECTION
(
    ID BIGINT auto_increment
        primary key,
    DESCRIPTION TEXT,
    NAME VARCHAR(255),
    TASK_CLASS VARCHAR(255),
    PERMISSION_ID BIGINT,
    constraint FK4IW4U1026LVKK2WKJVPWD1UVN
        foreign key (PERMISSION_ID) references PERMISSION (ID)
);

create table TASK_COLLECTION_ELEMENT
(
    ID BIGINT auto_increment
        primary key,
    IDX INTEGER,
    MANDATORY BOOLEAN not null,
    TASK_ID BIGINT,
    TASK_COLLECTION_ID BIGINT,
    constraint FK6M9OSNNKOKTSJ0BGE6OFLDHM1
        foreign key (TASK_ID) references TASK (ID)
            on delete cascade,
    constraint FKB3AOMAULJXKCGQEXTFRQE55KK
        foreign key (TASK_COLLECTION_ID) references TASK_COLLECTION (ID)
);

create table USER_GROUP
(
    ID BIGINT auto_increment
        primary key,
    NAME VARCHAR(255)
);

create table USER_GROUP_USERS
(
    USER_GROUPS_ID BIGINT not null,
    USERS_ID BIGINT not null,
    constraint FK2NXN2LRSVHE42SWJQOBMN77FK
        foreign key (USERS_ID) references USER (ID),
    constraint FK5JWWKG2TFSQH9F7C090MI1PM7
        foreign key (USER_GROUPS_ID) references USER_GROUP (ID)
);

create table USER_GROUP_TASK_ASSIGNMENT
(
    ID BIGINT auto_increment
        primary key,
    DEADLINE TIMESTAMP,
    TASK_ID BIGINT,
    TASK_COLLECTION_ID BIGINT,
    USER_GROUP_ID BIGINT,
    constraint FK4Y61JKXMKLUYLNBGC1TF1DCLR
        foreign key (USER_GROUP_ID) references USER_GROUP (ID),
    constraint FK6VQJHUW9DQP4UTGMAC5P5RJ3P
        foreign key (TASK_COLLECTION_ID) references TASK_COLLECTION (ID),
    constraint FK9Y9NACEQNB283J84338QC7M1A
        foreign key (TASK_ID) references TASK (ID)
);

create table TASK_COLLECTION_ASSIGNMENT
(
    ID BIGINT auto_increment
        primary key,
    DEADLINE TIMESTAMP,
    TASK_COLLECTION_ID BIGINT,
    USER_ID BIGINT,
    USER_GROUP_TASK_ASSIGNMENT_ID BIGINT,
    constraint FKFJADWJXMUCUFUCNHVWPDW3YFS
        foreign key (USER_ID) references USER (ID),
    constraint FKME3ANPMMQG0BIYBE5G20CFWAK
        foreign key (TASK_COLLECTION_ID) references TASK_COLLECTION (ID),
    constraint FKSYAHQJEKRQ5U31XL2LTWB3EGD
        foreign key (USER_GROUP_TASK_ASSIGNMENT_ID) references USER_GROUP_TASK_ASSIGNMENT (ID)
);

create table TASK_ASSIGNMENT
(
    ID BIGINT auto_increment
        primary key,
    DEADLINE TIMESTAMP,
    TASK_ID BIGINT,
    TASK_COLLECTION_ASSIGNMENT_ID BIGINT,
    USER_ID BIGINT,
    USER_GROUP_TASK_ASSIGNMENT_ID BIGINT,
    constraint FK3A6B9L4YWS7COUS67XFCF0G5H
        foreign key (TASK_COLLECTION_ASSIGNMENT_ID) references TASK_COLLECTION_ASSIGNMENT (ID),
    constraint FKAIDRKVIIQEA4K3WN2E0WUOO4I
        foreign key (USER_GROUP_TASK_ASSIGNMENT_ID) references USER_GROUP_TASK_ASSIGNMENT (ID),
    constraint FKBIBOAX1AVMN0WVHG1CBXS8QDS
        foreign key (USER_ID) references USER (ID),
    constraint FKJEC38NL7LFMLGDN036W0H3HBT
        foreign key (TASK_ID) references TASK (ID)
);

create table WORKPIECE
(
    ID BIGINT auto_increment
        primary key,
    DATA TEXT,
    NAME VARCHAR(255),
    PERMISSION_ID BIGINT,
    constraint FKJ0238WQQYI652H18DWYG1I5E5
        foreign key (PERMISSION_ID) references PERMISSION (ID)
);

create table RECORDING
(
    ID BIGINT auto_increment
        primary key,
    DATA TEXT,
    DATE TIMESTAMP,
    DESCRIPTION TEXT,
    HASH VARCHAR(255),
    NAME VARCHAR(255),
    NEEDED_TIME FLOAT not null,
    BASE_COAT_ID BIGINT,
    COAT_ID BIGINT,
    PERMISSION_ID BIGINT,
    TASK_RESULT_ID BIGINT,
    WORKPIECE_ID BIGINT,
    constraint FK2DD59QK6SBF14VJV5BTE4I1BR
        foreign key (COAT_ID) references COAT (ID),
    constraint FK3C1LPHFG9AX7IUG5X5YRN1N6L
        foreign key (BASE_COAT_ID) references COAT (ID),
    constraint FKLIEPADQ9P2WR2CXNFB4K7J1FC
        foreign key (WORKPIECE_ID) references WORKPIECE (ID),
    constraint FKSR72ERWI953PXH664V942CMHO
        foreign key (PERMISSION_ID) references PERMISSION (ID)
);

create table TASK_USED_RECORDINGS
(
    USED_IN_TASKS_ID BIGINT not null,
    USED_RECORDINGS_ID BIGINT not null,
    primary key (USED_IN_TASKS_ID, USED_RECORDINGS_ID),
    constraint FKCW4YVGH9YUGCC9PQC6917KMB3
        foreign key (USED_RECORDINGS_ID) references RECORDING (ID),
    constraint FKHUOWH9RSJ7ETJT2W3Y8NISMFL
        foreign key (USED_IN_TASKS_ID) references TASK (ID)
);

create table TASK_USED_WORKPIECES
(
    USED_IN_TASKS_ID BIGINT not null,
    USED_WORKPIECES_ID BIGINT not null,
    primary key (USED_IN_TASKS_ID, USED_WORKPIECES_ID),
    constraint FK7MOQ04KJSMA025UA6FY5EPFCJ
        foreign key (USED_IN_TASKS_ID) references TASK (ID),
    constraint FKE358RUB9VD276PO8M0SC8L61P
        foreign key (USED_WORKPIECES_ID) references WORKPIECE (ID)
);

create table TASK_RESULT
(
    ID BIGINT auto_increment
        primary key,
    RECORDING_ID BIGINT not null
        constraint UK_Y0UU7GFWAUI59C8XKAGLPVJO
        unique,
    TASK_ASSIGNMENT_ID BIGINT not null,
    constraint FKCLVH47C6LD6FYR6GE6559V3QL
        foreign key (RECORDING_ID) references RECORDING (ID)
            on delete cascade,
    constraint FKK472C3GAU6WV8WK035EUCM6UJ
        foreign key (TASK_ASSIGNMENT_ID) references TASK_ASSIGNMENT (ID)
);

alter table RECORDING
    add constraint FK5O7BW0BBXWM7SVBRIL4K9BNJD
        foreign key (TASK_RESULT_ID) references TASK_RESULT (ID);


-- PW: password
INSERT INTO USER (ID, FULL_NAME, PWD, PASSWORD_CHANGED, ROLE, USER_NAME) VALUES (1, 'Ausbildungsmeister', '$2a$10$gPYSkOveyRMbxgSvyhmq1e/SbMQjo.0rbZ0srSKdS7uWU/mvCoYwq', false, 'Teacher', 'Ausbildungsmeister');


INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (1, 'Audio\Begrüßung (Selbstgesteuerte Lernaufgabe).wav', 'Ausbildungsmeister spricht folgenden Text: Hallo. Dein heutiger Kundenauftrag lautet, eine Tür mit einer Einschichtlackierung in rot zu lackieren. Dabei sollst du heute besonders auf den optimalen Abstand zum Werkstück beim Lackieren achten. Hierfür bekommst du eine visuelle Hilfe, die dir den idealen Abstand zum Werkstück anzeigt: die „Abstandshilfe“. Diese erscheint, wenn die Lackierpistole auf das Werkstück zeigt. Du hast bereits gemäß des Arbeitsfolgeplanes das Werkstück instandgesetzt, eine optische Prüfung des Werkstücks durchgeführt, deine PSA angelegt und den benötigten Lack angemischt. Möchtest du dir nun unterstützende Informationen anschauen? Ansonsten mache eine Spritzprobe und beginne anschließend mit dem Lackieren!.', 'Begrüßung (Selbstgesteuerte Lernaufgabe)', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (2, 'Videos\Härter und Verdünner.mp4', 'Ein Video in dem die richtige Anwendung von Härtern und Verdünnern erklärt wird.', 'Härter und Verdünner', 'Video', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (3, 'Audio\Spritzprobe durchführen.mp3', 'Der Ausbildungsmeister weist darauf hin, dass nun eine Spritzprobe durchgeführt werden soll.', 'Spritzprobe durchführen', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (4, 'Audio\Erklärung Distanzstrahl.wav', 'Der Ausbildungsmeister erklärt den Distanzstrahl.', 'Erklärung Distanzstrahl', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (5, 'Audio\Was bedeuten die Farben.ogg', 'Der Ausbildungsmeister erklärt die Heatmap.', 'Was bedeuten die Farben', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (6, 'Audio\Erklärung Übung mit Distanzstrahl.mp3', 'Der Ausbildungsmeister führt in die Aufgabe ein und erklärt den Distanzstrahl.', 'Erklärung Übung mit Distanzstrahl', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (9, 'Images\Läufer.png', 'Ein Bild von einem Läufer.', 'Läufer', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (10, 'Images\Mager.png', 'Ein Bild von einem Bereich in dem die Farbe mager ist.', 'Mager', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (11, 'Images\Tropfen.png', 'Ein Bild von einem Tropfen.', 'Tropfen', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (12, 'Audio\Begrüßung (Fremdgesteuerte Lernaufgabe).wav', 'Ausbildungsmeister spricht folgenden Text: Hallo. Dein heutiger Kundenauftrag lautet, eine Motorhaube mit einer Einschicht Unilackierung in rot zu lackieren. Dabei sollst du heute besonders auf den optimalen Abstand zum Werkstück beim Lackieren achten. Hierfür bekommst du eine visuelle Hilfe, die dir den idealen Abstand zum Werkstück anzeigt: die „Abstandshilfe“. Diese erscheint, wenn die Lackierpistole auf das Werkstück zeigt. Du hast bereits gemäß des Arbeitsfolgeplanes das Werkstück instandgesetzt, eine optische Prüfung des Werkstücks durchgeführt, deine PSA angelegt und den benötigten Lack angemischt. Informiere dich nun zu relevanten Themen bei dieser Lernaufgabe.', 'Begrüßung (Fremdgesteuerte Lernaufgabe)', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (13, 'Audio\Erinnerung (Fremdgesteuerte Lernaufgabe).wav', 'Informiere dich zu allen Themenbereichen und beginne im Anschluss mit der Spritzprobe.', 'Erinnerung (Fremdgesteuerte Lernaufgabe)', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (14, 'Audio\Erinnerung (Selbstgesteuerte Lernaufgabe).wav', 'Informiere dich zu relevanten Themenbereichen oder beginne mit der Spritzprobe.', 'Erinnerung (Selbstgesteuerte Lernaufgabe)', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (15, 'Audio\Erklärung Geisterpistole.wav', 'Der Ausbildungsmeister erklärt die Geisterpistole.', 'Erklärung Geisterpistole', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (16, 'Audio\Erklärung Übung mit Geisterpistole.wav', 'Der Ausbildungsmeister führt in die Übung ein und erklärt die Geisterpistole.', 'Erklärung Übung mit Geisterpistole', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (17, 'Audio\Erklärung Übung ohne Geisterpistole.wav', 'Der Ausbildungsmeister führt in die Übung ein.', 'Erklärung Übung ohne Geisterpistole', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (18, 'Audio\Erklärung Übung ohne Distanzstrahl.wav', 'Der Ausbildungsmeister führt in die Übung ein.', 'Erklärung Übung ohne Distanzstrahl', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (19, 'Videos\Viskosität messen.mp4', 'Ein Video in dem die richtige Messung der Viskosität gezeigt wird.', 'Viskosität messen', 'Video', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (20, 'Audio\Finale Erinnerung (Fremdgesteuerte Lernaufgabe).wav', 'Prüfe das Spritzbild anhand einer Spritzprobe und beginne anschließend mit dem Lackieren.', 'Finale Erinnerung (Fremdgesteuerte Lernaufgabe)', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (21, 'Audio\Neuteillackierung 3 - Einleitung.wav', 'Schön, dass du wieder da bist. Wir befinden uns mitten in der ersten Aufgabenklasse zu Neuteillackierungen. Im zu dieser Lernaufgabe gehörigen Kundenauftrag geht es darum, eine Motorhaube mit einer Zweischichtlackierung zu lackieren. Was versteht man überhaupt unter einer Zweischichtlackierung? Lege alle Bestandteile, die du für eine Zweischichtlackierung benötigst, in den Korb.', 'Neuteillackierung 3 - Einleitung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (22, 'Audio\Neuteillackierung 3 - Decklackierungen.wav', 'Lerne nun mehr über die Unterschiede zwischen Ein-, Zwei- und Dreischichtlackierungen.', 'Neuteillackierung 3 - Decklackierungen', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (23, 'Audio\Neuteillackierung 3 - Lackauswahl.wav', 'Du hast nun die Möglichkeit, den Kundenauftrag mitzugestalten. In welcher Farbe soll die Motorhaube lackiert werden?', 'Neuteillackierung 3 - Lackauswahl', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (24, 'Audio\Neuteillackierung 3 - Kundenauftrag.wav', 'Der Kundenauftrag beinhaltet also eine Zweischichtlackierung auf einer Motorhaube. Im Vorhinein wurden bereits sämtliche vorbereitenden Tätigkeiten, z.B. optische Prüfung, Reinigungsarbeiten, Mischen der Farben erledigt. Daher starten wir direkt mit der Applikation. Gleich wirst du sehen, wie ich zuerst den Basislack, dann den Klarlack auf der Haube appliziere. Achte dabei genau auf den Verlauf, Winkel und Abstand der Lackierpistole. Bist du startklar?', 'Neuteillackierung 3 - Kundenauftrag', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (26, 'Audio\Neuteillackierung 3 - Verarbeitungsrichtlinien.wav', 'Herstellerabhängige Verarbeitungsrichtlinien für Beschichtungsstoffe liefern dir wichtige Informationen zu den Eigenschaften eines Lacks. Unter anderem weisen dich die Herstellerinformationen auf die optimale Ablüft- und Trockenzeit hin.', 'Neuteillackierung 3 - Verarbeitungsrichtlinien', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (27, 'Audio\Neuteillackierung 3 - Merkblatt öffnen.wav', 'Öffne die Verarbeitungsrichtlinien und versuche herauszufinden, wie lange Ablüft- und Trockenzeit bei diesem Basislack betragen sollte.', 'Neuteillackierung 3 - Merkblatt öffnen', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (28, 'Audio\Neuteillackierung 3 - Aufnahme 2.wav', 'Der Basislack ist nun appliziert. Nach der vorgeschriebenen Ablüft- und Trockenzeit ist er mittlerweile auch matt. Fehlt noch der Klarlack. Schauen wir uns den Gang an, bei dem ich den Klarlack appliziere. Achte dabei wieder genau auf den Verlauf, Winkel und Abstand der Lackierpistole. Weiter geht’s!', 'Neuteillackierung 3 - Aufnahme 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (29, 'Audio\Neuteillackierung 3 - Gütekriterien.wav', 'Was ist dir während der Applikation der Lacke aufgefallen?', 'Neuteillackierung 3 - Gütekriterien', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (30, 'Audio\Neuteillackierung 3 - Überleitung Lackierung.wav', 'Nun bist du an der Reihe. In der Lackierwerkstatt befindet sich eine weitere Motorhaube, auf die du den von dir ausgewählten Basislack in einem deckenden Gang applizieren sollst. Der Basislack ist bereits fertig angemischt. Den Klarlack werde ich nach der vorgeschriebenen Ablüft- und Trockenzeit selbst applizieren. Vorhin hast du gelernt, worauf du beim Lackieren alles achten sollst. Achte auf Verlauf, Abstand und Winkel. Der Distanzstrahl wird dir bei dieser Lernaufgabe wieder helfen, dieses Mal allerdings nur am Anfang und Ende. Bereit? Du schaffst das! Achja, vergiss die Spritzprobe nicht!', 'Neuteillackierung 3 - Überleitung Lackierung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (31, 'Audio\Neuteillackierung 3 - Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Aber was kann man überhaupt durch die Spritzprobe erkennen? Fehler im Spritzbild sind Indizien für Verschmutzungen in der Lackierpistole, Beschädigungen an Düsenelementen usw. Informiere dich auf dem Monitor über die Spritzprobe an sich, über mögliche Fehlerquellen im Spritzbild und erhalte Tipps, wie diese beseitigt werden können. ', 'Neuteillackierung 3 - Spritzprobe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (32, 'Audio\Neuteillackierung 3 - unauffällige Spritzprobe.wav', 'Dein Spritzbild ist aber unauffällig. Du kannst lackieren. ', 'Neuteillackierung 3 - unauffällige Spritzprobe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (33, 'Audio\Neuteillackierung 3 - Auswertung.wav', 'Geschafft. Schau dir bei der Auswertung besonders deine Ergebnisse bei Abstand und Winkel an.', 'Neuteillackierung 3 - Auswertung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (38, 'Images\Decklackierungen 1.png', 'Erste Folie zu Decklackierungen.', 'Decklackierungen 1', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (39, 'Images\Decklackierungen 2.png', '2. Folie zu Decklackierungen.', 'Decklackierungen 2', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (40, 'Images\Decklackierungen 3.png', '3. Folie zu Decklackierungen.', 'Decklackierungen 3', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (41, 'Images\Decklackierungen 4.png', '4. Folie zu Decklackierungen.', 'Decklackierungen 4', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (42, 'Images\Decklackierungen 5.png', '5. Folie zu Decklackierungen.', 'Decklackierungen 5', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (43, 'Images\Decklackierungen 6.png', '6. Folie zu Decklackierungen.', 'Decklackierungen 6', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (44, 'Images\Decklackierungen 7.png', '7. Folie zu Decklackierungen.', 'Decklackierungen 7', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (45, 'Images\Spritzbild 1.png', '1. Folie zum Spritzbild.', 'Spritzbild 1', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (46, 'Images\Spritzbild 2.png', '2. Folie zum Spritzbild.', 'Spritzbild 2', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (47, 'Images\Spritzbild 3.png', '3. Folie zum Spritzbild.', 'Spritzbild 3', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (48, 'Images\Spritzbild 4.png', '4. Folie zum Spritzbild.', 'Spritzbild 4', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (49, 'Images\Spritzbild 5.png', '5. Folie zum Spritzbild.', 'Spritzbild 5', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (50, 'Images\Spritzbild 6.png', '6. Folie zum Spritzbild.', 'Spritzbild 6', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (51, 'Images\Spritzbild 7.png', '7. Folie zum Spritzbild.', 'Spritzbild 7', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (52, 'Images\Spritzbild 8.png', '8. Folie zum Spritzbild.', 'Spritzbild 8', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (53, 'Images\Spritzbild 9.png', '9. Folie zum Spritzbild.', 'Spritzbild 9', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (54, 'Audio\Decklackierungen 1 Erklärung.wav', 'Was versteht man unter Decklackierungen?', 'Decklackierungen 1 Erklärung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (55, 'Audio\Decklackierungen 2 Erklärung.wav', 'Der Decklack oder auch top coat bildet die oberste Schicht des Lackiersystems. Er wird auf den geschliffenen oder den abgelüfteten Füller aufgebracht. Man unterscheidet zwischen Einschicht-Decklackierung, Zwei-Schicht-Decklackierung und Mehrschicht-Decklackierung.  Auf diesem Foto siehst du den Prozess einer Lackierung vom Rohzustand über Verzinkung, Phosphatierung, Füllern hin zur Decklackierung. In der obersten Zeile siehst du zum Beispiel die Einschicht-Uni-Lackierung. In der Zeile darunter die Zwei-Schicht-Uni-Lackierung. Darunter die Zwei-Schicht-Uni-Lackierung in Metallic und so weiter.', 'Decklackierungen 2 Erklärung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (56, 'Audio\Decklackierungen 3 Erklärung.wav', 'Aber was genau sind nun die Unterschiede zwischen Einschicht-Decklackierung, Zweischicht-Decklackierung und Mehrschicht-Decklackierung?', 'Decklackierungen 3 Erklärung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (57, 'Audio\Decklackierungen 4 Erklärung.wav', 'Unter einer Einschicht-Decklackierung versteht man einen Decklack, der nur aus einer Schicht besteht. Diese Schicht enthält die farbgebenden Komponenten und schützt gleichzeitig die darunterliegenden Schichten durch seine hohe mechanische und chemische Beständigkeit.', 'Decklackierungen 4 Erklärung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (58, 'Audio\Decklackierungen 5 Erklärung.wav', 'Unter einer Zweischicht-Decklackierung versteht man einen Decklack, der aus zwei Schichten besteht, dem Basislack und dem Klarlack. Der Einkomponenten-Basislack ist ein physikalisch trocknender Einkomponentenlack. Das heißt er trocknet durch die Verdunstung des Lösemittels. Danach erscheint die Oberfläche matt. Der Basislack enthält die farbgebende Komponente. Bei Metallic- und Perleffekt-Lackierungen sind zusätzlich noch die Effektpigmente in Form kleiner Metall- oder Glimmerplättchen eingelagert.  Der Basislack ist nicht witterungsbeständig. Deswegen muss er durch eine zweite Lackschicht, den unpigmentierten Klarlack, geschützt werden.  Gleichzeitig verleiht er der Lackierung hohen Glanz. Er wird nach der vorgeschriebenen Ablüftzeit nass-in-nass auf den Basislack aufgespritzt.', 'Decklackierungen 5 Erklärung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (59, 'Audio\Decklackierungen 6 Erklärung.wav', 'Manche Lackierungen wie beispielsweise Perleffekt-Lackierungen benötigen noch zusätzliche Lackschichten. So wird auf die Schicht mit den effektgebenden Pigmenten eine weitere Schicht mit farbgebenden Pigmenten aufgetragen. So kommt der Perleffekt besser zur Erscheinung. Anschließend wird noch mit normalem Klarlack überlackiert.', 'Decklackierungen 6 Erklärung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (60, 'Audio\Neuteillackierung 1 - Einleitung.wav', 'Hallo. Wir befinden uns ganz am Anfang der ersten Aufgabenklasse, in der es um Neuteillackierungen gehen wird. Während der Aufgabenklasse bearbeitest du sechs zu der Aufgabenklasse dazugehörige Lernaufgaben. Jede der sechs Lernaufgaben behandelt einen Kundenauftrag. Gleich werde ich dir erläutern, was es bei Neuteillackierungen zu beachten gilt. Ich werde dir auch zeigen, wie ich einen Basislack Einschicht-Uni-Lack auf einen neuen Kotflügel auftrage. Pass gut auf! Bist du startklar?', 'Neuteillackierung 1 - Einleitung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (61, 'Audio\Neuteillackierung 1 - Aufgabenstellung.wav', 'Der Kundenauftrag lautet einen neuen Kotflügel aus Stahlblech zu beschichten. Zuerst geht es an die Vorbereitung der Lackierung. Hier muss bereits sehr sorgfältig gearbeitet werden, um später eine perfekte Lackoberfläche zu erzielen. Für Teillackierungen werden leicht zu demontierende Teile, wie bei unserem Beispiel der Kotflügel, ausgebaut. Es handelt sich um eine Neulackierung. Daher sollten die Untergründe bereits fertig vorbereitet sein. Dennoch lohnt sich eine Kontrolle. Zuerst habe ich den Kotflügel visuell und haptisch auf Beschädigungen wie Dellen oder Kratzer geprüft. Ich habe keine Schäden feststellen können. Zu einer guten Vorbereitung gehört es auch, seine Werkzeuge, Materialien und persönliche Schutzausrüstung vorzubereiten und bereit zu legen.', 'Neuteillackierung 1 - Aufgabenstellung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (62, 'Audio\Neuteillackierung 1 - Frage Arbeitsschutz.wav', 'Achja, Arbeitsschutz. Das ist ein wichtiges Thema, das du verinnerlichen solltest. Täglich trägst du Handschuhe, die deine Haut vor Chemikalien schützt. Weißt du, was die Schutzklassen 1-6 bei Schutzhandschuhen bedeuten? ', 'Neuteillackierung 1 - Frage Arbeitsschutz', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (63, 'Audio\Neuteillackierung 1 - Frage Arbeitsschutz Feedback.wav', 'Von dieser Kategorisierung hängt auch ab, wie oft Handschuhe gewechselt werden müssen.', 'Neuteillackierung 1 - Frage Arbeitsschutz Feedback', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (64, 'Audio\Neuteillackierung 1 - Information Arbeitsablauf.wav', 'Dann wird das Werkstück angeschliffen, gründlich gereinigt, entfettet und entstaubt. Für eine optimale Haftung von Grundierung, Füller oder Lack muss das Werkstück von Fett, Öl, Wachs und Silikon gesäubert werden. Falls doch Unebenheiten oder Dellen vorhanden sind oder Vertiefungen auftauchen, werden diese anschließend mit einem Polyesterspachtel bearbeitet. Die Spachtelschicht wird nochmals geschliffen und gereinigt. Blanke Metallteile werden nun mit einer Grundierung behandelt. Diese Schicht schützt vor Korrosion und dient als Haftvermittler zwischen Karosserieteil und Schichtaufbau. Eine Füllerschicht sorgt anschließend für eine glatte Oberfläche und füllt feinste Poren und Microkratzer.', 'Neuteillackierung 1 - Information Arbeitsablauf', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (65, 'Audio\Neuteillackierung 1 - Interaktive Frage Trocknung 1.wav', 'Weißt du, wie lange eine Füllerschicht, die mit einem 2-Komponenten Nass-in-Nass Grundierfüller appliziert wurde, bei 60 bis 65 Grad im Ofen trocknen sollte?', 'Neuteillackierung 1 - Interaktive Frage Trocknung 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (66, 'Audio\Neuteillackierung 1 - Interaktive Frage Trocknung 1 Feedback.wav', 'Bei Ofentrocknung bei etwa 60 Grad sollte das Karosserieteil 45 Minuten trocknen. Anders sieht das bei Lufttrocknung aus. Das dauert 12 bis 16 Stunden bei einer Umgebungstemperatur von 25 Grad. Bei Infrarotstrahler Trocknung geht es besonders schnell. Maximal 12 Minuten. ', 'Neuteillackierung 1 - Interaktive Frage Trocknung 1 Feedback', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (67, 'Audio\Neuteillackierung 1 - Interaktive Frage Farbmenge.wav', 'Ich habe auch schon den Basislack angemischt, gemäß Kundenauftrag die Farbe Canvasitblau. Was schätzt du, wie viel Menge du für die Lackierung eines Kotflügels benötigst?', 'Neuteillackierung 1 - Interaktive Frage Farbmenge', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (68, 'Audio\Neuteillackierung 1 - Aufnahme.wav', 'Ich zeige dir nun, wie ich den Unilack in einem deckenden Gang auftrage. Der Lack wurde in dem Farbton des Fahrzeuges gemäß Farbcode angemischt.', 'Neuteillackierung 1 - Aufnahme', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (69, 'Audio\Neuteillackierung 1 - Interaktive Frage Trocknung 2.wav', 'Geschafft. Kannst du dich noch erinnern, wie lange der Unilack bei Infrarotstrahler-Trocknung maximal trocknen muss?', 'Neuteillackierung 1 - Interaktive Frage Trocknung 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (70, 'Audio\Neuteillackierung 1 - Überleitung Lackieren.wav', 'Nun bist du an der Reihe. In der Lackierwerkstatt befindet sich ein weiterer Kotflügel, der darauf wartet, von dir mit einem Unilack in Tieforange lackiert zu werden. Den Basislack habe ich bereits für dich vorbereitet. Du kannst direkt starten und einen deckenden Gang applizieren. Der Distanzstrahl wird dir bei dieser Lernaufgabe die ganze Zeit dabei helfen, den idealen Abstand zum Werkstück einzuhalten. Bevor du allerdings mit dem Lackieren loslegst, darfst du einen wichtigen Schritt nicht vergessen. Die Spritzprobe. In der Lackierkabine befindet sich ein Test-Papier für die Spritzprobe, auf dem du die Spritzprobe durchführen kannst. Los geht’s!', 'Neuteillackierung 1 - Überleitung Lackieren', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (71, 'Audio\Neuteillackierung 1 - Feedback Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Du kannst nun lackieren.', 'Neuteillackierung 1 - Feedback Spritzprobe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (72, 'Audio\Neuteillackierung 1 - Frage Messung Schichtdicke.wav', 'Geschafft. Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einem Werkstück aus Stahl, wie in unserem Fall?', 'Neuteillackierung 1 - Frage Messung Schichtdicke', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (73, 'Audio\Neuteillackierung 1 - Abschluss.wav', 'Wichtig ist außerdem, dass du vor jeder Kundenübergabe das Werkstück noch einmal mit einer Poliermaschine oder einem Polierschwamm auf Hochglanz polierst und abschließend letzte Verschmutzungen mit einem Mikrofasertuch reinigst.', 'Neuteillackierung 1 - Abschluss', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (75, 'Audio\Neuteillackierung 2 - Einleitung.wav', 'Hallo. Wir befinden uns noch immer recht am Anfang der ersten Aufgabenklasse, in der es um Neuteillackierungen geht. Hier siehst du das Produkt eines Kundenauftrages, bei dem wir bereits eine neue Autotür aus Aluminium mit einem Unilack in Hibiskus Rot lackiert haben. Guck dir das lackierte Werkstück genau an. Dafür kannst du dir im Menüfeld Auswertung die Erfolgskriterien anschauen oder die Lupe nutzen. Welche typischen Lackierfehler sind zu beobachten?', 'Neuteillackierung 2 - Einleitung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (76, 'Audio\Neuteillackierung 2 - Aufgabenstellung.wav', 'Bei der Bearbeitung des Kundenauftrages sind wohl einige Fehler passiert. Vielleicht sind sie dir schon aufgefallen. Schauen wir uns das Werkstück nochmal gemeinsam an. Oben links zum Beispiel ist ein dicker Läufer entstanden. So ist die Tür auf keinen Fall kundenfähig.', 'Neuteillackierung 2 - Aufgabenstellung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (77, 'Audio\Neuteillackierung 2 - Multiple Choice 1.wav', 'Wie entstehen solche Läufer? Läufer entstehen durch eine zu hohe Schichtdicke. Unter Anwendung einer falschen Geschwindigkeit wird das Material nicht gleichmäßig verteilt. Durch die Schwerkraft wird das Material nach unten gezogen. Im Extremfall fließt es sogar gardinenartig nach unten. Läufer im Lack gehören zu den typischen Lackierfehlern, die nicht nur bei Anfängern, sondern auch bei erfahrenen Lackiererinnen und Lackierern immer mal wieder vorkommen. Das liegt daran, dass mehrere Ursachen für die ärgerlichen Lackläufer verantwortlich sein können. Welche der Antwortmöglichkeiten treffen als Ursachen für Läufer zu?', 'Neuteillackierung 2 - Multiple Choice 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (78, 'Audio\Neuteillackierung 2 - Multiple Choice 1 Lösung.wav', 'Merke: Zu viel oder falscher Verdünner, zu geringer Abstand zum Werkstück, zu langsame Applikation, zu kurze Ablüftzeiten oder eine zu niedrige Temperatur der Kabine oder des Lacks können zu Läufern führen.', 'Neuteillackierung 2 - Multiple Choice 1 Lösung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (79, 'Audio\Neuteillackierung 2 - Schätzaufgabe.wav', 'Läufer vermeidest du, indem du den Lack immer gemäß technischem Merkblatt mit Härter und Verdünnung anmischst und auf seine Viskosität überprüfst. Außerdem solltest du auf die ideale Lackiertemperatur achten. Weißt du, wie die sein sollte?', 'Neuteillackierung 2 - Schätzaufgabe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (80, 'Audio\Neuteillackierung 2 - Läufer.wav', 'Was aber tun, wenn Läufer bereits entstanden sind? Schaue dir nun an, wie man Läufer im Lack beheben kann. ', 'Neuteillackierung 2 - Läufer', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (81, 'Audio\Neuteillackierung 2 - Verlaufsstörungen.wav', 'Verlaufsstörungen sind ein weiteres Ärgernis. Unter einer Verlaufsstörung versteht man eine Oberflächenstruktur, die der Oberfläche einer Apfelsinen- oder Orangenschale ähnelt. Die Ursachen für Verlaufsstörungen können sehr vielfältig sein. Auf dem Bildschirm stehen die wichtigsten. Merke sie dir gut.', 'Neuteillackierung 2 - Verlaufsstörungen', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (82, 'Audio\Neuteillackierung 2 - Vergessene Kanten.wav', 'Unten rechts an der Kante wurde scheinbar vergessen zu lackieren. Auch wenn manche Stellen schwer zu erreichen sind und auch der Lack schwieriger zu applizieren, ist gründliches Arbeiten notwendig, um kundenfähige Produkte zu erhalten.', 'Neuteillackierung 2 - Vergessene Kanten', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (83, 'Audio\Neuteillackierung 2 - Überleitung Lackieren.wav', 'Bei sämtlichen Schritten in der Aufgabenfolge können Fehler passieren, die sich im Lackierergebnis widerspiegeln. Daher ist es umso wichtiger mit deinem Ausbildungsmeister oder anderen Auszubildenden zu reflektieren, wodurch Fehler entstanden sind und wie du sie beim nächsten Mal vermeiden kannst. Du hast jetzt die Gelegenheit, den vorliegenden Kundenauftrag besser zu bearbeiten als dargeboten. Eine weitere Autotür wartet nur darauf, von dir in einem deckenden Gang im Unilack in Hibiskus Rot lackiert zu werden. Ich habe bereits alles für dich vorbereitet, du kannst direkt loslegen. Der Distanzstrahl wird dir bei dieser Lernaufgabe erneut die ganze Zeit dabei helfen, den idealen Abstand zum Werkstück einzuhalten. Bevor du allerdings mit dem Lackieren loslegst, darfst du einen wichtigen Schritt nicht vergessen. Die Spritzprobe. Bist du startklar?', 'Neuteillackierung 2 - Überleitung Lackieren', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (84, 'Audio\Neuteillackierung 2 - Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Du kannst nun lackieren.', 'Neuteillackierung 2 - Spritzprobe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (85, 'Audio\Neuteillackierung 2 - Multiple Choice Frage 2.wav', 'Geschafft. Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einer Autotür aus Aluminium?', 'Neuteillackierung 2 - Multiple Choice Frage 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (86, 'Images\Läufer 1.png', 'Bild 1 der Präsentation zu Läufern.', 'Läufer 1', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (87, 'Images\Läufer 2.png', 'Bild 2 der Präsentation zu Läufern.', 'Läufer 2', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (88, 'Images\Läufer 3.png', 'Bild 3 der Präsentation zu Läufern.', 'Läufer 3', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (89, 'Images\Läufer 4.png', 'Bild 4 der Präsentation zu Läufern.', 'Läufer 4', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (90, 'Images\Läufer 5.png', 'Bild 5 der Präsentation zu Läufern.', 'Läufer 5', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (91, 'Images\Läufer 6.png', 'Bild 6 der Präsentation zu Läufern.', 'Läufer 6', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (92, 'Images\Läufer 7.png', 'Bild 7 der Präsentation zu Läufern.', 'Läufer 7', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (93, 'Audio\Neuteillackierung 1e - Einleitung.wav', 'Hallo. Wir befinden uns ganz am Anfang der ersten Aufgabenklasse, in der es um Neuteil Lackierungen gehen wird. Jede der sechs Lernaufgaben behandelt einen Kundenauftrag. Hier siehst du das Produkt eines Kundenauftrages, bei dem wir bereits eine neue Autotür aus Aluminium mit einem Unilack in Hibiskus Rot lackiert haben. Momentan siehst du die Heatmap, die dir die Schichtdicke anzeigt. Guck dir das lackierte Werkstück genau an. Dafür kannst du dir im Menüfeld Auswertung die Erfolgskriterien anschauen oder die Lupe in deiner Hand nutzen. Welche typischen Lackierfehler sind zu beobachten?', 'Neuteillackierung 1e - Einleitung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (94, 'Audio\Neuteillackierung 1e - Aufgabenstellung.wav', 'Bei der Bearbeitung des Kundenauftrages sind wohl einige Fehler passiert. Vielleicht sind sie dir schon aufgefallen. Schauen wir uns das Werkstück nochmal gemeinsam an. Oben links zum Beispiel ist ein dicker Läufer entstanden. So ist die Tür auf keinen Fall kundenfähig.', 'Neuteillackierung 1e - Aufgabenstellung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (95, 'Audio\Neuteillackierung 1e - Multiple Choice.wav', 'Wie entstehen solche Läufer? Läufer entstehen durch eine zu hohe Schichtdicke. Unter Anwendung einer falschen Geschwindigkeit wird das Material nicht gleichmäßig verteilt. Durch die Schwerkraft wird das Material nach unten gezogen. Im Extremfall fließt es sogar gardinenartig nach unten. Läufer im Lack gehören zu den typischen Lackierfehlern. Das liegt daran, dass mehrere Ursachen für die ärgerlichen Lackläufer verantwortlich sein können. Welche der Antwortmöglichkeiten treffen als Ursachen für Läufer zu?', 'Neuteillackierung 1e - Multiple Choice', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (96, 'Audio\Neuteillackierung 1e - Schätzaufgabe.wav', 'Läufer vermeidest du, indem du den Lack immer gemäß technischem Merkblatt mit Härter und Verdünnung anmischst und auf seine Viskosität überprüfst. Außerdem solltest du auf die ideale Lackiertemperatur achten. Weißt du, wie die sein sollte?', 'Neuteillackierung 1e - Schätzaufgabe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (97, 'Audio\Neuteillackierung 1e - Unterstüzende Information.wav', 'Was aber tun, wenn Läufer bereits entstanden sind? Schaue dir nun eine Präsentation an, in der erklärt wird, wie man Läufer im Lack beheben kann.', 'Neuteillackierung 1e - Unterstüzende Information', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (98, 'Audio\Neuteillackierung 1e - Arbeitsauftrag.wav', 'Du hast jetzt die Gelegenheit, den vorliegenden Kundenauftrag besser zu bearbeiten als dargeboten. Eine weitere Autotür wartet nur darauf, von dir im Unilack in Hibiskus Rot lackiert zu werden. Ich habe bereits alles für dich vorbereitet, du kannst direkt loslegen. Der Distanzstrahl wird dir bei dieser Lernaufgabe die ganze Zeit dabei helfen, den idealen Abstand zum Werkstück einzuhalten. Bevor du allerdings mit dem Lackieren loslegst, darfst du einen wichtigen Schritt nicht vergessen. Die Spritzprobe. In der Lackierkabine befindet sich ein Test-Papier, auf dem du die Spritzprobe durchführen kannst. Bist du startklar?', 'Neuteillackierung 1e - Arbeitsauftrag', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (99, 'Audio\Neuteillackierung 1e - Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Du kannst nun lackieren.', 'Neuteillackierung 1e - Spritzprobe', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (100, 'Audio\Neuteillackierung 1e - Auswertung.wav', 'Geschafft. Auf dem Werkstück siehst du nun die Heatmap. An den roten Stellen hast du zu viel Lack appliziert, an den blauen Stellen zu wenig und an den grünen Stellen genau richtig. Du kannst dir auf dem Bildschirm unter dem Feld Auswertung auch noch andere Bewertungskriterien anschauen.', 'Neuteillackierung 1e - Auswertung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (101, 'Audio\Neuteillackierung 1e - Selbsteinschätzung.wav', 'Wie zufrieden bist du mit deiner Leistung in dieser Lernaufgabe? Auf dem Tisch befinden sich drei goldene Lackierpistolen. Packe entsprechend deiner Leistung in der Lernaufgabe so viele Lackierpistolen in den Korb nach links wie du für angemessen empfindest.', 'Neuteillackierung 1e - Selbsteinschätzung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (102, 'Audio\Neuteillackierung PTPe - Multiple Choice.wav', 'Dies ist die erste von mehreren zusätzlichen Übungen in dieser Aufgabenklasse, in der du üben sollst, den idealen Abstand zum Werkstück während des Lackierens einzuhalten. Was ist nochmal der ideale Abstand zum Werkstück?', 'Neuteillackierung PTPe - Multiple Choice', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (103, 'Audio\Neuteillackierung PTPe - Multiple Choice Lösung.wav', 'Der ideale Abstand beträgt also 15-20cm. Vielen Auszubildenden fällt es schwer, sich permanent im korrekten Abstand zu befinden. Bedenke im Vorhinein, ob du das Werkstück noch anders ausrichten muss. Es kann auch gut sein, dass du in die Knie gehen oder dich strecken musst.', 'Neuteillackierung PTPe - Multiple Choice Lösung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (104, 'Audio\Neuteillackierung PTPe - Aufgabenstellung.wav', 'Positioniere dich nun mit Hilfe des Distanzstrahls im idealen Abstand zum Werkstück und lackiere anschließend das gesamte Werkstück in einem Gang. Achte dabei besonders darauf, die ganze Zeit den idealen Abstand einzuhalten. Dabei wird dir der Distanzstrahl helfen.', 'Neuteillackierung PTPe - Aufgabenstellung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (105, 'Audio\Neuteillackierung PTP1 - Multiple Choice 1.wav', 'Dies ist die erste von drei zusätzlichen Übungen in dieser Aufgabenklasse, in der du üben sollst, den idealen Abstand zum Werkstück während des Lackierens einzuhalten. Was ist nochmal der ideale Abstand zum Werkstück?', 'Neuteillackierung PTP1 - Multiple Choice 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (106, 'Audio\Neuteillackierung PTP1 - Multiple Choice 1 Lösung.wav', 'Der ideale Abstand beträgt also 15-20cm. Vielen Auszubildenden fällt es schwer, sich permanent im korrekten Abstand zu befinden. Das kann je nach Werkstück und Rahmenbedingungen auch gar nicht so einfach sein. Bedenke im Vorhinein, ob du das Werkstück noch anders ausrichten muss. Es kann auch gut sein, dass du in die Knie gehen oder dich strecken musst.', 'Neuteillackierung PTP1 - Multiple Choice 1 Lösung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (107, 'Audio\Neuteillackierung PTP1 - Multiple Choice 2.wav', 'Verändert sich dein Abstand zum Werkstück, wirkt sich das auch auf das Ergebnis deiner Lackierung aus. Was passiert, wenn du dich zu nah am Werkstück befindest?', 'Neuteillackierung PTP1 - Multiple Choice 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (108, 'Audio\Neuteillackierung PTP1 - Überleitung Lackieren.wav', 'Stehst du zu nah dran, müsstest du schneller lackieren, sonst verteilt sich mehr Farbe auf weniger Fläche, was zu Läufern und Verlaufsstörungen führen kann. Positioniere dich nun mit Hilfe des Distanzstrahls im idealen Abstand zum Werkstück und lackiere anschließend das gesamte Werkstück in einem deckenden Gang. Achte dabei besonders darauf, die ganze Zeit den idealen Abstand einzuhalten. Dabei wird dir der Distanzstrahl helfen. ', 'Neuteillackierung PTP1 - Überleitung Lackieren', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (109, 'Audio\Neuteillackierung PTP2 - Einleitung.wav', 'Dies ist die zweite von drei zusätzlichen Übungen in dieser Aufgabenklasse, in der du üben sollst, den idealen Abstand zum Werkstück während des Lackierens einzuhalten. Bedenke stets, dass der Abstand zum Karosserieteil und die Geschwindigkeit, in der du lackierst, aufeinander abgestimmt sein müssen.', 'Neuteillackierung PTP2 - Einleitung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (110, 'Audio\Neuteillackierung PTP2 - Überleitung Lackieren.wav', 'Positioniere dich nun mit Hilfe des Distanzstrahls im idealen Abstand zum Werkstück und lackiere anschließend das gesamte Werkstück in einem deckenden Gang. Achte dabei besonders darauf, die ganze Zeit den idealen Abstand einzuhalten. Zu Beginn wird dich der Distanzstrahl dabei unterstützen, den korrekten Abstand einzuhalten. Der Distanzstrahl wird aber mit der Zeit ausgeblendet. Dann bist du auf dich allein gestellt. Viel Erfolg!', 'Neuteillackierung PTP2 - Überleitung Lackieren', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (111, 'Audio\Neuteillackierung PTP2 - Wiederholung.wav', 'Ab der Hälfte der Fläche hast du keine Unterstützung mehr durch den Distanzstrahl bekommen. Schauen wir uns mal in der Wiederholung an, wie gut du den Abstand zum Lackieren einhalten konntest.', 'Neuteillackierung PTP2 - Wiederholung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (112, 'Audio\Neuteillackierung PTP2 - Abschluss.wav', 'Innerhalb dieser Aufgabenklasse erwartet dich noch eine weitere Gelegenheit, den idealen Abstand zum Werkstück zu üben.', 'Neuteillackierung PTP2 - Abschluss', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (113, 'Images\Verarbeitungsrichtlinien.png', 'Verarbeitungsrichtlinien', 'Verarbeitungsrichtlinien', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (114, 'Images\Tutorial Bild 1.png', 'Tutorial Bild 1', 'Tutorial Bild 1', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (115, 'Images\Tutorial Bild 2.png', 'Tutorial Bild 2', 'Tutorial Bild 2', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (116, 'Images\Tutorial Bild 3.png', 'Tutorial Bild 3', 'Tutorial Bild 3', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (117, 'Images\Tutorial - Monitor.png', 'Tutorial - Monitor', 'Tutorial - Monitor', 'Image', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (118, 'Audio\Tutorial - Lackierkabine.mp3', 'Das hier ist die virtuelle Lackierkabine. Schaue dich ruhig um und wähle anschließend die grüne Münze aus, um fortzufahren.', 'Tutorial - Lackierkabine', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (119, 'Audio\Tutorial - Münzen.mp3', 'In Lernaufgaben kannst du mit der grünen Münze zum nächsten Teilschritt gehen und mit der roten Münze zum vorherigen Teilschritt zurückkehren. Am Ende einer Lernaufgabe erscheint eine goldene Münze, mit der du die Aufgabe beendest.', 'Tutorial - Münzen', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (120, 'Audio\Tutorial - Ausbildungsmeister.mp3', 'Ich bin der virtuelle Ausbildungsmeister, der dich in vielen Aufgaben begleiten wird. Wenn du mit Lackierpistole auf mich zeigst und den Abzugshebel betätigst, wiederhole ich meine letzten Worte.', 'Tutorial - Ausbildungsmeister', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (121, 'Audio\Tutorial - Fortbewegung.mp3', 'Wenn du dich in der Lackierkabine bewegen willst, kannst du das auf zwei Arten tun. Du kannst dich durch Gehen fortbewegen, dich aber auch teleportieren. Zum Teleportieren zeigst du mit der Lackierpistole auf den Boden und hältst den Abzugshebel gedrückt. Dann kannst du die Zielposition bestimmen und teleportierst dich nach dem Loslassen des Abzugshebels dorthin. In manchen Teilschritten kannst du dich nur teleportieren, wenn du weit genug vom Werkstück oder dem Plakat für die Spritzprobe entfernt bist. Ob du dich teleportieren kannst, zeigt dir das Symbol auf dem Farbbehälter der Lackierpistole.', 'Tutorial - Fortbewegung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (122, 'Audio\Tutorial - Spritzprobe 1.mp3', 'Bei den Lernaufgaben, die du in der virtuellen Lackierwerkstatt bearbeitest, ist meistens bereits ein Werkstück auf den Lackierständer gespannt worden. Hier in der Kabine befindet sich außerdem ein Plakat für eine Spritzprobe. Führe nun eine Spritzprobe durch.
', 'Tutorial - Spritzprobe 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (123, 'Audio\Tutorial - Spritzprobe 2.mp3', 'Sehr gut! Fahre nun mit der grünen Münze fort.', 'Tutorial - Spritzprobe 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (124, 'Audio\Tutorial - Monitor 1.mp3', 'Den Monitor hast du bestimmt schon gesehen. Auf diesem kannst du am Anfang zwischen mehreren Lernaufgaben und zusätzlichen Übungseinheiten auswählen. Manche Aufgaben sind in einer Sammlung gruppiert. Der Buchstabe A steht für Lernaufgaben, der Buchstabe  Ü für eine kürze Übung und der Buchstabe U für unterstützende Informationen wie Bilder oder Videos. Erfolgreich abgeschlossene Aufgaben sind mit einer goldenen Münze markiert.
', 'Tutorial - Monitor 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (125, 'Audio\Tutorial - Monitor 2.mp3', 'Auf dem Monitor können dir außerdem wichtige Zusatzinformationen präsentiert werden. Hier siehst du z.B. mehrere Bilder, durch die du mit den Pfeilen darunter navigieren kannst.', 'Tutorial - Monitor 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (126, 'Audio\Tutorial - Multiple Choice 1.mp3', 'Manchmal sollst du Multiple-Choice-Aufgaben lösen. Dafür nimmst du eine Kugel aus der Kiste, indem du sie mit der Lackierpistole berührst, sodass eine Hand erscheint und dann hältst du den Abzugshebel gedrückt. Platziere die Kugel dann in einen der Ringe und sammle die grüne Münze ein, um die Lösung anzuzeigen.', 'Tutorial - Multiple Choice 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (127, 'Audio\Tutorial - Multiple Choice 2.mp3', 'Nun wird dir die korrekte Lösung angezeigt und du kannst die grüne Münze einsammeln, um fortzufahren.', 'Tutorial - Multiple Choice 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (128, 'Audio\Tutorial - Schätzaufgabe 1.mp3', 'Bei anderen Aufgaben musst du mit bestimmten Gegenständen interagieren. Stelle beim Thermometer die optimale Temperatur in der Lackierkabine ein. Berühre dafür das Thermometer mit der Lackierpistole, halte den Abzugshebel gedrückt und bewege die Lackierpistole nach oben oder unten. Fahre anschließend mit der grünen Münze fort.', 'Tutorial - Schätzaufgabe 1', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (129, 'Audio\Tutorial - Schätzaufgabe 2.mp3', 'Nun wird dir die korrekte Lösung angezeigt und du kannst die grüne Münze einsammeln, um fortzufahren.', 'Tutorial - Schätzaufgabe 2', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (130, 'Audio\Tutorial - Werkstück ausrichten.mp3', 'Bevor du mit dem Lackieren anfängst, solltest du darauf achten, dass das Werkstück optimal auf deine Größe und Bedürfnisse ausgerichtet ist. Die Ausrichtung des Werkstücks kannst du mit den Stangen an der Seite einstellen und die Höhe des Werkstücks kannst du mit den Stangen hinter dem Werkstück anpassen. Berühre dafür mit der Lackierpistole die Stange, sodass eine Hand erscheint und halte dann den Abzugshebel gedrückt. Durch Bewegungen mit der Lackierpistole kannst du den Lackierständer verstellen. ', 'Tutorial - Werkstück ausrichten', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (131, 'Audio\Tutorial - Werkstück lackieren.mp3', 'Manchmal erhälst du während der Applikation des Lacks zusätzliche Hilfe. Um dir zu zeigen, wie diese Hilfe ausschaut, richte die Lackierpistole auf das Werkstück. Dann siehst du den Distanzstrahl. Dieser hilft dir den idealen Abstand zum Werkstück einzuhalten. Bist du im roten Bereich, bist du zu nah dran. Bist du im blauen Bereich, bist du zu weit entfernt. Grün ist optimal. Manchmal kannst du Hilfestellungen auch selber über eine Auswahlmöglichkeit auf dem Monitor aktivieren oder deaktivieren. Lackiere nun das Werkstück.', 'Tutorial - Werkstück lackieren', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (132, 'Audio\Tutorial - Auswertung.mp3', 'Wenn du mit dem Lackieren fertig bist, hast du in der Regel die Möglichkeit dir deine Ergebnisse anzuschauen. Dazu wird die Schichtdicke auf dem Werkstück in Farben abgebildet. Blau ist zu dünn, rot zu dick, grün optimal. Wenn du durch die Lupe in deiner Hand schaust, kannst du den Farbauftrag mit der Schichtdicke auf dem Werkstück vergleichen. Auf dem Monitor kannst du dir außerdem weitere Erfolgskriterien anschauen. ', 'Tutorial - Auswertung', 'Audio', null);
INSERT INTO MEDIA (ID, DATA, DESCRIPTION, NAME, TYPE, PERMISSION_ID) VALUES (133, 'Audio\Tutorial - Selbsteinschätzung.mp3', 'Bei manchen Aufgaben sollst du deine Leistung selbst einschätzen. Packe dafür so viele goldene Lackierpistolen in den Korb, wie du für deine Leistung angemessen hälst. Beende dann die Aufgabe mit der goldenen Münze.', 'Tutorial - Selbsteinschätzung', 'Audio', null);


INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (1, 'Car Components/bumper', 'Stoßstange', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (2, 'Car Components/door', 'Tür', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (3, 'Car Components/fender', 'Kotflügel', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (4, 'Car Components/hood_1_big', 'Große Motorhaube', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (5, 'Car Components/hood_2', 'Motorhaube', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (6, 'Car Components/hood_3_small', 'Kleine Motorhaube', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (7, 'Car Components/roof', 'Dach', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (8, 'Car Components/side_panel', 'Seitenwand', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (9, 'Car Components/square', 'Viereck', null);
INSERT INTO WORKPIECE (ID, DATA, NAME, PERMISSION_ID) VALUES (10, 'Car Components/trunk', 'Heckklappe', null);


INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (1, '#FF7D00', 80.38999938964844, '2K HS Decklack Orange', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 90.68000030517578, 93, '3/1', 20, 15, '2K HS Decklack Orange', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Topcoat', 22.5, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (2, '#0000AA', 80.38999938964844, '2K HS Decklack Blau', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 90.68000030517578, 93, '3/1', 20, 15, '2K HS Decklack Blau', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Topcoat', 35, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (3, '#FF0000', 80.38999938964844, '2K HS Decklack Rot', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 90.68000030517578, 93, '3/1', 20, 15, '2K HS Decklack Rot', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Topcoat', 22.5, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (4, '#FFFFFF', 80.38999938964844, '2K VOC Klarlack', 20, 960, 'Lufttrocknung', 50, 86.19000244140625, 50, 86.19000244140625, 90.68000030517578, 93, '3/1', 20, 15, '2K VOC Klarlack', 50, 105.80999755859375, 58.0099983215332, 60, 96.19000244140625, 50, 86.19000244140625, 12.5, 'Clearcoat', 22.5, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (5, '#C3C3C3', 80.38999938964844, 'Brillantsilber', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 46.5, 93, '3/1', 20, 15, 'Brillantsilber', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Basecoat', 22.5, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (6, '#000046', 80.38999938964844, 'Canvasitblau Metallic', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 46.5, 93, '3/1', 20, 15, 'Canvasitblau Metallic', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Basecoat', 22.5, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (7, '#000000', 80.38999938964844, 'Obsidanschwar Metallic', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 46.5, 93, '3/1', 20, 15, 'Obsidanschwarz Metallic', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Basecoat', 22.5, null);
INSERT INTO COAT (ID, COLOR, COSTS, DESCRIPTION, DRYING_TEMPERATURE, DRYING_TIME, DRYING_TYPE, FULL_GLOSS_MIN_THICKNESS_DRY, FULL_GLOSS_MIN_THICKNESS_WET, FULL_OPACITY_MIN_THICKNESS_DRY, FULL_OPACITY_MIN_THICKNESS_WET, GLOSS_DRY, GLOSS_WET, HARDENER_MIX_RATIO, MAX_SPRAY_DISTANCE, MIN_SPRAY_DISTANCE, NAME, ROUGHNESS, RUNS_START_THICKNESS_WET, SOLID_VOLUME, TARGET_MAX_THICKNESS_DRY, TARGET_MAX_THICKNESS_WET, TARGET_MIN_THICKNESS_DRY, TARGET_MIN_THICKNESS_WET, THINNER_PERCENTAGE, TYPE, VISCOSITY, PERMISSION_ID) VALUES (8, '#555555', 80.38999938964844, 'Tenoritgrau Metallic', 20, 960, 'Lufttrocknung', 40, 68.94999694824219, 40, 68.94999694824219, 46.5, 93, '3/1', 20, 15, 'Tenoritgrau Metallic', 50, 119.8499984741211, 58.0099983215332, 80, 108.94999694824219, 40, 68.94999694824219, 12.5, 'Basecoat', 22.5, null);


INSERT INTO RECORDING (ID, DATA, DATE, DESCRIPTION, HASH, NAME, NEEDED_TIME, BASE_COAT_ID, COAT_ID, PERMISSION_ID, TASK_RESULT_ID, WORKPIECE_ID) VALUES (1, 'Einschichtlackierung Tür Umgekehrt', '2021-08-24 13:12:07.566000', 'Einschichtlackierung Tür Umgekehrt', '761615855d397fdfdc0a61b2deaa05d7daaceb9ee27d6b40e83484bdd272be2a', 'Einschichtlackierung Tür Umgekehrt', 70.16683959960938, null, 3, null, null, 2);
INSERT INTO RECORDING (ID, DATA, DATE, DESCRIPTION, HASH, NAME, NEEDED_TIME, BASE_COAT_ID, COAT_ID, PERMISSION_ID, TASK_RESULT_ID, WORKPIECE_ID) VALUES (2, 'Neuteillackierung Kotflügel Basislack', '2021-10-25 15:15:07.678000', 'Neuteillackierung Kotflügel Basislack', 'b5188e5d54114bd530111d8d3f6a546c3a6c472458b3fd6c7b9621d3d97a0f63', 'Neuteillackierung Kotflügel Basislack', 99.28473, null, 1, null, null, 3);
INSERT INTO RECORDING (ID, DATA, DATE, DESCRIPTION, HASH, NAME, NEEDED_TIME, BASE_COAT_ID, COAT_ID, PERMISSION_ID, TASK_RESULT_ID, WORKPIECE_ID) VALUES (3, 'Neuteillackierung Motorhaube Basislack', '2021-10-25 15:26:46.688000', 'Neuteillackierung Motorhaube Basislack', '93229378d41f5de65b22672b2061fbbf84f7670ef27ab838ded34ac2199a6134', 'Neuteillackierung Motorhaube Basislack', 214.159454, null, 7, null, null, 5);
INSERT INTO RECORDING (ID, DATA, DATE, DESCRIPTION, HASH, NAME, NEEDED_TIME, BASE_COAT_ID, COAT_ID, PERMISSION_ID, TASK_RESULT_ID, WORKPIECE_ID) VALUES (4, 'Neuteillackierung Motorhaube Klarlack', '2021-10-25 15:42:40.329000', 'Neuteillackierung Motorhaube Klarlack', '08f0710120b058f81886a80a167b622f6c4b564256db93d07cb62f4dfb09c32e', 'Neuteillackierung Motorhaube Klarlack', 159.464478, 7, 4, null, null, 5);


INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (3, 'Eine Tür soll lackiert werden.', 'Einschichtlackierung Tür (Evaluation)', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"recording\",\r\n  \"recordingId\": 1\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 93,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 94,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welche Ursachen gibt es für Läufer? \",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 95,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 3,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"zu wenig Verdünner\",\r\n    \"zu schnelle Applikation\",\r\n    \"Ablüftzeiten zu kurz\",\r\n    \"zu geringe Distanz zum Werkstück\",\r\n    \"zu hohe Kabinentemperatur \",\r\n    \"Werkstück und/oder Lack zu kalt\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    false,\r\n    true,\r\n    true,\r\n    false,\r\n    true\r\n  ]\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"minimum\": \"20\",\r\n  \"maximum\": \"25\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"thermometer\",\r\n  \"audioId\": 96,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": 86\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 87\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 88\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 89\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 90\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 91\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 92\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 97,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 2,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 98,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"ghostPistol\": false,\r\n  \"finalAudioId\": 99,\r\n  \"skippable\": 0,\r\n  \"coatId\": 3,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"ghostPistol\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionGhostPistol\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"0\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 3,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 100,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Selbsteinschätzung","description":"","type":"Self Assessment","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 101,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (4, 'Einschichtlackierung Tür Umgekehrt', 'Einschichtlackierung Tür Umgekehrt', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"recording\",\r\n  \"recordingId\": 1\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"75\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"76\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welche Ursachen gibt es für Läufer?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"78\",\r\n  \"audioId\": \"77\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 3,\r\n  \"minAnswers\": 3,\r\n  \"answersText\": [\r\n    \"zu wenig Verdünner\",\r\n    \"zu schnelle Applikation \",\r\n    \"Ablüftzeiten zu kurz \",\r\n    \"zu geringe Distanz zum Werkstück\",\r\n    \"zu hohe Kabinentemperatur\",\r\n    \"Werkstück und/oder Lack zu kalt\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    false,\r\n    true,\r\n    true,\r\n    false,\r\n    true\r\n  ]\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Was ist die ideale Lackiertemperatur?\",\r\n  \"minimum\": \"20\",\r\n  \"maximum\": \"25\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"thermometer\",\r\n  \"audioId\": \"79\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"86\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"87\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"88\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"89\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"90\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"91\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"92\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"80\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"1. Lackviskosität zu hoch\\r\\n2. Einsatz von kurzer, schnellflüchtiger Verdünnung\\r\\n3. falsche Düsengröße\\r\\n4. Spritzpistolenabstand zu groß\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 81,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 82,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 2,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"84\",\r\n  \"coatId\": 3,\r\n  \"audioId\": \"83\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 3,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einer Autotür aus Aluminium?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 85,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"Messgerät nach dem Wirbelstromverfahren\",\r\n    \"Magnetinduktives Schichtdickenmessgerät\",\r\n    \"Anemometer \",\r\n    \"Ionisier-Messgerät\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (11, 'Übung für den richtigen Abstand.', 'Übung 1 (Evaluation)', true, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 9,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was ist der ideale Abstand zum Werkstück?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": 103,\r\n  \"audioId\": 102,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"5-10 cm\",\r\n    \"15-20 cm\",\r\n    \"25-30 cm\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"ghostPistol\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionGhostPistol\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"0\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 9,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 1,\r\n  \"audioId\": 104,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (12, 'Zweischichtlackierung Motorhaube Imitation', 'Zweischichtlackierung Motorhaube Imitation', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 5,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Gegenstände sortieren","description":"","type":"Sorting","properties":"{\r\n  \"textMonitor\": \"Lege alle Bestandteile, die du für eine Zweischichtlackierung benötigst, in den Korb.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"21\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"items\": [\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Basislack\",\r\n      \"correct\": true\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"2K-Klarlack\",\r\n      \"correct\": true\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"2K-Decklack\",\r\n      \"correct\": false\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Grundierfüller\",\r\n      \"correct\": false\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Nass-in-Nass-Füller\",\r\n      \"correct\": false\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Primer\",\r\n      \"correct\": false\r\n    }\r\n  ]\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"22\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"38\\\",\\r\\n      \\\"audioId\\\": \\\"54\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"39\\\",\\r\\n      \\\"audioId\\\": \\\"55\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"40\\\",\\r\\n      \\\"audioId\\\": \\\"56\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"41\\\",\\r\\n      \\\"audioId\\\": \\\"57\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"42\\\",\\r\\n      \\\"audioId\\\": \\\"58\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"43\\\",\\r\\n      \\\"audioId\\\": \\\"59\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"44\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Lack auswählen","description":"In welcher Farbe soll die Motorhaube lackiert werden?","type":"Coat Selection","properties":"{\r\n  \"textMonitor\": \"In welcher Farbe soll die Motorhaube lackiert werden?\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 23,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"items\": [\r\n    {\r\n      \"coatId\": 5\r\n    },\r\n    {\r\n      \"coatId\": 6\r\n    },\r\n    {\r\n      \"coatId\": 7\r\n    },\r\n    {\r\n      \"coatId\": 8\r\n    }\r\n  ]\r\n}"},{"name":"Vorführung Farbauftrag","description":"","type":"Demonstration","properties":"{\r\n  \"textMonitor\": \"Sieh beim Farbauftrag zu.\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"recordingId\": 3,\r\n  \"baseCoatId\": -2,\r\n  \"coatId\": -1,\r\n  \"audioId\": \"24\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"skippable\": 0\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Verarbeitungsrichtlinien:\\r\\n- Mischverhältnis zwischen Lack, Härter und Verdünner\\r\\n- optimaler Spritzdruck\\r\\n- Anzahl der Spritzgänge\\r\\n- usw.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"26\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"Öffne die Verarbeitungsrichtlinien.\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Verarbeitungsrichtlinien\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"113\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": false,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"27\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Wie lange muss der Basislack ablüften bzw. trocknen? \",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"8-12 Minuten bei 20°C\",\r\n    \"20-25 Minuten bei 20°C\",\r\n    \"8-12 Minuten bei 25°C\",\r\n    \"20-25 Minuten bei 25°C\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    true,\r\n    false,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 5,\r\n  \"coatId\": -1,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Vorführung Farbauftrag","description":"","type":"Demonstration","properties":"{\r\n  \"textMonitor\": \"Sieh beim Farbauftrag zu.\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"recordingId\": 4,\r\n  \"baseCoatId\": -1,\r\n  \"coatId\": -2,\r\n  \"audioId\": \"28\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"skippable\": 0\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Gütekriterien\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Quality Criteria\",\r\n      \"properties\": \"{\\r\\n  \\\"sequential\\\": true\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 29,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 5,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"31\",\r\n  \"coatId\": -1,\r\n  \"audioId\": \"30\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"45\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"46\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"47\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"48\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"49\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"50\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"51\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"52\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"53\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"32\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"15\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 5,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": -1,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 33,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (14, 'Einschichtlackierung Kotflügel Fallstudie', 'Einschichtlackierung Kotflügel Fallstudie', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 3,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"60\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"61\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was bedeuten die Schutzklassen 1-6 bei Schutzhandschuhen?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"63\",\r\n  \"audioId\": \"62\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"Risiken durch Mikroorganismen\",\r\n    \"Eingeschränkter Schutz vor Chemikalien\",\r\n    \"Antistatische Eigenschaften\",\r\n    \"Chemikalienfestigkeit\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"64\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Wie lange sollte eine Füllerschicht, die mit einem 2-Komponenten Nass-in-Nass Grundierfüller appliziert wurde, bei 60 bis 65 Grad im Ofen trocknen?\",\r\n  \"minimum\": \"42\",\r\n  \"maximum\": \"48\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"clock\",\r\n  \"finalAudioId\": \"66\",\r\n  \"audioId\": \"65\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Wie viel Lack benötigst du für die Lackierung eines Kotflügels?\",\r\n  \"minimum\": \"275\",\r\n  \"maximum\": \"325\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"beaker\",\r\n  \"audioId\": \"67\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Vorführung Farbauftrag","description":"","type":"Demonstration","properties":"{\r\n  \"textMonitor\": \"Schaue dir den Farbauftrag an.\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"recordingId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 6,\r\n  \"audioId\": \"68\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"skippable\": 0\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Wie lange muss der Unilack bei Infrarotstrahler-Trocknung maximal trocknen?\",\r\n  \"minimum\": \"9\",\r\n  \"maximum\": \"15\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"clock\",\r\n  \"audioId\": \"69\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 3,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"71\",\r\n  \"coatId\": 6,\r\n  \"audioId\": \"70\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 3,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 6,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einem Werkstück aus Stahl?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"72\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"Schichtdickenmessrad\",\r\n    \"Messgerät nach dem magnetinduktiven Messverfahren\",\r\n    \"Schichtdickenmessuhr\",\r\n    \"Messgerät nach dem Wirbelstromverfahren\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"73\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (15, 'Eine Übung, in der ein simples Viereck lackiert werden soll. Dabei soll insbesondere auf die Distanz zum Werkstück geachtet werden. Der Distanzstrahl ist dabei während der kompletten Übung sichtbar.', 'Übung Neuteillackierung 1', true, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 9,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was ist nochmal der ideale Abstand zum Werkstück?\",\r\n  \"shuffle\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"106\",\r\n  \"audioId\": \"105\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"5-10 cm\",\r\n    \"15-20 cm\",\r\n    \"25-30 cm\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was passiert, wenn du dich zu nah am Werkstück befindest?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"107\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 2,\r\n  \"minAnswers\": 2,\r\n  \"answersText\": [\r\n    \"Läufer und Verlaufsstörungen können entstehen\",\r\n    \"Du musst langsamer lackieren\",\r\n    \"Du musst schneller lackieren\",\r\n    \"Orangenhaut entsteht eher\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    true,\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 9,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 1,\r\n  \"audioId\": \"108\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (16, 'Eine Übung, in der ein simples Viereck lackiert werden soll. Dabei soll insbesondere auf die Distanz zum Werkstück geachtet werden. Der Distanzstrahl ist sichtbar, wird aber nach einigen Sekunden ausgeblendet.', 'Übung Neuteillackierung 2', true, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 9,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"idealer Abstand zum Werkstück: 15 - 20 cm \",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"109\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"20\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 9,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 1,\r\n  \"audioId\": \"110\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"112\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);
INSERT INTO TASK (ID, DESCRIPTION, NAME, PART_TASK_PRACTICE, SUB_TASKS, TASK_CLASS, VALUES_MISSING, PERMISSION_ID) VALUES (17, 'Eine Einführung in die Nutzung von der VR-Lackierwerkstatt.', 'Tutorial', false, '[{"name":"Werkstück zurücksetzen","description":null,"type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 2,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Die Lackierkabine\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"118\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Die Münzen\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"119\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Der Ausbildungsmeister\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"120\",\r\n  \"textSpeechBubble\": \"Hallo!\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Fortbewegung in der Lackierkabine\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"121\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Spritzprobe","description":null,"type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Die Spritzprobe\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"123\",\r\n  \"coatId\": \"1\",\r\n  \"audioId\": \"122\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":null,"type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"117\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"124\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":null,"type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"114\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"115\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"116\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"125\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":null,"type":"Question","properties":"{\r\n  \"question\": \"Mit welcher Münze kannst du zum nächsten Teilschritt wechseln?\",\r\n  \"shuffle\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"127\",\r\n  \"audioId\": \"126\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 3,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"rote Münze\",\r\n    \"grüne Münze\",\r\n    \"goldene Münze\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Schätzaufgabe","description":null,"type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Was ist die optimale Temperatur in der Lackierkabine?\",\r\n  \"minimum\": \"19\",\r\n  \"maximum\": \"23\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"thermometer\",\r\n  \"finalAudioId\": \"129\",\r\n  \"audioId\": \"128\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":null,"type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackierständer einstellen\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"0\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": \"1\",\r\n  \"audioId\": \"130\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":null,"type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Hilfestellungen beim Lackieren\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": true,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": \"1\",\r\n  \"audioId\": \"131\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Auswertung","description":null,"type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"132\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Selbsteinschätzung","description":null,"type":"Self Assessment","properties":"{\r\n  \"textMonitor\": \"Eigene Leistung bewerten\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"133\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);


INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (3, 3);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (4, 3);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (11, 1);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (12, 5);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (12, 6);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (12, 7);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (12, 8);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (14, 6);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (15, 1);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (16, 1);
INSERT INTO TASK_USED_COATS (USED_IN_TASKS_ID, USED_COATS_ID) VALUES (17, 1);


INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 86);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 87);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 88);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 89);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 90);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 91);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 92);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 93);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 94);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 95);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 96);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 97);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 98);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 99);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 100);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (3, 101);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 75);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 76);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 77);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 78);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 79);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 80);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 81);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 82);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 83);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 84);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 85);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 86);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 87);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 88);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 89);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 90);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 91);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (4, 92);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (11, 102);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (11, 103);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (11, 104);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 21);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 22);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 23);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 24);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 26);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 27);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 28);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 29);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 30);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 31);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 32);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 33);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 38);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 39);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 40);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 41);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 42);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 43);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 44);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 45);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 46);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 47);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 48);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 49);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 50);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 51);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 52);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 53);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 54);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 55);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 56);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 57);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 58);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 59);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (12, 113);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 60);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 61);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 62);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 63);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 64);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 65);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 66);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 67);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 68);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 69);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 70);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 71);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 72);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (14, 73);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (15, 105);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (15, 106);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (15, 107);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (15, 108);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (16, 109);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (16, 110);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (16, 112);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 114);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 115);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 116);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 117);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 118);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 119);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 120);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 121);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 122);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 123);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 124);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 125);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 126);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 127);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 128);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 129);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 130);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 131);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 132);
INSERT INTO TASK_USED_MEDIA (USED_IN_TASKS_ID, USED_MEDIA_ID) VALUES (17, 133);


INSERT INTO TASK_USED_RECORDINGS (USED_IN_TASKS_ID, USED_RECORDINGS_ID) VALUES (3, 1);
INSERT INTO TASK_USED_RECORDINGS (USED_IN_TASKS_ID, USED_RECORDINGS_ID) VALUES (4, 1);
INSERT INTO TASK_USED_RECORDINGS (USED_IN_TASKS_ID, USED_RECORDINGS_ID) VALUES (12, 3);
INSERT INTO TASK_USED_RECORDINGS (USED_IN_TASKS_ID, USED_RECORDINGS_ID) VALUES (12, 4);
INSERT INTO TASK_USED_RECORDINGS (USED_IN_TASKS_ID, USED_RECORDINGS_ID) VALUES (14, 2);


INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (3, 2);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (4, 2);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (11, 9);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (12, 5);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (14, 3);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (15, 9);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (16, 9);
INSERT INTO TASK_USED_WORKPIECES (USED_IN_TASKS_ID, USED_WORKPIECES_ID) VALUES (17, 2);


INSERT INTO TASK_COLLECTION (ID, DESCRIPTION, NAME, TASK_CLASS, PERMISSION_ID) VALUES (2, 'Lernpfad der Aufgabenklasse Neuteillackierung', 'Neuteillackierung I', 'NewPartPainting', null);


INSERT INTO TASK_COLLECTION_ELEMENT (ID, IDX, MANDATORY, TASK_ID, TASK_COLLECTION_ID) VALUES (3, 1, true, 14, 2);
INSERT INTO TASK_COLLECTION_ELEMENT (ID, IDX, MANDATORY, TASK_ID, TASK_COLLECTION_ID) VALUES (4, 2, true, 15, 2);
INSERT INTO TASK_COLLECTION_ELEMENT (ID, IDX, MANDATORY, TASK_ID, TASK_COLLECTION_ID) VALUES (5, 3, true, 4, 2);
INSERT INTO TASK_COLLECTION_ELEMENT (ID, IDX, MANDATORY, TASK_ID, TASK_COLLECTION_ID) VALUES (6, 4, true, 16, 2);
INSERT INTO TASK_COLLECTION_ELEMENT (ID, IDX, MANDATORY, TASK_ID, TASK_COLLECTION_ID) VALUES (7, 5, true, 12, 2);