create table "user"
(
    id               bigserial primary key,
    full_name        varchar(255),
    pwd              varchar(255),
    password_changed boolean not null,
    role             varchar(255),
    user_name        varchar(255)
);

create table permission
(
    id        bigserial primary key,
    editable  boolean not null,
    visible   boolean not null,
    author_id bigint,
    constraint fkpbocwfs1fpuuc2ec2mhr77hu7
        foreign key (author_id) references "user"
);

create table coat
(
    id                             bigserial primary key,
    color                          varchar(255),
    costs                          real    not null,
    description                    text,
    drying_temperature             real    not null,
    drying_time                    integer not null,
    drying_type                    varchar(255),
    full_gloss_min_thickness_dry   real    not null,
    full_gloss_min_thickness_wet   real    not null,
    full_opacity_min_thickness_dry real    not null,
    full_opacity_min_thickness_wet real    not null,
    gloss_dry                      real    not null,
    gloss_wet                      real    not null,
    hardener_mix_ratio             varchar(255),
    max_spray_distance             real    not null,
    min_spray_distance             real    not null,
    name                           varchar(255),
    roughness                      real    not null,
    runs_start_thickness_wet       real    not null,
    solid_volume                   real    not null,
    target_max_thickness_dry       real    not null,
    target_max_thickness_wet       real    not null,
    target_min_thickness_dry       real    not null,
    target_min_thickness_wet       real    not null,
    thinner_percentage             real    not null,
    type                           varchar(255),
    viscosity                      real    not null,
    permission_id                  bigint,
    constraint fkb42gfxrfw76f1o12c1iqq2f8a
        foreign key (permission_id) references permission
);

create table media
(
    id            bigserial primary key,
    data          text,
    description   text,
    name          varchar(255),
    type          varchar(255),
    permission_id bigint,
    constraint fkryma152gjmy0yaw8ded9l4ych
        foreign key (permission_id) references permission
);

create table task
(
    id                 bigserial primary key,
    description        text,
    name               varchar(255),
    part_task_practice boolean not null,
    sub_tasks          text,
    task_class         varchar(255),
    values_missing     boolean not null,
    permission_id      bigint,
    constraint fkeg9mdms7tdiba0uqhj2k5k7go
        foreign key (permission_id) references permission
);

create table task_used_coats
(
    used_in_tasks_id bigint not null,
    used_coats_id    bigint not null,
    constraint task_used_coats_pkey
        primary key (used_in_tasks_id, used_coats_id),
    constraint fkkd48alhinug33scpoq4kcwspx
        foreign key (used_coats_id) references coat,
    constraint fkmaa9dm3hdsc33pxj3lvookcd7
        foreign key (used_in_tasks_id) references task
);

create table task_used_media
(
    used_in_tasks_id bigint not null,
    used_media_id    bigint not null,
    constraint task_used_media_pkey
        primary key (used_in_tasks_id, used_media_id),
    constraint fkjad0ov20uqrwghrltjnjh5g24
        foreign key (used_media_id) references media,
    constraint fk30vry9lv4cr7a0olcsigxj98y
        foreign key (used_in_tasks_id) references task
);

create table task_collection
(
    id            bigserial primary key,
    description   text,
    name          varchar(255),
    task_class    varchar(255),
    permission_id bigint,
    constraint fk4iw4u1026lvkk2wkjvpwd1uvn
        foreign key (permission_id) references permission
);

create table task_collection_element
(
    id                 bigserial primary key,
    idx                integer,
    mandatory          boolean not null,
    task_id            bigint,
    task_collection_id bigint,
    constraint fk6m9osnnkoktsj0bge6ofldhm1
        foreign key (task_id) references task
            on delete cascade,
    constraint fkb3aomauljxkcgqextfrqe55kk
        foreign key (task_collection_id) references task_collection
);

create table user_group
(
    id   bigserial primary key,
    name varchar(255)
);

create table user_group_users
(
    user_groups_id bigint not null,
    users_id       bigint not null,
    constraint fk2nxn2lrsvhe42swjqobmn77fk
        foreign key (users_id) references "user",
    constraint fk5jwwkg2tfsqh9f7c090mi1pm7
        foreign key (user_groups_id) references user_group
);

create table user_group_task_assignment
(
    id                 bigserial primary key,
    deadline           timestamp,
    task_id            bigint,
    task_collection_id bigint,
    user_group_id      bigint,
    constraint fk9y9naceqnb283j84338qc7m1a
        foreign key (task_id) references task,
    constraint fk6vqjhuw9dqp4utgmac5p5rj3p
        foreign key (task_collection_id) references task_collection,
    constraint fk4y61jkxmkluylnbgc1tf1dclr
        foreign key (user_group_id) references user_group
);

create table task_collection_assignment
(
    id                            bigserial primary key,
    deadline                      timestamp,
    task_collection_id            bigint,
    user_id                       bigint,
    user_group_task_assignment_id bigint,
    constraint fkme3anpmmqg0biybe5g20cfwak
        foreign key (task_collection_id) references task_collection,
    constraint fkfjadwjxmucufucnhvwpdw3yfs
        foreign key (user_id) references "user",
    constraint fksyahqjekrq5u31xl2ltwb3egd
        foreign key (user_group_task_assignment_id) references user_group_task_assignment
);

create table task_assignment
(
    id                            bigserial primary key,
    deadline                      timestamp,
    task_id                       bigint,
    task_collection_assignment_id bigint,
    user_id                       bigint,
    user_group_task_assignment_id bigint,
    constraint fkjec38nl7lfmlgdn036w0h3hbt
        foreign key (task_id) references task,
    constraint fk3a6b9l4yws7cous67xfcf0g5h
        foreign key (task_collection_assignment_id) references task_collection_assignment,
    constraint fkbiboax1avmn0wvhg1cbxs8qds
        foreign key (user_id) references "user",
    constraint fkaidrkviiqea4k3wn2e0wuoo4i
        foreign key (user_group_task_assignment_id) references user_group_task_assignment
);

create table workpiece
(
    id            bigserial primary key,
    data          text,
    name          varchar(255),
    permission_id bigint,
    constraint fkj0238wqqyi652h18dwyg1i5e5
        foreign key (permission_id) references permission
);

create table recording
(
    id             bigserial primary key,
    data           text,
    date           timestamp,
    description    text,
    hash           varchar(255),
    name           varchar(255),
    needed_time    real not null,
    base_coat_id   bigint,
    coat_id        bigint,
    permission_id  bigint,
    task_result_id bigint,
    workpiece_id   bigint,
    constraint fk3c1lphfg9ax7iug5x5yrn1n6l
        foreign key (base_coat_id) references coat,
    constraint fk2dd59qk6sbf14vjv5bte4i1br
        foreign key (coat_id) references coat,
    constraint fksr72erwi953pxh664v942cmho
        foreign key (permission_id) references permission,
    constraint fkliepadq9p2wr2cxnfb4k7j1fc
        foreign key (workpiece_id) references workpiece
);

create table task_used_recordings
(
    used_in_tasks_id   bigint not null,
    used_recordings_id bigint not null,
    constraint task_used_recordings_pkey
        primary key (used_in_tasks_id, used_recordings_id),
    constraint fkcw4yvgh9yugcc9pqc6917kmb3
        foreign key (used_recordings_id) references recording,
    constraint fkhuowh9rsj7etjt2w3y8nismfl
        foreign key (used_in_tasks_id) references task
);

create table task_used_workpieces
(
    used_in_tasks_id   bigint not null,
    used_workpieces_id bigint not null,
    constraint task_used_workpieces_pkey
        primary key (used_in_tasks_id, used_workpieces_id),
    constraint fke358rub9vd276po8m0sc8l61p
        foreign key (used_workpieces_id) references workpiece,
    constraint fk7moq04kjsma025ua6fy5epfcj
        foreign key (used_in_tasks_id) references task
);

create table task_result
(
    id                 bigserial primary key,
    recording_id       bigint not null,
    task_assignment_id bigint not null,
    constraint uk_y0uu7gfwaui59c8xkaglpvjo
        unique (recording_id),
    constraint fkclvh47c6ld6fyr6ge6559v3ql
        foreign key (recording_id) references recording
            on delete cascade,
    constraint fkk472c3gau6wv8wk035eucm6uj
        foreign key (task_assignment_id) references task_assignment
);

alter table recording
    add constraint fk5o7bw0bbxwm7svbril4k9bnjd
        foreign key (task_result_id) references task_result;



INSERT INTO "user" VALUES (1, 'Ausbildungsmeister', '$2a$10$gPYSkOveyRMbxgSvyhmq1e/SbMQjo.0rbZ0srSKdS7uWU/mvCoYwq', false, 'Teacher', 'Ausbildungsmeister');
ALTER SEQUENCE user_id_seq RESTART WITH 2;


INSERT INTO coat VALUES (1, '#FF7D00', 80.39, '2K HS Decklack Orange', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 90.68, 93, '3/1', 20, 15, '2K HS Decklack Orange', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Topcoat', 22.5, NULL);
INSERT INTO coat VALUES (2, '#0000AA', 80.39, '2K HS Decklack Blau', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 90.68, 93, '3/1', 20, 15, '2K HS Decklack Blau', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Topcoat', 35, NULL);
INSERT INTO coat VALUES (3, '#FF0000', 80.39, '2K HS Decklack Rot', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 90.68, 93, '3/1', 20, 15, '2K HS Decklack Rot', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Topcoat', 22.5, NULL);
INSERT INTO coat VALUES (4, '#FFFFFF', 80.39, '2K VOC Klarlack', 20, 960, 'Lufttrocknung', 50, 86.19, 50, 86.19, 90.68, 93, '3/1', 20, 15, '2K VOC Klarlack', 50, 105.81, 58.01, 60, 96.19, 50, 86.19, 12.5, 'Clearcoat', 22.5, NULL);
INSERT INTO coat VALUES (5, '#C3C3C3', 80.39, 'Brillantsilber', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 46.5, 93, '3/1', 20, 15, 'Brillantsilber', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Basecoat', 22.5, NULL);
INSERT INTO coat VALUES (6, '#000046', 80.39, 'Canvasitblau Metallic', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 46.5, 93, '3/1', 20, 15, 'Canvasitblau Metallic', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Basecoat', 22.5, NULL);
INSERT INTO coat VALUES (7, '#000000', 80.39, 'Obsidanschwar Metallic', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 46.5, 93, '3/1', 20, 15, 'Obsidanschwarz Metallic', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Basecoat', 22.5, NULL);
INSERT INTO coat VALUES (8, '#555555', 80.39, 'Tenoritgrau Metallic', 20, 960, 'Lufttrocknung', 40, 68.95, 40, 68.95, 46.5, 93, '3/1', 20, 15, 'Tenoritgrau Metallic', 50, 119.85, 58.01, 80, 108.95, 40, 68.95, 12.5, 'Basecoat', 22.5, NULL);
ALTER SEQUENCE coat_id_seq RESTART WITH 9;


INSERT INTO media VALUES (1, 'Audio\Begrüßung (Selbstgesteuerte Lernaufgabe).wav', 'Ausbildungsmeister spricht folgenden Text: Hallo. Dein heutiger Kundenauftrag lautet, eine Tür mit einer Einschichtlackierung in rot zu lackieren. Dabei sollst du heute besonders auf den optimalen Abstand zum Werkstück beim Lackieren achten. Hierfür bekommst du eine visuelle Hilfe, die dir den idealen Abstand zum Werkstück anzeigt: die „Abstandshilfe“. Diese erscheint, wenn die Lackierpistole auf das Werkstück zeigt. Du hast bereits gemäß des Arbeitsfolgeplanes das Werkstück instandgesetzt, eine optische Prüfung des Werkstücks durchgeführt, deine PSA angelegt und den benötigten Lack angemischt. Möchtest du dir nun unterstützende Informationen anschauen? Ansonsten mache eine Spritzprobe und beginne anschließend mit dem Lackieren!.', 'Begrüßung (Selbstgesteuerte Lernaufgabe)', 'Audio', NULL);
INSERT INTO media VALUES (2, 'Videos\Härter und Verdünner.mp4', 'Ein Video in dem die richtige Anwendung von Härtern und Verdünnern erklärt wird.', 'Härter und Verdünner', 'Video', NULL);
INSERT INTO media VALUES (3, 'Audio\Spritzprobe durchführen.mp3', 'Der Ausbildungsmeister weist darauf hin, dass nun eine Spritzprobe durchgeführt werden soll.', 'Spritzprobe durchführen', 'Audio', NULL);
INSERT INTO media VALUES (4, 'Audio\Erklärung Distanzstrahl.wav', 'Der Ausbildungsmeister erklärt den Distanzstrahl.', 'Erklärung Distanzstrahl', 'Audio', NULL);
INSERT INTO media VALUES (5, 'Audio\Was bedeuten die Farben.ogg', 'Der Ausbildungsmeister erklärt die Heatmap.', 'Was bedeuten die Farben', 'Audio', NULL);
INSERT INTO media VALUES (6, 'Audio\Erklärung Übung mit Distanzstrahl.mp3', 'Der Ausbildungsmeister führt in die Aufgabe ein und erklärt den Distanzstrahl.', 'Erklärung Übung mit Distanzstrahl', 'Audio', NULL);
INSERT INTO media VALUES (9, 'Images\Läufer.png', 'Ein Bild von einem Läufer.', 'Läufer', 'Image', NULL);
INSERT INTO media VALUES (10, 'Images\Mager.png', 'Ein Bild von einem Bereich in dem die Farbe mager ist.', 'Mager', 'Image', NULL);
INSERT INTO media VALUES (11, 'Images\Tropfen.png', 'Ein Bild von einem Tropfen.', 'Tropfen', 'Image', NULL);
INSERT INTO media VALUES (12, 'Audio\Begrüßung (Fremdgesteuerte Lernaufgabe).wav', 'Ausbildungsmeister spricht folgenden Text: Hallo. Dein heutiger Kundenauftrag lautet, eine Motorhaube mit einer Einschicht Unilackierung in rot zu lackieren. Dabei sollst du heute besonders auf den optimalen Abstand zum Werkstück beim Lackieren achten. Hierfür bekommst du eine visuelle Hilfe, die dir den idealen Abstand zum Werkstück anzeigt: die „Abstandshilfe“. Diese erscheint, wenn die Lackierpistole auf das Werkstück zeigt. Du hast bereits gemäß des Arbeitsfolgeplanes das Werkstück instandgesetzt, eine optische Prüfung des Werkstücks durchgeführt, deine PSA angelegt und den benötigten Lack angemischt. Informiere dich nun zu relevanten Themen bei dieser Lernaufgabe.', 'Begrüßung (Fremdgesteuerte Lernaufgabe)', 'Audio', NULL);
INSERT INTO media VALUES (13, 'Audio\Erinnerung (Fremdgesteuerte Lernaufgabe).wav', 'Informiere dich zu allen Themenbereichen und beginne im Anschluss mit der Spritzprobe.', 'Erinnerung (Fremdgesteuerte Lernaufgabe)', 'Audio', NULL);
INSERT INTO media VALUES (14, 'Audio\Erinnerung (Selbstgesteuerte Lernaufgabe).wav', 'Informiere dich zu relevanten Themenbereichen oder beginne mit der Spritzprobe.', 'Erinnerung (Selbstgesteuerte Lernaufgabe)', 'Audio', NULL);
INSERT INTO media VALUES (15, 'Audio\Erklärung Geisterpistole.wav', 'Der Ausbildungsmeister erklärt die Geisterpistole.', 'Erklärung Geisterpistole', 'Audio', NULL);
INSERT INTO media VALUES (16, 'Audio\Erklärung Übung mit Geisterpistole.wav', 'Der Ausbildungsmeister führt in die Übung ein und erklärt die Geisterpistole.', 'Erklärung Übung mit Geisterpistole', 'Audio', NULL);
INSERT INTO media VALUES (17, 'Audio\Erklärung Übung ohne Geisterpistole.wav', 'Der Ausbildungsmeister führt in die Übung ein.', 'Erklärung Übung ohne Geisterpistole', 'Audio', NULL);
INSERT INTO media VALUES (18, 'Audio\Erklärung Übung ohne Distanzstrahl.wav', 'Der Ausbildungsmeister führt in die Übung ein.', 'Erklärung Übung ohne Distanzstrahl', 'Audio', NULL);
INSERT INTO media VALUES (19, 'Videos\Viskosität messen.mp4', 'Ein Video in dem die richtige Messung der Viskosität gezeigt wird.', 'Viskosität messen', 'Video', NULL);
INSERT INTO media VALUES (20, 'Audio\Finale Erinnerung (Fremdgesteuerte Lernaufgabe).wav', 'Prüfe das Spritzbild anhand einer Spritzprobe und beginne anschließend mit dem Lackieren.', 'Finale Erinnerung (Fremdgesteuerte Lernaufgabe)', 'Audio', NULL);
INSERT INTO media VALUES (21, 'Audio\Neuteillackierung 3 - Einleitung.wav', 'Schön, dass du wieder da bist. Wir befinden uns mitten in der ersten Aufgabenklasse zu Neuteillackierungen. Im zu dieser Lernaufgabe gehörigen Kundenauftrag geht es darum, eine Motorhaube mit einer Zweischichtlackierung zu lackieren. Was versteht man überhaupt unter einer Zweischichtlackierung? Lege alle Bestandteile, die du für eine Zweischichtlackierung benötigst, in den Korb.', 'Neuteillackierung 3 - Einleitung', 'Audio', NULL);
INSERT INTO media VALUES (22, 'Audio\Neuteillackierung 3 - Decklackierungen.wav', 'Lerne nun mehr über die Unterschiede zwischen Ein-, Zwei- und Dreischichtlackierungen.', 'Neuteillackierung 3 - Decklackierungen', 'Audio', NULL);
INSERT INTO media VALUES (23, 'Audio\Neuteillackierung 3 - Lackauswahl.wav', 'Du hast nun die Möglichkeit, den Kundenauftrag mitzugestalten. In welcher Farbe soll die Motorhaube lackiert werden?', 'Neuteillackierung 3 - Lackauswahl', 'Audio', NULL);
INSERT INTO media VALUES (24, 'Audio\Neuteillackierung 3 - Kundenauftrag.wav', 'Der Kundenauftrag beinhaltet also eine Zweischichtlackierung auf einer Motorhaube. Im Vorhinein wurden bereits sämtliche vorbereitenden Tätigkeiten, z.B. optische Prüfung, Reinigungsarbeiten, Mischen der Farben erledigt. Daher starten wir direkt mit der Applikation. Gleich wirst du sehen, wie ich zuerst den Basislack, dann den Klarlack auf der Haube appliziere. Achte dabei genau auf den Verlauf, Winkel und Abstand der Lackierpistole. Bist du startklar?', 'Neuteillackierung 3 - Kundenauftrag', 'Audio', NULL);
INSERT INTO media VALUES (26, 'Audio\Neuteillackierung 3 - Verarbeitungsrichtlinien.wav', 'Herstellerabhängige Verarbeitungsrichtlinien für Beschichtungsstoffe liefern dir wichtige Informationen zu den Eigenschaften eines Lacks. Unter anderem weisen dich die Herstellerinformationen auf die optimale Ablüft- und Trockenzeit hin.', 'Neuteillackierung 3 - Verarbeitungsrichtlinien', 'Audio', NULL);
INSERT INTO media VALUES (27, 'Audio\Neuteillackierung 3 - Merkblatt öffnen.wav', 'Öffne die Verarbeitungsrichtlinien und versuche herauszufinden, wie lange Ablüft- und Trockenzeit bei diesem Basislack betragen sollte.', 'Neuteillackierung 3 - Merkblatt öffnen', 'Audio', NULL);
INSERT INTO media VALUES (28, 'Audio\Neuteillackierung 3 - Aufnahme 2.wav', 'Der Basislack ist nun appliziert. Nach der vorgeschriebenen Ablüft- und Trockenzeit ist er mittlerweile auch matt. Fehlt noch der Klarlack. Schauen wir uns den Gang an, bei dem ich den Klarlack appliziere. Achte dabei wieder genau auf den Verlauf, Winkel und Abstand der Lackierpistole. Weiter geht’s!', 'Neuteillackierung 3 - Aufnahme 2', 'Audio', NULL);
INSERT INTO media VALUES (29, 'Audio\Neuteillackierung 3 - Gütekriterien.wav', 'Was ist dir während der Applikation der Lacke aufgefallen?', 'Neuteillackierung 3 - Gütekriterien', 'Audio', NULL);
INSERT INTO media VALUES (62, 'Audio\Neuteillackierung 1 - Frage Arbeitsschutz.wav', 'Achja, Arbeitsschutz. Das ist ein wichtiges Thema, das du verinnerlichen solltest. Täglich trägst du Handschuhe, die deine Haut vor Chemikalien schützt. Weißt du, was die Schutzklassen 1-6 bei Schutzhandschuhen bedeuten? ', 'Neuteillackierung 1 - Frage Arbeitsschutz', 'Audio', NULL);
INSERT INTO media VALUES (63, 'Audio\Neuteillackierung 1 - Frage Arbeitsschutz Feedback.wav', 'Von dieser Kategorisierung hängt auch ab, wie oft Handschuhe gewechselt werden müssen.', 'Neuteillackierung 1 - Frage Arbeitsschutz Feedback', 'Audio', NULL);
INSERT INTO media VALUES (30, 'Audio\Neuteillackierung 3 - Überleitung Lackierung.wav', 'Nun bist du an der Reihe. In der Lackierwerkstatt befindet sich eine weitere Motorhaube, auf die du den von dir ausgewählten Basislack in einem deckenden Gang applizieren sollst. Der Basislack ist bereits fertig angemischt. Den Klarlack werde ich nach der vorgeschriebenen Ablüft- und Trockenzeit selbst applizieren. Vorhin hast du gelernt, worauf du beim Lackieren alles achten sollst. Achte auf Verlauf, Abstand und Winkel. Der Distanzstrahl wird dir bei dieser Lernaufgabe wieder helfen, dieses Mal allerdings nur am Anfang und Ende. Bereit? Du schaffst das! Achja, vergiss die Spritzprobe nicht!', 'Neuteillackierung 3 - Überleitung Lackierung', 'Audio', NULL);
INSERT INTO media VALUES (31, 'Audio\Neuteillackierung 3 - Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Aber was kann man überhaupt durch die Spritzprobe erkennen? Fehler im Spritzbild sind Indizien für Verschmutzungen in der Lackierpistole, Beschädigungen an Düsenelementen usw. Informiere dich auf dem Monitor über die Spritzprobe an sich, über mögliche Fehlerquellen im Spritzbild und erhalte Tipps, wie diese beseitigt werden können. ', 'Neuteillackierung 3 - Spritzprobe', 'Audio', NULL);
INSERT INTO media VALUES (32, 'Audio\Neuteillackierung 3 - unauffällige Spritzprobe.wav', 'Dein Spritzbild ist aber unauffällig. Du kannst lackieren. ', 'Neuteillackierung 3 - unauffällige Spritzprobe', 'Audio', NULL);
INSERT INTO media VALUES (33, 'Audio\Neuteillackierung 3 - Auswertung.wav', 'Geschafft. Schau dir bei der Auswertung besonders deine Ergebnisse bei Abstand und Winkel an.', 'Neuteillackierung 3 - Auswertung', 'Audio', NULL);
INSERT INTO media VALUES (38, 'Images\Decklackierungen 1.png', 'Erste Folie zu Decklackierungen.', 'Decklackierungen 1', 'Image', NULL);
INSERT INTO media VALUES (39, 'Images\Decklackierungen 2.png', '2. Folie zu Decklackierungen.', 'Decklackierungen 2', 'Image', NULL);
INSERT INTO media VALUES (40, 'Images\Decklackierungen 3.png', '3. Folie zu Decklackierungen.', 'Decklackierungen 3', 'Image', NULL);
INSERT INTO media VALUES (41, 'Images\Decklackierungen 4.png', '4. Folie zu Decklackierungen.', 'Decklackierungen 4', 'Image', NULL);
INSERT INTO media VALUES (42, 'Images\Decklackierungen 5.png', '5. Folie zu Decklackierungen.', 'Decklackierungen 5', 'Image', NULL);
INSERT INTO media VALUES (43, 'Images\Decklackierungen 6.png', '6. Folie zu Decklackierungen.', 'Decklackierungen 6', 'Image', NULL);
INSERT INTO media VALUES (44, 'Images\Decklackierungen 7.png', '7. Folie zu Decklackierungen.', 'Decklackierungen 7', 'Image', NULL);
INSERT INTO media VALUES (45, 'Images\Spritzbild 1.png', '1. Folie zum Spritzbild.', 'Spritzbild 1', 'Image', NULL);
INSERT INTO media VALUES (46, 'Images\Spritzbild 2.png', '2. Folie zum Spritzbild.', 'Spritzbild 2', 'Image', NULL);
INSERT INTO media VALUES (47, 'Images\Spritzbild 3.png', '3. Folie zum Spritzbild.', 'Spritzbild 3', 'Image', NULL);
INSERT INTO media VALUES (48, 'Images\Spritzbild 4.png', '4. Folie zum Spritzbild.', 'Spritzbild 4', 'Image', NULL);
INSERT INTO media VALUES (49, 'Images\Spritzbild 5.png', '5. Folie zum Spritzbild.', 'Spritzbild 5', 'Image', NULL);
INSERT INTO media VALUES (50, 'Images\Spritzbild 6.png', '6. Folie zum Spritzbild.', 'Spritzbild 6', 'Image', NULL);
INSERT INTO media VALUES (51, 'Images\Spritzbild 7.png', '7. Folie zum Spritzbild.', 'Spritzbild 7', 'Image', NULL);
INSERT INTO media VALUES (52, 'Images\Spritzbild 8.png', '8. Folie zum Spritzbild.', 'Spritzbild 8', 'Image', NULL);
INSERT INTO media VALUES (53, 'Images\Spritzbild 9.png', '9. Folie zum Spritzbild.', 'Spritzbild 9', 'Image', NULL);
INSERT INTO media VALUES (54, 'Audio\Decklackierungen 1 Erklärung.wav', 'Was versteht man unter Decklackierungen?', 'Decklackierungen 1 Erklärung', 'Audio', NULL);
INSERT INTO media VALUES (55, 'Audio\Decklackierungen 2 Erklärung.wav', 'Der Decklack oder auch top coat bildet die oberste Schicht des Lackiersystems. Er wird auf den geschliffenen oder den abgelüfteten Füller aufgebracht. Man unterscheidet zwischen Einschicht-Decklackierung, Zwei-Schicht-Decklackierung und Mehrschicht-Decklackierung.  Auf diesem Foto siehst du den Prozess einer Lackierung vom Rohzustand über Verzinkung, Phosphatierung, Füllern hin zur Decklackierung. In der obersten Zeile siehst du zum Beispiel die Einschicht-Uni-Lackierung. In der Zeile darunter die Zwei-Schicht-Uni-Lackierung. Darunter die Zwei-Schicht-Uni-Lackierung in Metallic und so weiter.', 'Decklackierungen 2 Erklärung', 'Audio', NULL);
INSERT INTO media VALUES (56, 'Audio\Decklackierungen 3 Erklärung.wav', 'Aber was genau sind nun die Unterschiede zwischen Einschicht-Decklackierung, Zweischicht-Decklackierung und Mehrschicht-Decklackierung?', 'Decklackierungen 3 Erklärung', 'Audio', NULL);
INSERT INTO media VALUES (57, 'Audio\Decklackierungen 4 Erklärung.wav', 'Unter einer Einschicht-Decklackierung versteht man einen Decklack, der nur aus einer Schicht besteht. Diese Schicht enthält die farbgebenden Komponenten und schützt gleichzeitig die darunterliegenden Schichten durch seine hohe mechanische und chemische Beständigkeit.', 'Decklackierungen 4 Erklärung', 'Audio', NULL);
INSERT INTO media VALUES (58, 'Audio\Decklackierungen 5 Erklärung.wav', 'Unter einer Zweischicht-Decklackierung versteht man einen Decklack, der aus zwei Schichten besteht, dem Basislack und dem Klarlack. Der Einkomponenten-Basislack ist ein physikalisch trocknender Einkomponentenlack. Das heißt er trocknet durch die Verdunstung des Lösemittels. Danach erscheint die Oberfläche matt. Der Basislack enthält die farbgebende Komponente. Bei Metallic- und Perleffekt-Lackierungen sind zusätzlich noch die Effektpigmente in Form kleiner Metall- oder Glimmerplättchen eingelagert.  Der Basislack ist nicht witterungsbeständig. Deswegen muss er durch eine zweite Lackschicht, den unpigmentierten Klarlack, geschützt werden.  Gleichzeitig verleiht er der Lackierung hohen Glanz. Er wird nach der vorgeschriebenen Ablüftzeit nass-in-nass auf den Basislack aufgespritzt.', 'Decklackierungen 5 Erklärung', 'Audio', NULL);
INSERT INTO media VALUES (59, 'Audio\Decklackierungen 6 Erklärung.wav', 'Manche Lackierungen wie beispielsweise Perleffekt-Lackierungen benötigen noch zusätzliche Lackschichten. So wird auf die Schicht mit den effektgebenden Pigmenten eine weitere Schicht mit farbgebenden Pigmenten aufgetragen. So kommt der Perleffekt besser zur Erscheinung. Anschließend wird noch mit normalem Klarlack überlackiert.', 'Decklackierungen 6 Erklärung', 'Audio', NULL);
INSERT INTO media VALUES (60, 'Audio\Neuteillackierung 1 - Einleitung.wav', 'Hallo. Wir befinden uns ganz am Anfang der ersten Aufgabenklasse, in der es um Neuteillackierungen gehen wird. Während der Aufgabenklasse bearbeitest du sechs zu der Aufgabenklasse dazugehörige Lernaufgaben. Jede der sechs Lernaufgaben behandelt einen Kundenauftrag. Gleich werde ich dir erläutern, was es bei Neuteillackierungen zu beachten gilt. Ich werde dir auch zeigen, wie ich einen Basislack Einschicht-Uni-Lack auf einen neuen Kotflügel auftrage. Pass gut auf! Bist du startklar?', 'Neuteillackierung 1 - Einleitung', 'Audio', NULL);
INSERT INTO media VALUES (61, 'Audio\Neuteillackierung 1 - Aufgabenstellung.wav', 'Der Kundenauftrag lautet einen neuen Kotflügel aus Stahlblech zu beschichten. Zuerst geht es an die Vorbereitung der Lackierung. Hier muss bereits sehr sorgfältig gearbeitet werden, um später eine perfekte Lackoberfläche zu erzielen. Für Teillackierungen werden leicht zu demontierende Teile, wie bei unserem Beispiel der Kotflügel, ausgebaut. Es handelt sich um eine Neulackierung. Daher sollten die Untergründe bereits fertig vorbereitet sein. Dennoch lohnt sich eine Kontrolle. Zuerst habe ich den Kotflügel visuell und haptisch auf Beschädigungen wie Dellen oder Kratzer geprüft. Ich habe keine Schäden feststellen können. Zu einer guten Vorbereitung gehört es auch, seine Werkzeuge, Materialien und persönliche Schutzausrüstung vorzubereiten und bereit zu legen.', 'Neuteillackierung 1 - Aufgabenstellung', 'Audio', NULL);
INSERT INTO media VALUES (64, 'Audio\Neuteillackierung 1 - Information Arbeitsablauf.wav', 'Dann wird das Werkstück angeschliffen, gründlich gereinigt, entfettet und entstaubt. Für eine optimale Haftung von Grundierung, Füller oder Lack muss das Werkstück von Fett, Öl, Wachs und Silikon gesäubert werden. Falls doch Unebenheiten oder Dellen vorhanden sind oder Vertiefungen auftauchen, werden diese anschließend mit einem Polyesterspachtel bearbeitet. Die Spachtelschicht wird nochmals geschliffen und gereinigt. Blanke Metallteile werden nun mit einer Grundierung behandelt. Diese Schicht schützt vor Korrosion und dient als Haftvermittler zwischen Karosserieteil und Schichtaufbau. Eine Füllerschicht sorgt anschließend für eine glatte Oberfläche und füllt feinste Poren und Microkratzer.', 'Neuteillackierung 1 - Information Arbeitsablauf', 'Audio', NULL);
INSERT INTO media VALUES (65, 'Audio\Neuteillackierung 1 - Interaktive Frage Trocknung 1.wav', 'Weißt du, wie lange eine Füllerschicht, die mit einem 2-Komponenten Nass-in-Nass Grundierfüller appliziert wurde, bei 60 bis 65 Grad im Ofen trocknen sollte?', 'Neuteillackierung 1 - Interaktive Frage Trocknung 1', 'Audio', NULL);
INSERT INTO media VALUES (66, 'Audio\Neuteillackierung 1 - Interaktive Frage Trocknung 1 Feedback.wav', 'Bei Ofentrocknung bei etwa 60 Grad sollte das Karosserieteil 45 Minuten trocknen. Anders sieht das bei Lufttrocknung aus. Das dauert 12 bis 16 Stunden bei einer Umgebungstemperatur von 25 Grad. Bei Infrarotstrahler Trocknung geht es besonders schnell. Maximal 12 Minuten. ', 'Neuteillackierung 1 - Interaktive Frage Trocknung 1 Feedback', 'Audio', NULL);
INSERT INTO media VALUES (67, 'Audio\Neuteillackierung 1 - Interaktive Frage Farbmenge.wav', 'Ich habe auch schon den Basislack angemischt, gemäß Kundenauftrag die Farbe Canvasitblau. Was schätzt du, wie viel Menge du für die Lackierung eines Kotflügels benötigst?', 'Neuteillackierung 1 - Interaktive Frage Farbmenge', 'Audio', NULL);
INSERT INTO media VALUES (68, 'Audio\Neuteillackierung 1 - Aufnahme.wav', 'Ich zeige dir nun, wie ich den Unilack in einem deckenden Gang auftrage. Der Lack wurde in dem Farbton des Fahrzeuges gemäß Farbcode angemischt.', 'Neuteillackierung 1 - Aufnahme', 'Audio', NULL);
INSERT INTO media VALUES (69, 'Audio\Neuteillackierung 1 - Interaktive Frage Trocknung 2.wav', 'Geschafft. Kannst du dich noch erinnern, wie lange der Unilack bei Infrarotstrahler-Trocknung maximal trocknen muss?', 'Neuteillackierung 1 - Interaktive Frage Trocknung 2', 'Audio', NULL);
INSERT INTO media VALUES (70, 'Audio\Neuteillackierung 1 - Überleitung Lackieren.wav', 'Nun bist du an der Reihe. In der Lackierwerkstatt befindet sich ein weiterer Kotflügel, der darauf wartet, von dir mit einem Unilack in Tieforange lackiert zu werden. Den Basislack habe ich bereits für dich vorbereitet. Du kannst direkt starten und einen deckenden Gang applizieren. Der Distanzstrahl wird dir bei dieser Lernaufgabe die ganze Zeit dabei helfen, den idealen Abstand zum Werkstück einzuhalten. Bevor du allerdings mit dem Lackieren loslegst, darfst du einen wichtigen Schritt nicht vergessen. Die Spritzprobe. In der Lackierkabine befindet sich ein Test-Papier für die Spritzprobe, auf dem du die Spritzprobe durchführen kannst. Los geht’s!', 'Neuteillackierung 1 - Überleitung Lackieren', 'Audio', NULL);
INSERT INTO media VALUES (71, 'Audio\Neuteillackierung 1 - Feedback Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Du kannst nun lackieren.', 'Neuteillackierung 1 - Feedback Spritzprobe', 'Audio', NULL);
INSERT INTO media VALUES (72, 'Audio\Neuteillackierung 1 - Frage Messung Schichtdicke.wav', 'Geschafft. Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einem Werkstück aus Stahl, wie in unserem Fall?', 'Neuteillackierung 1 - Frage Messung Schichtdicke', 'Audio', NULL);
INSERT INTO media VALUES (73, 'Audio\Neuteillackierung 1 - Abschluss.wav', 'Wichtig ist außerdem, dass du vor jeder Kundenübergabe das Werkstück noch einmal mit einer Poliermaschine oder einem Polierschwamm auf Hochglanz polierst und abschließend letzte Verschmutzungen mit einem Mikrofasertuch reinigst.', 'Neuteillackierung 1 - Abschluss', 'Audio', NULL);
INSERT INTO media VALUES (75, 'Audio\Neuteillackierung 2 - Einleitung.wav', 'Hallo. Wir befinden uns noch immer recht am Anfang der ersten Aufgabenklasse, in der es um Neuteillackierungen geht. Hier siehst du das Produkt eines Kundenauftrages, bei dem wir bereits eine neue Autotür aus Aluminium mit einem Unilack in Hibiskus Rot lackiert haben. Guck dir das lackierte Werkstück genau an. Dafür kannst du dir im Menüfeld Auswertung die Erfolgskriterien anschauen oder die Lupe nutzen. Welche typischen Lackierfehler sind zu beobachten?', 'Neuteillackierung 2 - Einleitung', 'Audio', NULL);
INSERT INTO media VALUES (76, 'Audio\Neuteillackierung 2 - Aufgabenstellung.wav', 'Bei der Bearbeitung des Kundenauftrages sind wohl einige Fehler passiert. Vielleicht sind sie dir schon aufgefallen. Schauen wir uns das Werkstück nochmal gemeinsam an. Oben links zum Beispiel ist ein dicker Läufer entstanden. So ist die Tür auf keinen Fall kundenfähig.', 'Neuteillackierung 2 - Aufgabenstellung', 'Audio', NULL);
INSERT INTO media VALUES (77, 'Audio\Neuteillackierung 2 - Multiple Choice 1.wav', 'Wie entstehen solche Läufer? Läufer entstehen durch eine zu hohe Schichtdicke. Unter Anwendung einer falschen Geschwindigkeit wird das Material nicht gleichmäßig verteilt. Durch die Schwerkraft wird das Material nach unten gezogen. Im Extremfall fließt es sogar gardinenartig nach unten. Läufer im Lack gehören zu den typischen Lackierfehlern, die nicht nur bei Anfängern, sondern auch bei erfahrenen Lackiererinnen und Lackierern immer mal wieder vorkommen. Das liegt daran, dass mehrere Ursachen für die ärgerlichen Lackläufer verantwortlich sein können. Welche der Antwortmöglichkeiten treffen als Ursachen für Läufer zu?', 'Neuteillackierung 2 - Multiple Choice 1', 'Audio', NULL);
INSERT INTO media VALUES (78, 'Audio\Neuteillackierung 2 - Multiple Choice 1 Lösung.wav', 'Merke: Zu viel oder falscher Verdünner, zu geringer Abstand zum Werkstück, zu langsame Applikation, zu kurze Ablüftzeiten oder eine zu niedrige Temperatur der Kabine oder des Lacks können zu Läufern führen.', 'Neuteillackierung 2 - Multiple Choice 1 Lösung', 'Audio', NULL);
INSERT INTO media VALUES (79, 'Audio\Neuteillackierung 2 - Schätzaufgabe.wav', 'Läufer vermeidest du, indem du den Lack immer gemäß technischem Merkblatt mit Härter und Verdünnung anmischst und auf seine Viskosität überprüfst. Außerdem solltest du auf die ideale Lackiertemperatur achten. Weißt du, wie die sein sollte?', 'Neuteillackierung 2 - Schätzaufgabe', 'Audio', NULL);
INSERT INTO media VALUES (80, 'Audio\Neuteillackierung 2 - Läufer.wav', 'Was aber tun, wenn Läufer bereits entstanden sind? Schaue dir nun an, wie man Läufer im Lack beheben kann. ', 'Neuteillackierung 2 - Läufer', 'Audio', NULL);
INSERT INTO media VALUES (81, 'Audio\Neuteillackierung 2 - Verlaufsstörungen.wav', 'Verlaufsstörungen sind ein weiteres Ärgernis. Unter einer Verlaufsstörung versteht man eine Oberflächenstruktur, die der Oberfläche einer Apfelsinen- oder Orangenschale ähnelt. Die Ursachen für Verlaufsstörungen können sehr vielfältig sein. Auf dem Bildschirm stehen die wichtigsten. Merke sie dir gut.', 'Neuteillackierung 2 - Verlaufsstörungen', 'Audio', NULL);
INSERT INTO media VALUES (82, 'Audio\Neuteillackierung 2 - Vergessene Kanten.wav', 'Unten rechts an der Kante wurde scheinbar vergessen zu lackieren. Auch wenn manche Stellen schwer zu erreichen sind und auch der Lack schwieriger zu applizieren, ist gründliches Arbeiten notwendig, um kundenfähige Produkte zu erhalten.', 'Neuteillackierung 2 - Vergessene Kanten', 'Audio', NULL);
INSERT INTO media VALUES (83, 'Audio\Neuteillackierung 2 - Überleitung Lackieren.wav', 'Bei sämtlichen Schritten in der Aufgabenfolge können Fehler passieren, die sich im Lackierergebnis widerspiegeln. Daher ist es umso wichtiger mit deinem Ausbildungsmeister oder anderen Auszubildenden zu reflektieren, wodurch Fehler entstanden sind und wie du sie beim nächsten Mal vermeiden kannst. Du hast jetzt die Gelegenheit, den vorliegenden Kundenauftrag besser zu bearbeiten als dargeboten. Eine weitere Autotür wartet nur darauf, von dir in einem deckenden Gang im Unilack in Hibiskus Rot lackiert zu werden. Ich habe bereits alles für dich vorbereitet, du kannst direkt loslegen. Der Distanzstrahl wird dir bei dieser Lernaufgabe erneut die ganze Zeit dabei helfen, den idealen Abstand zum Werkstück einzuhalten. Bevor du allerdings mit dem Lackieren loslegst, darfst du einen wichtigen Schritt nicht vergessen. Die Spritzprobe. Bist du startklar?', 'Neuteillackierung 2 - Überleitung Lackieren', 'Audio', NULL);
INSERT INTO media VALUES (84, 'Audio\Neuteillackierung 2 - Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Du kannst nun lackieren.', 'Neuteillackierung 2 - Spritzprobe', 'Audio', NULL);
INSERT INTO media VALUES (85, 'Audio\Neuteillackierung 2 - Multiple Choice Frage 2.wav', 'Geschafft. Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einer Autotür aus Aluminium?', 'Neuteillackierung 2 - Multiple Choice Frage 2', 'Audio', NULL);
INSERT INTO media VALUES (86, 'Images\Läufer 1.png', 'Bild 1 der Präsentation zu Läufern.', 'Läufer 1', 'Image', NULL);
INSERT INTO media VALUES (87, 'Images\Läufer 2.png', 'Bild 2 der Präsentation zu Läufern.', 'Läufer 2', 'Image', NULL);
INSERT INTO media VALUES (88, 'Images\Läufer 3.png', 'Bild 3 der Präsentation zu Läufern.', 'Läufer 3', 'Image', NULL);
INSERT INTO media VALUES (89, 'Images\Läufer 4.png', 'Bild 4 der Präsentation zu Läufern.', 'Läufer 4', 'Image', NULL);
INSERT INTO media VALUES (90, 'Images\Läufer 5.png', 'Bild 5 der Präsentation zu Läufern.', 'Läufer 5', 'Image', NULL);
INSERT INTO media VALUES (91, 'Images\Läufer 6.png', 'Bild 6 der Präsentation zu Läufern.', 'Läufer 6', 'Image', NULL);
INSERT INTO media VALUES (92, 'Images\Läufer 7.png', 'Bild 7 der Präsentation zu Läufern.', 'Läufer 7', 'Image', NULL);
INSERT INTO media VALUES (93, 'Audio\Neuteillackierung 1e - Einleitung.wav', 'Hallo. Wir befinden uns ganz am Anfang der ersten Aufgabenklasse, in der es um Neuteil Lackierungen gehen wird. Jede der sechs Lernaufgaben behandelt einen Kundenauftrag. Hier siehst du das Produkt eines Kundenauftrages, bei dem wir bereits eine neue Autotür aus Aluminium mit einem Unilack in Hibiskus Rot lackiert haben. Momentan siehst du die Heatmap, die dir die Schichtdicke anzeigt. Guck dir das lackierte Werkstück genau an. Dafür kannst du dir im Menüfeld Auswertung die Erfolgskriterien anschauen oder die Lupe in deiner Hand nutzen. Welche typischen Lackierfehler sind zu beobachten?', 'Neuteillackierung 1e - Einleitung', 'Audio', NULL);
INSERT INTO media VALUES (94, 'Audio\Neuteillackierung 1e - Aufgabenstellung.wav', 'Bei der Bearbeitung des Kundenauftrages sind wohl einige Fehler passiert. Vielleicht sind sie dir schon aufgefallen. Schauen wir uns das Werkstück nochmal gemeinsam an. Oben links zum Beispiel ist ein dicker Läufer entstanden. So ist die Tür auf keinen Fall kundenfähig.', 'Neuteillackierung 1e - Aufgabenstellung', 'Audio', NULL);
INSERT INTO media VALUES (95, 'Audio\Neuteillackierung 1e - Multiple Choice.wav', 'Wie entstehen solche Läufer? Läufer entstehen durch eine zu hohe Schichtdicke. Unter Anwendung einer falschen Geschwindigkeit wird das Material nicht gleichmäßig verteilt. Durch die Schwerkraft wird das Material nach unten gezogen. Im Extremfall fließt es sogar gardinenartig nach unten. Läufer im Lack gehören zu den typischen Lackierfehlern. Das liegt daran, dass mehrere Ursachen für die ärgerlichen Lackläufer verantwortlich sein können. Welche der Antwortmöglichkeiten treffen als Ursachen für Läufer zu?', 'Neuteillackierung 1e - Multiple Choice', 'Audio', NULL);
INSERT INTO media VALUES (96, 'Audio\Neuteillackierung 1e - Schätzaufgabe.wav', 'Läufer vermeidest du, indem du den Lack immer gemäß technischem Merkblatt mit Härter und Verdünnung anmischst und auf seine Viskosität überprüfst. Außerdem solltest du auf die ideale Lackiertemperatur achten. Weißt du, wie die sein sollte?', 'Neuteillackierung 1e - Schätzaufgabe', 'Audio', NULL);
INSERT INTO media VALUES (97, 'Audio\Neuteillackierung 1e - Unterstüzende Information.wav', 'Was aber tun, wenn Läufer bereits entstanden sind? Schaue dir nun eine Präsentation an, in der erklärt wird, wie man Läufer im Lack beheben kann.', 'Neuteillackierung 1e - Unterstüzende Information', 'Audio', NULL);
INSERT INTO media VALUES (98, 'Audio\Neuteillackierung 1e - Arbeitsauftrag.wav', 'Du hast jetzt die Gelegenheit, den vorliegenden Kundenauftrag besser zu bearbeiten als dargeboten. Eine weitere Autotür wartet nur darauf, von dir im Unilack in Hibiskus Rot lackiert zu werden. Ich habe bereits alles für dich vorbereitet, du kannst direkt loslegen. Der Distanzstrahl wird dir bei dieser Lernaufgabe die ganze Zeit dabei helfen, den idealen Abstand zum Werkstück einzuhalten. Bevor du allerdings mit dem Lackieren loslegst, darfst du einen wichtigen Schritt nicht vergessen. Die Spritzprobe. In der Lackierkabine befindet sich ein Test-Papier, auf dem du die Spritzprobe durchführen kannst. Bist du startklar?', 'Neuteillackierung 1e - Arbeitsauftrag', 'Audio', NULL);
INSERT INTO media VALUES (99, 'Audio\Neuteillackierung 1e - Spritzprobe.wav', 'Das Spritzbild sieht gut aus. Du kannst nun lackieren.', 'Neuteillackierung 1e - Spritzprobe', 'Audio', NULL);
INSERT INTO media VALUES (100, 'Audio\Neuteillackierung 1e - Auswertung.wav', 'Geschafft. Auf dem Werkstück siehst du nun die Heatmap. An den roten Stellen hast du zu viel Lack appliziert, an den blauen Stellen zu wenig und an den grünen Stellen genau richtig. Du kannst dir auf dem Bildschirm unter dem Feld Auswertung auch noch andere Bewertungskriterien anschauen.', 'Neuteillackierung 1e - Auswertung', 'Audio', NULL);
INSERT INTO media VALUES (101, 'Audio\Neuteillackierung 1e - Selbsteinschätzung.wav', 'Wie zufrieden bist du mit deiner Leistung in dieser Lernaufgabe? Auf dem Tisch befinden sich drei goldene Lackierpistolen. Packe entsprechend deiner Leistung in der Lernaufgabe so viele Lackierpistolen in den Korb nach links wie du für angemessen empfindest.', 'Neuteillackierung 1e - Selbsteinschätzung', 'Audio', NULL);
INSERT INTO media VALUES (102, 'Audio\Neuteillackierung PTPe - Multiple Choice.wav', 'Dies ist die erste von mehreren zusätzlichen Übungen in dieser Aufgabenklasse, in der du üben sollst, den idealen Abstand zum Werkstück während des Lackierens einzuhalten. Was ist nochmal der ideale Abstand zum Werkstück?', 'Neuteillackierung PTPe - Multiple Choice', 'Audio', NULL);
INSERT INTO media VALUES (103, 'Audio\Neuteillackierung PTPe - Multiple Choice Lösung.wav', 'Der ideale Abstand beträgt also 15-20cm. Vielen Auszubildenden fällt es schwer, sich permanent im korrekten Abstand zu befinden. Bedenke im Vorhinein, ob du das Werkstück noch anders ausrichten muss. Es kann auch gut sein, dass du in die Knie gehen oder dich strecken musst.', 'Neuteillackierung PTPe - Multiple Choice Lösung', 'Audio', NULL);
INSERT INTO media VALUES (104, 'Audio\Neuteillackierung PTPe - Aufgabenstellung.wav', 'Positioniere dich nun mit Hilfe des Distanzstrahls im idealen Abstand zum Werkstück und lackiere anschließend das gesamte Werkstück in einem Gang. Achte dabei besonders darauf, die ganze Zeit den idealen Abstand einzuhalten. Dabei wird dir der Distanzstrahl helfen.', 'Neuteillackierung PTPe - Aufgabenstellung', 'Audio', NULL);
INSERT INTO media VALUES (105, 'Audio\Neuteillackierung PTP1 - Multiple Choice 1.wav', 'Dies ist die erste von drei zusätzlichen Übungen in dieser Aufgabenklasse, in der du üben sollst, den idealen Abstand zum Werkstück während des Lackierens einzuhalten. Was ist nochmal der ideale Abstand zum Werkstück?', 'Neuteillackierung PTP1 - Multiple Choice 1', 'Audio', NULL);
INSERT INTO media VALUES (106, 'Audio\Neuteillackierung PTP1 - Multiple Choice 1 Lösung.wav', 'Der ideale Abstand beträgt also 15-20cm. Vielen Auszubildenden fällt es schwer, sich permanent im korrekten Abstand zu befinden. Das kann je nach Werkstück und Rahmenbedingungen auch gar nicht so einfach sein. Bedenke im Vorhinein, ob du das Werkstück noch anders ausrichten muss. Es kann auch gut sein, dass du in die Knie gehen oder dich strecken musst.', 'Neuteillackierung PTP1 - Multiple Choice 1 Lösung', 'Audio', NULL);
INSERT INTO media VALUES (107, 'Audio\Neuteillackierung PTP1 - Multiple Choice 2.wav', 'Verändert sich dein Abstand zum Werkstück, wirkt sich das auch auf das Ergebnis deiner Lackierung aus. Was passiert, wenn du dich zu nah am Werkstück befindest?', 'Neuteillackierung PTP1 - Multiple Choice 2', 'Audio', NULL);
INSERT INTO media VALUES (108, 'Audio\Neuteillackierung PTP1 - Überleitung Lackieren.wav', 'Stehst du zu nah dran, müsstest du schneller lackieren, sonst verteilt sich mehr Farbe auf weniger Fläche, was zu Läufern und Verlaufsstörungen führen kann. Positioniere dich nun mit Hilfe des Distanzstrahls im idealen Abstand zum Werkstück und lackiere anschließend das gesamte Werkstück in einem deckenden Gang. Achte dabei besonders darauf, die ganze Zeit den idealen Abstand einzuhalten. Dabei wird dir der Distanzstrahl helfen.', 'Neuteillackierung PTP1 - Überleitung Lackieren', 'Audio', NULL);
INSERT INTO media VALUES (109, 'Audio\Neuteillackierung PTP2 - Einleitung.wav', 'Dies ist die zweite von drei zusätzlichen Übungen in dieser Aufgabenklasse, in der du üben sollst, den idealen Abstand zum Werkstück während des Lackierens einzuhalten. Bedenke stets, dass der Abstand zum Karosserieteil und die Geschwindigkeit, in der du lackierst, aufeinander abgestimmt sein müssen.', 'Neuteillackierung PTP2 - Einleitung', 'Audio', NULL);
INSERT INTO media VALUES (110, 'Audio\Neuteillackierung PTP2 - Überleitung Lackieren.wav', 'Positioniere dich nun mit Hilfe des Distanzstrahls im idealen Abstand zum Werkstück und lackiere anschließend das gesamte Werkstück in einem deckenden Gang. Achte dabei besonders darauf, die ganze Zeit den idealen Abstand einzuhalten. Zu Beginn wird dich der Distanzstrahl dabei unterstützen, den korrekten Abstand einzuhalten. Der Distanzstrahl wird aber mit der Zeit ausgeblendet. Dann bist du auf dich allein gestellt. Viel Erfolg!', 'Neuteillackierung PTP2 - Überleitung Lackieren', 'Audio', NULL);
INSERT INTO media VALUES (111, 'Audio\Neuteillackierung PTP2 - Wiederholung.wav', 'Ab der Hälfte der Fläche hast du keine Unterstützung mehr durch den Distanzstrahl bekommen. Schauen wir uns mal in der Wiederholung an, wie gut du den Abstand zum Lackieren einhalten konntest.', 'Neuteillackierung PTP2 - Wiederholung', 'Audio', NULL);
INSERT INTO media VALUES (112, 'Audio\Neuteillackierung PTP2 - Abschluss.wav', 'Innerhalb dieser Aufgabenklasse erwartet dich noch eine weitere Gelegenheit, den idealen Abstand zum Werkstück zu üben.', 'Neuteillackierung PTP2 - Abschluss', 'Audio', NULL);
INSERT INTO media VALUES (113, 'Images\Verarbeitungsrichtlinien.png', 'Verarbeitungsrichtlinien', 'Verarbeitungsrichtlinien', 'Image', null);
INSERT INTO media VALUES (114, 'Images\Tutorial Bild 1.png', 'Tutorial Bild 1', 'Tutorial Bild 1', 'Image', null);
INSERT INTO media VALUES (115, 'Images\Tutorial Bild 2.png', 'Tutorial Bild 2', 'Tutorial Bild 2', 'Image', null);
INSERT INTO media VALUES (116, 'Images\Tutorial Bild 3.png', 'Tutorial Bild 3', 'Tutorial Bild 3', 'Image', null);
INSERT INTO media VALUES (117, 'Images\Tutorial - Monitor.png', 'Tutorial - Monitor', 'Tutorial - Monitor', 'Image', null);
INSERT INTO media VALUES (118, 'Audio\Tutorial - Lackierkabine.mp3', 'Das hier ist die virtuelle Lackierkabine. Schaue dich ruhig um und wähle anschließend die grüne Münze aus, um fortzufahren.', 'Tutorial - Lackierkabine', 'Audio', null);
INSERT INTO media VALUES (119, 'Audio\Tutorial - Münzen.mp3', 'In Lernaufgaben kannst du mit der grünen Münze zum nächsten Teilschritt gehen und mit der roten Münze zum vorherigen Teilschritt zurückkehren. Am Ende einer Lernaufgabe erscheint eine goldene Münze, mit der du die Aufgabe beendest.', 'Tutorial - Münzen', 'Audio', null);
INSERT INTO media VALUES (120, 'Audio\Tutorial - Ausbildungsmeister.mp3', 'Ich bin der virtuelle Ausbildungsmeister, der dich in vielen Aufgaben begleiten wird. Wenn du mit Lackierpistole auf mich zeigst und den Abzugshebel betätigst, wiederhole ich meine letzten Worte.', 'Tutorial - Ausbildungsmeister', 'Audio', null);
INSERT INTO media VALUES (121, 'Audio\Tutorial - Fortbewegung.mp3', 'Wenn du dich in der Lackierkabine bewegen willst, kannst du das auf zwei Arten tun. Du kannst dich durch Gehen fortbewegen, dich aber auch teleportieren. Zum Teleportieren zeigst du mit der Lackierpistole auf den Boden und hältst den Abzugshebel gedrückt. Dann kannst du die Zielposition bestimmen und teleportierst dich nach dem Loslassen des Abzugshebels dorthin. In manchen Teilschritten kannst du dich nur teleportieren, wenn du weit genug vom Werkstück oder dem Plakat für die Spritzprobe entfernt bist. Ob du dich teleportieren kannst, zeigt dir das Symbol auf dem Farbbehälter der Lackierpistole.', 'Tutorial - Fortbewegung', 'Audio', null);
INSERT INTO media VALUES (122, 'Audio\Tutorial - Spritzprobe 1.mp3', 'Bei den Lernaufgaben, die du in der virtuellen Lackierwerkstatt bearbeitest, ist meistens bereits ein Werkstück auf den Lackierständer gespannt worden. Hier in der Kabine befindet sich außerdem ein Plakat für eine Spritzprobe. Führe nun eine Spritzprobe durch.
', 'Tutorial - Spritzprobe 1', 'Audio', null);
INSERT INTO media VALUES (123, 'Audio\Tutorial - Spritzprobe 2.mp3', 'Sehr gut! Fahre nun mit der grünen Münze fort.', 'Tutorial - Spritzprobe 2', 'Audio', null);
INSERT INTO media VALUES (124, 'Audio\Tutorial - Monitor 1.mp3', 'Den Monitor hast du bestimmt schon gesehen. Auf diesem kannst du am Anfang zwischen mehreren Lernaufgaben und zusätzlichen Übungseinheiten auswählen. Manche Aufgaben sind in einer Sammlung gruppiert. Der Buchstabe A steht für Lernaufgaben, der Buchstabe  Ü für eine kürze Übung und der Buchstabe U für unterstützende Informationen wie Bilder oder Videos. Erfolgreich abgeschlossene Aufgaben sind mit einer goldenen Münze markiert.
', 'Tutorial - Monitor 1', 'Audio', null);
INSERT INTO media VALUES (125, 'Audio\Tutorial - Monitor 2.mp3', 'Auf dem Monitor können dir außerdem wichtige Zusatzinformationen präsentiert werden. Hier siehst du z.B. mehrere Bilder, durch die du mit den Pfeilen darunter navigieren kannst.', 'Tutorial - Monitor 2', 'Audio', null);
INSERT INTO media VALUES (126, 'Audio\Tutorial - Multiple Choice 1.mp3', 'Manchmal sollst du Multiple-Choice-Aufgaben lösen. Dafür nimmst du eine Kugel aus der Kiste, indem du sie mit der Lackierpistole berührst, sodass eine Hand erscheint und dann hältst du den Abzugshebel gedrückt. Platziere die Kugel dann in einen der Ringe und sammle die grüne Münze ein, um die Lösung anzuzeigen.', 'Tutorial - Multiple Choice 1', 'Audio', null);
INSERT INTO media VALUES (127, 'Audio\Tutorial - Multiple Choice 2.mp3', 'Nun wird dir die korrekte Lösung angezeigt und du kannst die grüne Münze einsammeln, um fortzufahren.', 'Tutorial - Multiple Choice 2', 'Audio', null);
INSERT INTO media VALUES (128, 'Audio\Tutorial - Schätzaufgabe 1.mp3', 'Bei anderen Aufgaben musst du mit bestimmten Gegenständen interagieren. Stelle beim Thermometer die optimale Temperatur in der Lackierkabine ein. Berühre dafür das Thermometer mit der Lackierpistole, halte den Abzugshebel gedrückt und bewege die Lackierpistole nach oben oder unten. Fahre anschließend mit der grünen Münze fort.', 'Tutorial - Schätzaufgabe 1', 'Audio', null);
INSERT INTO media VALUES (129, 'Audio\Tutorial - Schätzaufgabe 2.mp3', 'Nun wird dir die korrekte Lösung angezeigt und du kannst die grüne Münze einsammeln, um fortzufahren.', 'Tutorial - Schätzaufgabe 2', 'Audio', null);
INSERT INTO media VALUES (130, 'Audio\Tutorial - Werkstück ausrichten.mp3', 'Bevor du mit dem Lackieren anfängst, solltest du darauf achten, dass das Werkstück optimal auf deine Größe und Bedürfnisse ausgerichtet ist. Die Ausrichtung des Werkstücks kannst du mit den Stangen an der Seite einstellen und die Höhe des Werkstücks kannst du mit den Stangen hinter dem Werkstück anpassen. Berühre dafür mit der Lackierpistole die Stange, sodass eine Hand erscheint und halte dann den Abzugshebel gedrückt. Durch Bewegungen mit der Lackierpistole kannst du den Lackierständer verstellen. ', 'Tutorial - Werkstück ausrichten', 'Audio', null);
INSERT INTO media VALUES (131, 'Audio\Tutorial - Werkstück lackieren.mp3', 'Manchmal erhälst du während der Applikation des Lacks zusätzliche Hilfe. Um dir zu zeigen, wie diese Hilfe ausschaut, richte die Lackierpistole auf das Werkstück. Dann siehst du den Distanzstrahl. Dieser hilft dir den idealen Abstand zum Werkstück einzuhalten. Bist du im roten Bereich, bist du zu nah dran. Bist du im blauen Bereich, bist du zu weit entfernt. Grün ist optimal. Manchmal kannst du Hilfestellungen auch selber über eine Auswahlmöglichkeit auf dem Monitor aktivieren oder deaktivieren. Lackiere nun das Werkstück.', 'Tutorial - Werkstück lackieren', 'Audio', null);
INSERT INTO media VALUES (132, 'Audio\Tutorial - Auswertung.mp3', 'Wenn du mit dem Lackieren fertig bist, hast du in der Regel die Möglichkeit dir deine Ergebnisse anzuschauen. Dazu wird die Schichtdicke auf dem Werkstück in Farben abgebildet. Blau ist zu dünn, rot zu dick, grün optimal. Wenn du durch die Lupe in deiner Hand schaust, kannst du den Farbauftrag mit der Schichtdicke auf dem Werkstück vergleichen. Auf dem Monitor kannst du dir außerdem weitere Erfolgskriterien anschauen. ', 'Tutorial - Auswertung', 'Audio', null);
INSERT INTO media VALUES (133, 'Audio\Tutorial - Selbsteinschätzung.mp3', 'Bei manchen Aufgaben sollst du deine Leistung selbst einschätzen. Packe dafür so viele goldene Lackierpistolen in den Korb, wie du für deine Leistung angemessen hälst. Beende dann die Aufgabe mit der goldenen Münze.', 'Tutorial - Selbsteinschätzung', 'Audio', null);
ALTER SEQUENCE media_id_seq RESTART WITH 134;


INSERT INTO workpiece VALUES (1, 'Car Components/bumper', 'Stoßstange', NULL);
INSERT INTO workpiece VALUES (2, 'Car Components/door', 'Tür', NULL);
INSERT INTO workpiece VALUES (3, 'Car Components/fender', 'Kotflügel', NULL);
INSERT INTO workpiece VALUES (4, 'Car Components/hood_1_big', 'Große Motorhaube', NULL);
INSERT INTO workpiece VALUES (5, 'Car Components/hood_2', 'Motorhaube', NULL);
INSERT INTO workpiece VALUES (6, 'Car Components/hood_3_small', 'Kleine Motorhaube', NULL);
INSERT INTO workpiece VALUES (7, 'Car Components/roof', 'Dach', NULL);
INSERT INTO workpiece VALUES (8, 'Car Components/side_panel', 'Seitenwand', NULL);
INSERT INTO workpiece VALUES (9, 'Car Components/square', 'Viereck', NULL);
INSERT INTO workpiece VALUES (10, 'Car Components/trunk', 'Heckklappe', NULL);
ALTER SEQUENCE workpiece_id_seq RESTART WITH 11;


INSERT INTO recording VALUES (1, 'Einschichtlackierung Tür Umgekehrt', '2021-08-24 13:12:07.566', 'Einschichtlackierung Tür Umgekehrt', '761615855d397fdfdc0a61b2deaa05d7daaceb9ee27d6b40e83484bdd272be2a', 'Einschichtlackierung Tür Umgekehrt', 70.16684, NULL, 3, NULL, NULL, 2);
INSERT INTO recording VALUES (2, 'Neuteillackierung Kotflügel Basislack', '2021-10-25 15:15:07.678', 'Neuteillackierung Kotflügel Basislack', 'b5188e5d54114bd530111d8d3f6a546c3a6c472458b3fd6c7b9621d3d97a0f63', 'Neuteillackierung Kotflügel Basislack', 99.28473, NULL, 1, NULL, NULL, 3);
INSERT INTO recording VALUES (3, 'Neuteillackierung Motorhaube Basislack', '2021-10-25 15:26:46.688', 'Neuteillackierung Motorhaube Basislack', '93229378d41f5de65b22672b2061fbbf84f7670ef27ab838ded34ac2199a6134', 'Neuteillackierung Motorhaube Basislack', 214.159454, NULL, 7, NULL, NULL, 5);
INSERT INTO recording VALUES (4, 'Neuteillackierung Motorhaube Klarlack', '2021-10-25 15:42:40.329', 'Neuteillackierung Motorhaube Klarlack', '08f0710120b058f81886a80a167b622f6c4b564256db93d07cb62f4dfb09c32e', 'Neuteillackierung Motorhaube Klarlack', 159.464478, 7, 4, NULL, NULL, 5);
ALTER SEQUENCE recording_id_seq RESTART WITH 5;


INSERT INTO task VALUES (3, 'Eine Tür soll lackiert werden.', 'Einschichtlackierung Tür (Evaluation)', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"recording\",\r\n  \"recordingId\": 1\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 93,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 94,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welche Ursachen gibt es für Läufer? \",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 95,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 3,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"zu wenig Verdünner\",\r\n    \"zu schnelle Applikation\",\r\n    \"Ablüftzeiten zu kurz\",\r\n    \"zu geringe Distanz zum Werkstück\",\r\n    \"zu hohe Kabinentemperatur \",\r\n    \"Werkstück und/oder Lack zu kalt\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    false,\r\n    true,\r\n    true,\r\n    false,\r\n    true\r\n  ]\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"minimum\": \"20\",\r\n  \"maximum\": \"25\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"thermometer\",\r\n  \"audioId\": 96,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": 86\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 87\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 88\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 89\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 90\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 91\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": 92\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 97,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 2,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 98,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"ghostPistol\": false,\r\n  \"finalAudioId\": 99,\r\n  \"skippable\": 0,\r\n  \"coatId\": 3,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"ghostPistol\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionGhostPistol\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"0\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 3,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 100,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Selbsteinschätzung","description":"","type":"Self Assessment","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 101,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (4, 'Einschichtlackierung Tür Umgekehrt', 'Einschichtlackierung Tür Umgekehrt', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"recording\",\r\n  \"recordingId\": 1\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"75\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"76\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welche Ursachen gibt es für Läufer?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"78\",\r\n  \"audioId\": \"77\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 3,\r\n  \"minAnswers\": 3,\r\n  \"answersText\": [\r\n    \"zu wenig Verdünner\",\r\n    \"zu schnelle Applikation \",\r\n    \"Ablüftzeiten zu kurz \",\r\n    \"zu geringe Distanz zum Werkstück\",\r\n    \"zu hohe Kabinentemperatur\",\r\n    \"Werkstück und/oder Lack zu kalt\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    false,\r\n    true,\r\n    true,\r\n    false,\r\n    true\r\n  ]\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Was ist die ideale Lackiertemperatur?\",\r\n  \"minimum\": \"20\",\r\n  \"maximum\": \"25\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"thermometer\",\r\n  \"audioId\": \"79\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"86\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"87\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"88\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"89\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"90\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"91\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"92\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"80\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"1. Lackviskosität zu hoch\\r\\n2. Einsatz von kurzer, schnellflüchtiger Verdünnung\\r\\n3. falsche Düsengröße\\r\\n4. Spritzpistolenabstand zu groß\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 81,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 82,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 2,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"84\",\r\n  \"coatId\": 3,\r\n  \"audioId\": \"83\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 3,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einer Autotür aus Aluminium?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 85,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"Messgerät nach dem Wirbelstromverfahren\",\r\n    \"Magnetinduktives Schichtdickenmessgerät\",\r\n    \"Anemometer \",\r\n    \"Ionisier-Messgerät\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (11, 'Übung für den richtigen Abstand.', 'Übung 1 (Evaluation)', true, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 9,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was ist der ideale Abstand zum Werkstück?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": 103,\r\n  \"audioId\": 102,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"5-10 cm\",\r\n    \"15-20 cm\",\r\n    \"25-30 cm\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"ghostPistol\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionGhostPistol\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"0\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 9,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 1,\r\n  \"audioId\": 104,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (12, 'Zweischichtlackierung Motorhaube Imitation', 'Zweischichtlackierung Motorhaube Imitation', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 5,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Gegenstände sortieren","description":"","type":"Sorting","properties":"{\r\n  \"textMonitor\": \"Lege alle Bestandteile, die du für eine Zweischichtlackierung benötigst, in den Korb.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"21\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"items\": [\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Basislack\",\r\n      \"correct\": true\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"2K-Klarlack\",\r\n      \"correct\": true\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"2K-Decklack\",\r\n      \"correct\": false\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Grundierfüller\",\r\n      \"correct\": false\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Nass-in-Nass-Füller\",\r\n      \"correct\": false\r\n    },\r\n    {\r\n      \"model\": \"CanRound\",\r\n      \"text\": \"Primer\",\r\n      \"correct\": false\r\n    }\r\n  ]\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"22\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"38\\\",\\r\\n      \\\"audioId\\\": \\\"54\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"39\\\",\\r\\n      \\\"audioId\\\": \\\"55\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"40\\\",\\r\\n      \\\"audioId\\\": \\\"56\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"41\\\",\\r\\n      \\\"audioId\\\": \\\"57\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"42\\\",\\r\\n      \\\"audioId\\\": \\\"58\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"43\\\",\\r\\n      \\\"audioId\\\": \\\"59\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"44\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Lack auswählen","description":"In welcher Farbe soll die Motorhaube lackiert werden?","type":"Coat Selection","properties":"{\r\n  \"textMonitor\": \"In welcher Farbe soll die Motorhaube lackiert werden?\",\r\n  \"skippable\": 0,\r\n  \"audioId\": 23,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"items\": [\r\n    {\r\n      \"coatId\": 5\r\n    },\r\n    {\r\n      \"coatId\": 6\r\n    },\r\n    {\r\n      \"coatId\": 7\r\n    },\r\n    {\r\n      \"coatId\": 8\r\n    }\r\n  ]\r\n}"},{"name":"Vorführung Farbauftrag","description":"","type":"Demonstration","properties":"{\r\n  \"textMonitor\": \"Sieh beim Farbauftrag zu.\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"recordingId\": 3,\r\n  \"baseCoatId\": -2,\r\n  \"coatId\": -1,\r\n  \"audioId\": \"24\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"skippable\": 0\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Verarbeitungsrichtlinien:\\r\\n- Mischverhältnis zwischen Lack, Härter und Verdünner\\r\\n- optimaler Spritzdruck\\r\\n- Anzahl der Spritzgänge\\r\\n- usw.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"26\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"Öffne die Verarbeitungsrichtlinien.\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Verarbeitungsrichtlinien\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"113\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": false,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"27\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Wie lange muss der Basislack ablüften bzw. trocknen? \",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"8-12 Minuten bei 20°C\",\r\n    \"20-25 Minuten bei 20°C\",\r\n    \"8-12 Minuten bei 25°C\",\r\n    \"20-25 Minuten bei 25°C\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    true,\r\n    false,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 5,\r\n  \"coatId\": -1,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Vorführung Farbauftrag","description":"","type":"Demonstration","properties":"{\r\n  \"textMonitor\": \"Sieh beim Farbauftrag zu.\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"recordingId\": 4,\r\n  \"baseCoatId\": -1,\r\n  \"coatId\": -2,\r\n  \"audioId\": \"28\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"skippable\": 0\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Gütekriterien\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Quality Criteria\",\r\n      \"properties\": \"{\\r\\n  \\\"sequential\\\": true\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 29,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 5,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"31\",\r\n  \"coatId\": -1,\r\n  \"audioId\": \"30\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":"","type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"45\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"46\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"47\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"48\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"49\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"50\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"51\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"52\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"53\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"32\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"15\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 5,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": -1,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": 33,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (14, 'Einschichtlackierung Kotflügel Fallstudie', 'Einschichtlackierung Kotflügel Fallstudie', false, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 3,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"60\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"61\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was bedeuten die Schutzklassen 1-6 bei Schutzhandschuhen?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"63\",\r\n  \"audioId\": \"62\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"Risiken durch Mikroorganismen\",\r\n    \"Eingeschränkter Schutz vor Chemikalien\",\r\n    \"Antistatische Eigenschaften\",\r\n    \"Chemikalienfestigkeit\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"64\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Wie lange sollte eine Füllerschicht, die mit einem 2-Komponenten Nass-in-Nass Grundierfüller appliziert wurde, bei 60 bis 65 Grad im Ofen trocknen?\",\r\n  \"minimum\": \"42\",\r\n  \"maximum\": \"48\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"clock\",\r\n  \"finalAudioId\": \"66\",\r\n  \"audioId\": \"65\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Wie viel Lack benötigst du für die Lackierung eines Kotflügels?\",\r\n  \"minimum\": \"275\",\r\n  \"maximum\": \"325\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"beaker\",\r\n  \"audioId\": \"67\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Vorführung Farbauftrag","description":"","type":"Demonstration","properties":"{\r\n  \"textMonitor\": \"Schaue dir den Farbauftrag an.\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"recordingId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 6,\r\n  \"audioId\": \"68\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"skippable\": 0\r\n}"},{"name":"Schätzaufgabe","description":"","type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Wie lange muss der Unilack bei Infrarotstrahler-Trocknung maximal trocknen?\",\r\n  \"minimum\": \"9\",\r\n  \"maximum\": \"15\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"clock\",\r\n  \"audioId\": \"69\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 3,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Spritzprobe","description":"","type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Führe eine Spritzprobe durch.\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"71\",\r\n  \"coatId\": 6,\r\n  \"audioId\": \"70\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 3,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 6,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Welches Prüfgerät eignet sich denn zur zerstörungsfreien Messung einer Beschichtung auf einem Werkstück aus Stahl?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"72\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"Schichtdickenmessrad\",\r\n    \"Messgerät nach dem magnetinduktiven Messverfahren\",\r\n    \"Schichtdickenmessuhr\",\r\n    \"Messgerät nach dem Wirbelstromverfahren\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false,\r\n    false\r\n  ]\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"73\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (15, 'Eine Übung, in der ein simples Viereck lackiert werden soll. Dabei soll insbesondere auf die Distanz zum Werkstück geachtet werden. Der Distanzstrahl ist dabei während der kompletten Übung sichtbar.', 'Übung Neuteillackierung 1', true, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 9,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was ist nochmal der ideale Abstand zum Werkstück?\",\r\n  \"shuffle\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"106\",\r\n  \"audioId\": \"105\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 1,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"5-10 cm\",\r\n    \"15-20 cm\",\r\n    \"25-30 cm\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Single/Multiple Choice Frage","description":"","type":"Question","properties":"{\r\n  \"question\": \"Was passiert, wenn du dich zu nah am Werkstück befindest?\",\r\n  \"shuffle\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"107\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 2,\r\n  \"minAnswers\": 2,\r\n  \"answersText\": [\r\n    \"Läufer und Verlaufsstörungen können entstehen\",\r\n    \"Du musst langsamer lackieren\",\r\n    \"Du musst schneller lackieren\",\r\n    \"Orangenhaut entsteht eher\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    true,\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 9,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 1,\r\n  \"audioId\": \"108\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (16, 'Eine Übung, in der ein simples Viereck lackiert werden soll. Dabei soll insbesondere auf die Distanz zum Werkstück geachtet werden. Der Distanzstrahl ist sichtbar, wird aber nach einigen Sekunden ausgeblendet.', 'Übung Neuteillackierung 2', true, '[{"name":"Werkstück zurücksetzen","description":"","type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 9,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"dry\"\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"idealer Abstand zum Werkstück: 15 - 20 cm \",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"109\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":"","type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackiere nun das Werkstück.\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"20\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 9,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": 1,\r\n  \"audioId\": \"110\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Evaluation","description":"","type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": false\r\n}"},{"name":"Einleitung/Überleitung","description":"","type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Höre dem Ausbildungsmeister zu.\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"112\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, NULL);
INSERT INTO task VALUES (17, 'Eine Einführung in die Nutzung von der VR-Lackierwerkstatt.', 'Tutorial', false, '[{"name":"Werkstück zurücksetzen","description":null,"type":"Reset Workpiece","properties":"{\r\n  \"type\": \"custom\",\r\n  \"workpieceId\": 2,\r\n  \"coatId\": -4,\r\n  \"coatCondition\": \"wet\"\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Die Lackierkabine\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"118\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Die Münzen\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"119\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Der Ausbildungsmeister\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"120\",\r\n  \"textSpeechBubble\": \"Hallo!\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Einleitung/Überleitung","description":null,"type":"Introduction","properties":"{\r\n  \"textMonitor\": \"Fortbewegung in der Lackierkabine\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"121\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Spritzprobe","description":null,"type":"Spray Test","properties":"{\r\n  \"textMonitor\": \"Die Spritzprobe\",\r\n  \"errorRate\": \"0\",\r\n  \"splittedSpray\": false,\r\n  \"excessiveMaterial\": false,\r\n  \"oneSidedCurved\": false,\r\n  \"oneSidedDisplaced\": false,\r\n  \"sShaped\": false,\r\n  \"flutteringSpray\": false,\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"123\",\r\n  \"coatId\": \"1\",\r\n  \"audioId\": \"122\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":null,"type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"117\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"124\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Unterstützende Informationen anzeigen","description":null,"type":"Supportive Information Summary","properties":"{\r\n  \"textMonitor\": \"\",\r\n  \"supportInfos\": [\r\n    {\r\n      \"name\": \"Bilder\",\r\n      \"description\": \"Zeigt ein Bild oder mehrere Bilder auf dem Monitor an.\",\r\n      \"type\": \"Images\",\r\n      \"properties\": \"{\\r\\n  \\\"images\\\": [\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"114\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"115\\\"\\r\\n    },\\r\\n    {\\r\\n      \\\"imageId\\\": \\\"116\\\"\\r\\n    }\\r\\n  ]\\r\\n}\"\r\n    }\r\n  ],\r\n  \"minSupportInfos\": \"1\",\r\n  \"sequence\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"125\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Single/Multiple Choice Frage","description":null,"type":"Question","properties":"{\r\n  \"question\": \"Mit welcher Münze kannst du zum nächsten Teilschritt wechseln?\",\r\n  \"shuffle\": false,\r\n  \"skippable\": 0,\r\n  \"finalAudioId\": \"127\",\r\n  \"audioId\": \"126\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true,\r\n  \"maxAnswers\": 3,\r\n  \"minAnswers\": 1,\r\n  \"answersText\": [\r\n    \"rote Münze\",\r\n    \"grüne Münze\",\r\n    \"goldene Münze\"\r\n  ],\r\n  \"answersCorrect\": [\r\n    false,\r\n    true,\r\n    false\r\n  ]\r\n}"},{"name":"Schätzaufgabe","description":null,"type":"Estimation","properties":"{\r\n  \"textMonitor\": \"Was ist die optimale Temperatur in der Lackierkabine?\",\r\n  \"minimum\": \"19\",\r\n  \"maximum\": \"23\",\r\n  \"skippable\": 0,\r\n  \"interactiveObject\": \"thermometer\",\r\n  \"finalAudioId\": \"129\",\r\n  \"audioId\": \"128\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":null,"type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Lackierständer einstellen\",\r\n  \"distanceRay\": false,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": false,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"0\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": \"1\",\r\n  \"audioId\": \"130\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Werkstück lackieren","description":null,"type":"Paint Workpiece","properties":"{\r\n  \"textMonitor\": \"Hilfestellungen beim Lackieren\",\r\n  \"distanceRay\": true,\r\n  \"distanceMarker\": false,\r\n  \"angleRay\": false,\r\n  \"optionDistanceRay\": true,\r\n  \"optionDistanceMarker\": false,\r\n  \"optionAngleRay\": false,\r\n  \"minSprayTime\": \"5\",\r\n  \"helpDuration\": \"\",\r\n  \"skippable\": 0,\r\n  \"workpieceId\": 2,\r\n  \"baseCoatId\": -3,\r\n  \"coatId\": \"1\",\r\n  \"audioId\": \"131\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Auswertung","description":null,"type":"Evaluation","properties":"{\r\n  \"heatMap\": true,\r\n  \"correctDistance\": true,\r\n  \"correctAngle\": true,\r\n  \"colorConsumption\": true,\r\n  \"colorWastage\": true,\r\n  \"colorUsage\": true,\r\n  \"fullyPressed\": true,\r\n  \"averageSpeed\": true,\r\n  \"coatThickness\": true,\r\n  \"skippable\": 0,\r\n  \"audioId\": \"132\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"},{"name":"Selbsteinschätzung","description":null,"type":"Self Assessment","properties":"{\r\n  \"textMonitor\": \"Eigene Leistung bewerten\",\r\n  \"skippable\": 0,\r\n  \"audioId\": \"133\",\r\n  \"textSpeechBubble\": \"\",\r\n  \"automaticAudio\": true\r\n}"}]', 'NewPartPainting', false, null);

ALTER SEQUENCE task_id_seq RESTART WITH 18;


INSERT INTO task_collection VALUES (2, 'Lernpfad der Aufgabenklasse Neuteillackierung', 'Neuteillackierung I', 'NewPartPainting', NULL);
ALTER SEQUENCE task_collection_id_seq RESTART WITH 3;


INSERT INTO task_collection_element VALUES (3, 1, true, 14, 2);
INSERT INTO task_collection_element VALUES (4, 2, true, 15, 2);
INSERT INTO task_collection_element VALUES (5, 3, true, 4, 2);
INSERT INTO task_collection_element VALUES (6, 4, true, 16, 2);
INSERT INTO task_collection_element VALUES (7, 5, true, 12, 2);
ALTER SEQUENCE task_collection_element_id_seq RESTART WITH 8;


INSERT INTO task_used_coats VALUES (3, 3);
INSERT INTO task_used_coats VALUES (4, 3);
INSERT INTO task_used_coats VALUES (11, 1);
INSERT INTO task_used_coats VALUES (12, 5);
INSERT INTO task_used_coats VALUES (12, 6);
INSERT INTO task_used_coats VALUES (12, 7);
INSERT INTO task_used_coats VALUES (12, 8);
INSERT INTO task_used_coats VALUES (14, 6);
INSERT INTO task_used_coats VALUES (15, 1);
INSERT INTO task_used_coats VALUES (16, 1);
INSERT INTO task_used_coats VALUES (17, 1);


INSERT INTO task_used_media VALUES (3, 86);
INSERT INTO task_used_media VALUES (3, 87);
INSERT INTO task_used_media VALUES (3, 88);
INSERT INTO task_used_media VALUES (3, 89);
INSERT INTO task_used_media VALUES (3, 90);
INSERT INTO task_used_media VALUES (3, 91);
INSERT INTO task_used_media VALUES (3, 92);
INSERT INTO task_used_media VALUES (3, 93);
INSERT INTO task_used_media VALUES (3, 94);
INSERT INTO task_used_media VALUES (3, 95);
INSERT INTO task_used_media VALUES (3, 96);
INSERT INTO task_used_media VALUES (3, 97);
INSERT INTO task_used_media VALUES (3, 98);
INSERT INTO task_used_media VALUES (3, 99);
INSERT INTO task_used_media VALUES (3, 100);
INSERT INTO task_used_media VALUES (3, 101);
INSERT INTO task_used_media VALUES (4, 75);
INSERT INTO task_used_media VALUES (4, 76);
INSERT INTO task_used_media VALUES (4, 77);
INSERT INTO task_used_media VALUES (4, 78);
INSERT INTO task_used_media VALUES (4, 79);
INSERT INTO task_used_media VALUES (4, 80);
INSERT INTO task_used_media VALUES (4, 81);
INSERT INTO task_used_media VALUES (4, 82);
INSERT INTO task_used_media VALUES (4, 83);
INSERT INTO task_used_media VALUES (4, 84);
INSERT INTO task_used_media VALUES (4, 85);
INSERT INTO task_used_media VALUES (4, 86);
INSERT INTO task_used_media VALUES (4, 87);
INSERT INTO task_used_media VALUES (4, 88);
INSERT INTO task_used_media VALUES (4, 89);
INSERT INTO task_used_media VALUES (4, 90);
INSERT INTO task_used_media VALUES (4, 91);
INSERT INTO task_used_media VALUES (4, 92);
INSERT INTO task_used_media VALUES (11, 102);
INSERT INTO task_used_media VALUES (11, 103);
INSERT INTO task_used_media VALUES (11, 104);
INSERT INTO task_used_media VALUES (12, 21);
INSERT INTO task_used_media VALUES (12, 22);
INSERT INTO task_used_media VALUES (12, 23);
INSERT INTO task_used_media VALUES (12, 24);
INSERT INTO task_used_media VALUES (12, 26);
INSERT INTO task_used_media VALUES (12, 27);
INSERT INTO task_used_media VALUES (12, 28);
INSERT INTO task_used_media VALUES (12, 29);
INSERT INTO task_used_media VALUES (12, 30);
INSERT INTO task_used_media VALUES (12, 31);
INSERT INTO task_used_media VALUES (12, 32);
INSERT INTO task_used_media VALUES (12, 33);
INSERT INTO task_used_media VALUES (12, 38);
INSERT INTO task_used_media VALUES (12, 39);
INSERT INTO task_used_media VALUES (12, 40);
INSERT INTO task_used_media VALUES (12, 41);
INSERT INTO task_used_media VALUES (12, 42);
INSERT INTO task_used_media VALUES (12, 43);
INSERT INTO task_used_media VALUES (12, 44);
INSERT INTO task_used_media VALUES (12, 45);
INSERT INTO task_used_media VALUES (12, 46);
INSERT INTO task_used_media VALUES (12, 47);
INSERT INTO task_used_media VALUES (12, 48);
INSERT INTO task_used_media VALUES (12, 49);
INSERT INTO task_used_media VALUES (12, 50);
INSERT INTO task_used_media VALUES (12, 51);
INSERT INTO task_used_media VALUES (12, 52);
INSERT INTO task_used_media VALUES (12, 53);
INSERT INTO task_used_media VALUES (12, 54);
INSERT INTO task_used_media VALUES (12, 55);
INSERT INTO task_used_media VALUES (12, 56);
INSERT INTO task_used_media VALUES (12, 57);
INSERT INTO task_used_media VALUES (12, 58);
INSERT INTO task_used_media VALUES (12, 59);
INSERT INTO task_used_media VALUES (12, 113);
INSERT INTO task_used_media VALUES (14, 60);
INSERT INTO task_used_media VALUES (14, 61);
INSERT INTO task_used_media VALUES (14, 62);
INSERT INTO task_used_media VALUES (14, 63);
INSERT INTO task_used_media VALUES (14, 64);
INSERT INTO task_used_media VALUES (14, 65);
INSERT INTO task_used_media VALUES (14, 66);
INSERT INTO task_used_media VALUES (14, 67);
INSERT INTO task_used_media VALUES (14, 68);
INSERT INTO task_used_media VALUES (14, 69);
INSERT INTO task_used_media VALUES (14, 70);
INSERT INTO task_used_media VALUES (14, 71);
INSERT INTO task_used_media VALUES (14, 72);
INSERT INTO task_used_media VALUES (14, 73);
INSERT INTO task_used_media VALUES (15, 105);
INSERT INTO task_used_media VALUES (15, 106);
INSERT INTO task_used_media VALUES (15, 107);
INSERT INTO task_used_media VALUES (15, 108);
INSERT INTO task_used_media VALUES (16, 109);
INSERT INTO task_used_media VALUES (16, 110);
INSERT INTO task_used_media VALUES (16, 112);
INSERT INTO task_used_media VALUES (17, 114);
INSERT INTO task_used_media VALUES (17, 115);
INSERT INTO task_used_media VALUES (17, 116);
INSERT INTO task_used_media VALUES (17, 117);
INSERT INTO task_used_media VALUES (17, 118);
INSERT INTO task_used_media VALUES (17, 119);
INSERT INTO task_used_media VALUES (17, 120);
INSERT INTO task_used_media VALUES (17, 121);
INSERT INTO task_used_media VALUES (17, 122);
INSERT INTO task_used_media VALUES (17, 123);
INSERT INTO task_used_media VALUES (17, 124);
INSERT INTO task_used_media VALUES (17, 125);
INSERT INTO task_used_media VALUES (17, 126);
INSERT INTO task_used_media VALUES (17, 127);
INSERT INTO task_used_media VALUES (17, 128);
INSERT INTO task_used_media VALUES (17, 129);
INSERT INTO task_used_media VALUES (17, 130);
INSERT INTO task_used_media VALUES (17, 131);
INSERT INTO task_used_media VALUES (17, 132);
INSERT INTO task_used_media VALUES (17, 133);


INSERT INTO task_used_recordings VALUES (3, 1);
INSERT INTO task_used_recordings VALUES (4, 1);
INSERT INTO task_used_recordings VALUES (12, 3);
INSERT INTO task_used_recordings VALUES (12, 4);
INSERT INTO task_used_recordings VALUES (14, 2);


INSERT INTO task_used_workpieces VALUES (3, 2);
INSERT INTO task_used_workpieces VALUES (4, 2);
INSERT INTO task_used_workpieces VALUES (11, 9);
INSERT INTO task_used_workpieces VALUES (12, 5);
INSERT INTO task_used_workpieces VALUES (14, 3);
INSERT INTO task_used_workpieces VALUES (15, 9);
INSERT INTO task_used_workpieces VALUES (16, 9);
INSERT INTO task_used_workpieces VALUES (17, 2);