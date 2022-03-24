/*
DROP TABLE Platba;
DROP TABLE Objednavka_obsahuje_pokrm_napoj;
DROP TABLE Objednavka;
DROP TABLE Rezervace_stolu;
DROP TABLE Rezervace;
DROP TABLE Ingredience_v_pokrmu_napoji;
DROP TABLE Napoj;
DROP TABLE Pokrm;
DROP TABLE Ingredience_obsahuje_alergen;
DROP TABLE Alergen;
DROP TABLE Ingredience;
DROP TABLE Telefon;
DROP TABLE Zamestnanec;
DROP TABLE Pozice;
DROP TABLE Zakaznik;
DROP TABLE Stul;
DROP TABLE Mistnost;
*/

CREATE TABLE Mistnost (
    cislo_mistnosti     NUMERIC(7, 0)   NOT NULL,
    nazev               varchar(255),
    kapacita            smallint        CHECK(kapacita>0),
    CONSTRAINT PK_mistnost PRIMARY KEY (cislo_mistnosti)
);

CREATE TABLE Stul (
    cislo_stolu       NUMERIC(7, 0)   NOT NULL,
    cislo_mistnosti   NUMERIC(7, 0)   NOT NULL,
    pocet_mist        smallint        NOT NULL,
    CONSTRAINT PK_stul          PRIMARY KEY (cislo_stolu),
    CONSTRAINT FK_stul_mistnost FOREIGN KEY (cislo_mistnosti) REFERENCES Mistnost
);

CREATE TABLE Zakaznik (
    ID_zakaznik     NUMERIC(7, 0) NOT NULL,
    jmeno           varchar(32)   NOT NULL,
    prijmeni        varchar(32)   NOT NULL,
    telefon         varchar(32)   NOT NULL,
    email           varchar(64),
    CONSTRAINT PK_zakaznik PRIMARY KEY (ID_zakaznik)
);

CREATE TABLE Pozice (
    zkratka_pozice NUMERIC(7, 0)   NOT NULL,
    nazev_pozice   varchar(255)    NOT NULL, 
    CONSTRAINT PK_pozice PRIMARY KEY (zkratka_pozice)
);

CREATE TABLE Zamestnanec (
    ID_zamestnanec  NUMERIC(7, 0)  NOT NULL,
    zkratka_pozice  NUMERIC(7, 0)  NOT NULL,
    jmeno           varchar(32)    NOT NULL,
    prijmeni        varchar(32)    NOT NULL,
    rodne_cislo     varchar(32)    NOT NULL,
    bankovni_ucet   varchar(64)    NOT NULL,
    adresa          varchar(255)   NOT NULL,
    CONSTRAINT PK_zamestnanec PRIMARY KEY (ID_zamestnanec),
    CONSTRAINT FK_pozice      FOREIGN KEY (zkratka_pozice) REFERENCES Pozice,
    CONSTRAINT FK_telefon     FOREIGN KEY (telefon)        REFERENCES Telefon
);

CREATE TABLE Telefon (
    poradove_cislo  NUMERIC(7, 0) NOT NULL,
    ID_zamestnanec  NUMERIC(7, 0) NOT NULL,
    telefon         varchar(32)   NOT NULL,
    CONSTRAINT PK_telefon         PRIMARY KEY (poradove_cislo),
    CONSTRAINT FK_tel_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec
);

CREATE TABLE Ingredience (
    ID_ingredience  NUMERIC(7, 0) NOT NULL,
    nazev           varchar(255)  NOT NULL,
    CONSTRAINT PK_ingredience PRIMARY KEY (ID_ingredience)
);

CREATE TABLE Alergen (
    ID_alergen      NUMERIC(7, 0) NOT NULL,
    nazev           varchar(255)  NOT NULL,
    CONSTRAINT PK_alergen PRIMARY KEY (ID_alergen)
);

CREATE TABLE Ingredience_obsahuje_alergen (
    ID_ingredience  NUMERIC(7, 0) NOT NULL,
    ID_alergen      NUMERIC(7, 0) NOT NULL,
    CONSTRAINT FK_inal_ingredience FOREIGN KEY (ID_ingredience) REFERENCES Ingredience,
    CONSTRAINT FK_inal_alergen     FOREIGN KEY (ID_alergen)     REFERENCES Alergen
);

CREATE TABLE Pokrm (
    ID_pokrm_napoj  NUMERIC(7, 0) NOT NULL,
    doba_pripravy   varchar(255)  ,
    hmotnost_gram   int           NOT NULL,
    CONSTRAINT PK_pok_pokrm_napoj PRIMARY KEY (ID_pokrm_napoj)
);

CREATE TABLE Napoj (
    ID_pokrm_napoj  NUMERIC(7, 0) NOT NULL,
    obsah_alkoholu  NUMERIC(5, 4) NOT NULL,
    objem_ml        int           NOT NULL ,
    CONSTRAINT PK_nap_pokrm_napoj PRIMARY KEY (ID_pokrm_napoj)
);

CREATE TABLE Ingredience_v_pokrmu_napoji (
    ID_pokrm_napoj  NUMERIC(7, 0) NOT NULL,
    ID_ingredience  NUMERIC(7, 0) NOT NULL,
    nazev           varchar(255)  NOT NULL,
    CONSTRAINT FK_invpn_pokrm       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Pokrm,
    CONSTRAINT FK_invpn_napoj       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Napoj,
    CONSTRAINT FK_invpn_ingredience FOREIGN KEY (ID_ingredience) REFERENCES Ingredience
);

CREATE TABLE Rezervace (
    ID_rezervace        NUMERIC(7, 0) NOT NULL,
    ID_zamestnanec      NUMERIC(7, 0) NOT NULL,
    ID_zakaznik         NUMERIC(7, 0) NOT NULL,
    datum_cas_rezervace TIMESTAMP     NOT NULL,
    datum_vytvoreni     DATE          NOT NULL,
    CONSTRAINT PK_rezervace       PRIMARY KEY (ID_rezervace),
    CONSTRAINT FK_rez_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec,
    CONSTRAINT FK_rez_zakaznik    FOREIGN KEY (ID_zakaznik)    REFERENCES Zakaznik
);

CREATE TABLE Rezervace_stolu (
    cislo_stolu  NUMERIC(7, 0)  NOT NULL,
    ID_rezervace NUMERIC(7, 0)  NOT NULL,
    CONSTRAINT FK_rezstolu_stul      FOREIGN KEY (cislo_stolu)  REFERENCES Stul,
    CONSTRAINT FK_rezstolu_rezervace FOREIGN KEY (ID_rezervace) REFERENCES Rezervace
);

CREATE TABLE Objednavka (
    ID_objednavka       NUMERIC(7, 0)  NOT NULL,
    ID_rezervace        NUMERIC(7, 0)  NOT NULL,
    ID_zamestnanec      NUMERIC(7, 0)  NOT NULL,
    ID_zakaznik         NUMERIC(7, 0)  NOT NULL,
    datum_vytvoreni     DATE           NOT NULL,
    celkova_cena        int            NOT NULL ,
    CONSTRAINT PK_objednavka      PRIMARY KEY (ID_objednavka),
    CONSTRAINT FK_obj_rezervace   FOREIGN KEY (ID_rezervace)   REFERENCES Rezervace,
    CONSTRAINT FK_obj_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec,
    CONSTRAINT FK_obj_zakaznik    FOREIGN KEY (ID_zakaznik)    REFERENCES Zakaznik
);

CREATE TABLE Objednavka_obsahuje_pokrm_napoj (
    ID_pokrm_napoj NUMERIC(7, 0)    NOT NULL,
    ID_objednavka  NUMERIC(7, 0)    NOT NULL,
    CONSTRAINT FK_objpn_pokrm       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Pokrm,
    CONSTRAINT FK_objpn_napoj       FOREIGN KEY (ID_pokrm_napoj) REFERENCES Napoj,
    CONSTRAINT FK_objpn_objednavka  FOREIGN KEY (ID_objednavka)  REFERENCES Objednavka
);

CREATE TABLE Platba (
    ID_platba       NUMERIC(7, 0) NOT NULL,
    ID_zamestnanec  NUMERIC(7, 0) NOT NULL,
    ID_objednavka   NUMERIC(7, 0) NOT NULL,
    castka          int           NOT NULL,
    datum_a_cas     TIMESTAMP     NOT NULL,
    typ_platby      varchar(64)   NOT NULL,
    CONSTRAINT PK_platba           PRIMARY KEY (ID_platba),
    CONSTRAINT FK_plat_zamestnanec FOREIGN KEY (ID_zamestnanec) REFERENCES Zamestnanec,
    CONSTRAINT FK_plat_objednavka  FOREIGN KEY (ID_objednavka)  REFERENCES Objednavka
);
