/* DROP EXISTING TABLES */ /* TODO try IF EXISTS AGAIN */
DROP TABLE Platba CASCADE CONSTRAINTS;
DROP TABLE Objednavka_obsahuje_pokrm_napoj CASCADE CONSTRAINTS;
DROP TABLE Objednavka CASCADE CONSTRAINTS;
DROP TABLE Rezervace_stolu CASCADE CONSTRAINTS;
DROP TABLE Rezervace CASCADE CONSTRAINTS;
DROP TABLE Ingredience_v_pokrmu_napoji CASCADE CONSTRAINTS;
DROP TABLE Napoj CASCADE CONSTRAINTS;
DROP TABLE Pokrm CASCADE CONSTRAINTS;
DROP TABLE Ingredience_obsahuje_alergen CASCADE CONSTRAINTS;
DROP TABLE Alergen CASCADE CONSTRAINTS;
DROP TABLE Ingredience CASCADE CONSTRAINTS;
DROP TABLE Telefon CASCADE CONSTRAINTS;
DROP TABLE Zamestnanec CASCADE CONSTRAINTS;
DROP TABLE Pozice CASCADE CONSTRAINTS;
DROP TABLE Zakaznik CASCADE CONSTRAINTS;
DROP TABLE Stul CASCADE CONSTRAINTS;
DROP TABLE Mistnost CASCADE CONSTRAINTS;


/* CREATE EMPTY TABLES */
CREATE TABLE Mistnost (
    cislo_mistnosti     NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    nazev               varchar(255),
    kapacita            smallint        CHECK(kapacita>0),
    CONSTRAINT PK_mistnost PRIMARY KEY (cislo_mistnosti)
);

CREATE TABLE Stul (
    cislo_stolu       NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    cislo_mistnosti   INT NOT NULL,
    pocet_mist        SMALLINT,
    CONSTRAINT PK_stul          PRIMARY KEY (cislo_stolu),
    CONSTRAINT FK_stul_mistnost FOREIGN KEY (cislo_mistnosti) REFERENCES Mistnost
);

CREATE TABLE Zakaznik (
    ID_zakaznik     NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    jmeno           varchar(32)   NOT NULL,
    prijmeni        varchar(32)   NOT NULL,
    telefon         varchar(32)   NOT NULL, /* TODO omezeni */
    email           varchar(64),    /* TODO omezeni */
    CONSTRAINT PK_zakaznik PRIMARY KEY (ID_zakaznik)
);

CREATE TABLE Pozice (
    zkratka_pozice varchar(32),
    nazev_pozice   varchar(255)    NOT NULL,
    CONSTRAINT PK_pozice PRIMARY KEY (zkratka_pozice)
);

CREATE TABLE Zamestnanec (
    ID_zamestnanec  NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    zkratka_pozice  varchar(32)    NOT NULL,
    jmeno           varchar(32)    NOT NULL,
    prijmeni        varchar(32)    NOT NULL,
    rodne_cislo     varchar(32)    NOT NULL,    /* TODO add CHECK */
    bankovni_ucet   varchar(64)    NOT NULL,    /* TODO add CHECK */
    adresa          varchar(255)   NOT NULL,
    CONSTRAINT PK_zamestnanec PRIMARY KEY (ID_zamestnanec),
    CONSTRAINT FK_pozice      FOREIGN KEY (zkratka_pozice) REFERENCES Pozice
);

CREATE TABLE Telefon (
    poradove_cislo  NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    ID_zamestnanec  NUMBER NOT NULL,
    telefon         varchar(32)   NOT NULL,
    CONSTRAINT PK_telefon         PRIMARY KEY (poradove_cislo),
    CONSTRAINT FK_tel_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec
);

CREATE TABLE Ingredience (
    ID_ingredience  NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    nazev           varchar(255)  NOT NULL,
    CONSTRAINT PK_ingredience PRIMARY KEY (ID_ingredience)
);

CREATE TABLE Alergen (
    ID_alergen      NUMERIC(2, 0),
    nazev           varchar(255)  NOT NULL,
    CONSTRAINT PK_alergen PRIMARY KEY (ID_alergen)
);

CREATE TABLE Ingredience_obsahuje_alergen (
    ID_ingredience  NUMBER NOT NULL,
    ID_alergen      NUMBER NOT NULL,
    CONSTRAINT FK_inal_ingredience FOREIGN KEY (ID_ingredience) REFERENCES Ingredience,
    CONSTRAINT FK_inal_alergen     FOREIGN KEY (ID_alergen)     REFERENCES Alergen
);

/* TODO vyresit Pokrm a Napoj ID */
CREATE TABLE Pokrm (
    ID_pokrm_napoj  NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    nazev           VARCHAR(255),
    doba_pripravy   VARCHAR(32),
    hmotnost_gram   INT,
    cena            INT NOT NULL,
    CONSTRAINT PK_pok_pokrm_napoj PRIMARY KEY (ID_pokrm_napoj)
);

CREATE TABLE Napoj (
    ID_pokrm_napoj  NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    nazev           VARCHAR(64) NOT NULL,
    obsah_alkoholu  NUMERIC(5, 4) NOT NULL,
    objem_ml        INT,
    cena            INT NOT NULL,
    CONSTRAINT PK_nap_pokrm_napoj PRIMARY KEY (ID_pokrm_napoj)
);

/* TODO poresit pokrm_napoj unique IDs */
CREATE TABLE Ingredience_v_pokrmu_napoji (
    ID_pokrm_napoj  NUMBER NOT NULL,
    ID_ingredience  NUMBER NOT NULL,
    /* nazev           VARCHAR(255)  NOT NULL, */
    CONSTRAINT FK_invpn_pokrm       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Pokrm,
    CONSTRAINT FK_invpn_napoj       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Napoj,
    CONSTRAINT FK_invpn_ingredience FOREIGN KEY (ID_ingredience) REFERENCES Ingredience
);

CREATE TABLE Rezervace (
    ID_rezervace        NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    ID_zamestnanec      NUMBER NOT NULL,
    ID_zakaznik         NUMBER NOT NULL,
    datum_cas_rezervace TIMESTAMP     NOT NULL,
    datum_vytvoreni     DATE          NOT NULL,
    CONSTRAINT PK_rezervace       PRIMARY KEY (ID_rezervace),
    CONSTRAINT FK_rez_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec,
    CONSTRAINT FK_rez_zakaznik    FOREIGN KEY (ID_zakaznik)    REFERENCES Zakaznik
);

CREATE TABLE Rezervace_stolu (
    cislo_stolu  NUMBER  NOT NULL,
    ID_rezervace NUMBER  NOT NULL,
    CONSTRAINT FK_rezstolu_stul      FOREIGN KEY (cislo_stolu)  REFERENCES Stul,
    CONSTRAINT FK_rezstolu_rezervace FOREIGN KEY (ID_rezervace) REFERENCES Rezervace
);

CREATE TABLE Objednavka (
    ID_objednavka       NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    ID_rezervace        NUMBER,
    ID_zamestnanec      NUMBER  NOT NULL,
    ID_zakaznik         NUMBER  NOT NULL,
    datum_vytvoreni     DATE           NOT NULL,
    celkova_cena        INT            NOT NULL ,       /* TODO VYPOCET nebo lepe odstranit tohle - da se vypocitat */
    CONSTRAINT PK_objednavka      PRIMARY KEY (ID_objednavka),
    CONSTRAINT FK_obj_rezervace   FOREIGN KEY (ID_rezervace)   REFERENCES Rezervace,
    CONSTRAINT FK_obj_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec,
    CONSTRAINT FK_obj_zakaznik    FOREIGN KEY (ID_zakaznik)    REFERENCES Zakaznik
);

CREATE TABLE Objednavka_obsahuje_pokrm_napoj (
    ID_pokrm_napoj NUMBER    NOT NULL,
    ID_objednavka  NUMBER    NOT NULL,
    pocet          NUMBER    NOT NULL, /* TODO check, DEFAULT = 1 */
    CONSTRAINT FK_objpn_pokrm       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Pokrm,
    CONSTRAINT FK_objpn_napoj       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Napoj,
    CONSTRAINT FK_objpn_objednavka  FOREIGN KEY (ID_objednavka)  REFERENCES Objednavka
);

CREATE TABLE Platba (
    ID_platba       NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    ID_zamestnanec  NUMBER NOT NULL,
    ID_objednavka   NUMBER NOT NULL,
    castka          INT           NOT NULL,     /* TODO check jestli by to melo sedet s celkovou cenou za objednavky - udelat omezeni, CHECK */
    datum_a_cas     TIMESTAMP     NOT NULL,
    typ_platby      VARCHAR(64)   NOT NULL,     /* TODO ciselnik pro typy plateb? */
    CONSTRAINT PK_platba           PRIMARY KEY (ID_platba),
    CONSTRAINT FK_plat_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec,
    CONSTRAINT FK_plat_objednavka  FOREIGN KEY (ID_objednavka)  REFERENCES Objednavka
);


/* INSERT VALUES */
INSERT INTO Mistnost
VALUES (DEFAULT, 'Hlavni sal', 60);
INSERT INTO Mistnost
VALUES (DEFAULT, 'Maly salonek - 1. patro', 30);
INSERT INTO Mistnost
VALUES (DEFAULT, 'Snidane', 20);

INSERT INTO Stul
VALUES (DEFAULT, 1, '4');
INSERT INTO Stul
VALUES (DEFAULT, 1, '4');
INSERT INTO Stul
VALUES (DEFAULT, 1, '6');
INSERT INTO Stul
VALUES (DEFAULT, 2, '2');
INSERT INTO Stul
VALUES (DEFAULT, 2, '4');
INSERT INTO Stul
VALUES (DEFAULT, 3, '10');

INSERT INTO Zakaznik
VALUES(DEFAULT, 'Jan', 'Novák', '746358074', 'novak12@gmail.com');
INSERT INTO Zakaznik
VALUES(DEFAULT, 'Marie', 'Mrtvá', '743689432', 'maruskaaa@centrum.cz');
INSERT INTO Zakaznik
VALUES(DEFAULT, 'Martina', 'Březová', '765467897', 'martina.brezova@seznam.cz');
INSERT INTO Zakaznik
VALUES(DEFAULT, 'Tomáš', 'Suchý', '777456654', 'tom.suchy1@gmail.com');

INSERT INTO Pozice
VALUES('cis', 'číšník');
INSERT INTO Pozice
VALUES('kuch', 'kuchař');
INSERT INTO Pozice
VALUES('rec', 'recepční');

INSERT INTO Zamestnanec
VALUES (DEFAULT, 'cis', 'Luboš', 'Veverka', '670421/7795', '1234567944', 'Újezdská 6/17, 91881 Rosice');
INSERT INTO Zamestnanec
VALUES (DEFAULT, 'kuch', 'Josef', 'Franek', '870213/9985', '4567877295', 'K Březince 3/756, 60200 Brno');
INSERT INTO Zamestnanec
VALUES (DEFAULT, 'cis', 'Sabina', 'Antošová', '935314/8805', '5684877125', 'Jenská 15, 327 33 Ostrava');
INSERT INTO Zamestnanec
VALUES (DEFAULT, 'rec', 'Michaela', 'Kárová', '866001/0656', '3576536522', 'Klatovská 39/269, 61300 Brno');

INSERT INTO Telefon
VALUES (DEFAULT, 1, '746358074');
INSERT INTO Telefon
VALUES (DEFAULT, 1, '776875633');
INSERT INTO Telefon
VALUES (DEFAULT, 2, '733725392');
INSERT INTO Telefon
VALUES (DEFAULT, 3, '628342805');

INSERT INTO Ingredience
VALUES (DEFAULT, 'vejce');
INSERT INTO Ingredience
VALUES (DEFAULT, 'plnotučné mléko');
INSERT INTO Ingredience
VALUES (DEFAULT, 'kuřecí prsa');
INSERT INTO Ingredience
VALUES (DEFAULT, 'hovězí bok');
INSERT INTO Ingredience
VALUES (DEFAULT, 'mouka pšeničná hladká');

INSERT INTO Alergen
VALUES (1, 'OBILOVINY OBSAHUJÍCÍ LEPEK');
INSERT INTO Alergen
VALUES (2, 'KORÝŠI');
INSERT INTO Alergen
VALUES (3, 'VEJCE');
INSERT INTO Alergen
VALUES (4, 'RYBY');

INSERT INTO Ingredience_obsahuje_alergen
VALUES (1, 3);
INSERT INTO Ingredience_obsahuje_alergen
VALUES (5, 1);

INSERT INTO Pokrm
VALUES (DEFAULT, 'Kuřátko supreme s jasmínovou rýží, restovaným cukrovým hráškem a baby karotkou na sezamovém oleji', '35 minut', 200, 268);
INSERT INTO Pokrm
VALUES (DEFAULT, 'Cheesecake z bílé čokolády', '5 minut', NULL, 129);

INSERT INTO Napoj
VALUES (DEFAULT, 'Domácí limonáda', 0, 400, 65);
INSERT INTO Napoj
VALUES (DEFAULT, 'Espresso', 0, NULL, 46);

INSERT INTO Ingredience_v_pokrmu_napoji
VALUES (1, 3);
INSERT INTO Ingredience_v_pokrmu_napoji
VALUES (2, 5);
INSERT INTO Ingredience_v_pokrmu_napoji
VALUES (2, 1);

/* TODO dat nejake rozumne casy */
INSERT INTO Rezervace
VALUES (DEFAULT, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Rezervace
VALUES (DEFAULT, 1, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO Rezervace
VALUES (DEFAULT, 3, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Rezervace_stolu
VALUES (2, 2);
INSERT INTO Rezervace_stolu
VALUES (1, 2);

INSERT INTO Objednavka
VALUES (DEFAULT, 1, 1, 1, CURRENT_TIMESTAMP, 457);
INSERT INTO Objednavka
VALUES (DEFAULT, 1, 1, 2, CURRENT_TIMESTAMP, 123);
INSERT INTO Objednavka
VALUES (DEFAULT, NULL, 3, 4, CURRENT_TIMESTAMP, 99);

INSERT INTO Objednavka_obsahuje_pokrm_napoj
VALUES (2, 1, 1);
INSERT INTO Objednavka_obsahuje_pokrm_napoj
VALUES (2, 1, 4);
INSERT INTO Objednavka_obsahuje_pokrm_napoj
VALUES (2, 2, 1);
INSERT INTO Objednavka_obsahuje_pokrm_napoj
VALUES (1, 3, 2);

INSERT INTO Platba
VALUES (DEFAULT, 1, 1, 775, CURRENT_TIMESTAMP, 'platební karta');
INSERT INTO Platba
VALUES (DEFAULT, 1, 1, 35, CURRENT_TIMESTAMP, 'platební karta');
INSERT INTO Platba
VALUES (DEFAULT, 2, 3, 256, CURRENT_TIMESTAMP, 'hotovost');


/* SHOW THE TABLES */
SELECT * FROM Mistnost;
SELECT * FROM Stul;
SELECT * FROM Zakaznik;
SELECT * FROM Pozice;
SELECT * FROM Zamestnanec;
SELECT * FROM Telefon;
SELECT * FROM Ingredience;
SELECT * FROM Alergen;
SELECT * FROM Ingredience_obsahuje_alergen;
SELECT * FROM Napoj;
SELECT * FROM Pokrm;
SELECT * FROM Ingredience_v_pokrmu_napoji;
SELECT * FROM Rezervace;
SELECT * FROM Rezervace_stolu;
SELECT * FROM Objednavka;
SELECT * FROM Objednavka_obsahuje_pokrm_napoj;
SELECT * FROM Platba;
