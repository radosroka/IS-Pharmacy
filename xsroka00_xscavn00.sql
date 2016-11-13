DROP TABLE Liek CASCADE CONSTRAINTS;
/
DROP TABLE Dodavatel CASCADE CONSTRAINTS;
/
DROP TABLE Predane CASCADE CONSTRAINTS;
/
DROP TABLE Fakt_udaje CASCADE CONSTRAINTS;
/
DROP TABLE Poistovna CASCADE CONSTRAINTS;
/
DROP TABLE Zamestnanec CASCADE CONSTRAINTS;
/
DROP TABLE Pobocka CASCADE CONSTRAINTS;
/
DROP TABLE Sklad CASCADE CONSTRAINTS;
/
DROP TABLE Rezervacia CASCADE CONSTRAINTS;
/
DROP TABLE Objednavka CASCADE CONSTRAINTS;
/
DROP TABLE Rezervacie_v_sklade CASCADE CONSTRAINTS;
/
DROP MATERIALIZED VIEW predaneVKosiciach;
/
CREATE TABLE Liek(
    id_sukl char(6) NOT NULL,
    nazov varchar(1024) NOT NULL,
    vyrobca varchar(1024) NOT NULL,
    dodavatel int NOT NULL,
    cena int NOT NULL,
    na_predpis int
);/
CREATE TABLE Dodavatel(
  id_dodavatel int GENERATED ALWAYS AS IDENTITY,
  nazov varchar(1024) NOT NULL UNIQUE,
  sidlo varchar(1024) NOT NULL,
  tel_c char(13) NOT NULL,
  email varchar(255) NOT NULL,
  constraint tel_c_check CHECK(REGEXP_LIKE(tel_c, '\+\d{12}')),
  constraint email_check CHECK(REGEXP_LIKE(email, '.+?@.+?\..+'))
);/
CREATE TABLE Predane(
  id_predaja int GENERATED ALWAYS AS IDENTITY,
  pobocka int NOT NULL,
  mnozstvo int NOT NULL,
  liek char(6) NOT NULL
);/
CREATE TABLE Fakt_udaje(
  id_fakt int GENERATED ALWAYS AS IDENTITY,
  id_predaj int NOT NULL,
  poistovna  int NOT NULL,
  rodne_cislo varchar2(11),
  ico varchar2(8),  
  CONSTRAINT  check_rodne_cislo1 CHECK((REGEXP_LIKE(rodne_cislo, '[0-9][0-9][0-3,5-8][0-9][0,1,2,3][0-9]\/[0-9][0-9][0-9][0-9]?'))),-- AND ico = NULL),
  CONSTRAINT  check_rodne_cislo2 CHECK(((LENGTH(rodne_cislo) = 11 AND MOD(REGEXP_REPLACE(rodne_cislo,'\/',''),11) = 0) OR (LENGTH(rodne_cislo) = 10))), --AND ico = NULL),
  CONSTRAINT  check_ico          CHECK((REGEXP_LIKE (ico,'^([0-9]{8}|[0-9]{6}$)'))),-- AND rodne_cislo = NULL),
  CONSTRAINT  check_             CHECK(((ico = NULL) AND (rodne_cislo != NULL)) OR ( (ico != NULL) AND (rodne_cislo = NULL))) 
);/
CREATE TABLE Poistovna(
  id_poistovna int GENERATED ALWAYS AS IDENTITY,
  nazov varchar(255) NOT NULL
);/
CREATE TABLE Zamestnanec(
  id_zamestnanec int NOT NULL,
  meno varchar(255) NOT NULL,
  priezvisko varchar(255) NOT NULL,
  login varchar(255) NOT NULL,
  adresa varchar(255) NOT NULL,
  pracovisko int NOT NULL,
  pozicia varchar(255) NOT NULL
);/
CREATE TABLE Pobocka(
  id_pobocka int GENERATED ALWAYS AS IDENTITY,
  nazov varchar(255) NOT NULL UNIQUE,
  url_ varchar(255),
  adresa varchar(255)
);/
CREATE TABLE Sklad(
  id_polozka int GENERATED ALWAYS AS IDENTITY,
  liek char(6) NOT NULL,
  mnozstvo int NOT NULL,
  pobocka int NOT NULL
);/
CREATE TABLE Rezervacia(
  id_rezervacia int GENERATED ALWAYS AS IDENTITY,
  mnozstvo int NOT NULL,
  objednavka int NOT NULL
);/
CREATE TABLE Objednavka(
  id_objednavka int GENERATED ALWAYS AS IDENTITY,
  meno varchar(255) NOT NULL,
  priezvisko varchar(255) NOT NULL,
  pobocka int NOT NULL
);/
CREATE TABLE Rezervacie_v_sklade(
  id_rezervacia int NOT NULL,
  id_polozka int NOT NULL
);/
ALTER TABLE Liek ADD PRIMARY KEY (id_sukl);
/
ALTER TABLE Dodavatel ADD PRIMARY KEY (id_dodavatel);
/
ALTER TABLE Predane ADD PRIMARY KEY (id_predaja);
/
ALTER TABLE Fakt_udaje ADD PRIMARY KEY(id_fakt);
/
ALTER TABLE Poistovna ADD PRIMARY KEY(id_poistovna);
/
ALTER TABLE Zamestnanec ADD PRIMARY KEY(id_zamestnanec);
/
ALTER TABLE Pobocka ADD PRIMARY KEY(id_pobocka);
/
ALTER TABLE Sklad ADD PRIMARY KEY(id_polozka);
/
ALTER TABLE Rezervacia ADD PRIMARY KEY(id_rezervacia);
/
ALTER TABLE Objednavka ADD PRIMARY KEY(id_objednavka);
/
ALTER TABLE Liek ADD FOREIGN KEY (dodavatel) REFERENCES Dodavatel(id_dodavatel);
/
ALTER TABLE Predane ADD FOREIGN KEY (liek) REFERENCES Liek(id_sukl);
/
ALTER TABLE Predane ADD FOREIGN KEY (pobocka)  REFERENCES Pobocka(id_pobocka);
/
ALTER TABLE Fakt_udaje ADD FOREIGN KEY (id_predaj) REFERENCES Predane(id_predaja);
/
ALTER TABLE Fakt_udaje ADD FOREIGN KEY (poistovna) REFERENCES Poistovna(id_poistovna);
/
ALTER TABLE Sklad ADD FOREIGN KEY (liek) REFERENCES Liek(id_sukl);
/
ALTER TABLE Sklad ADD FOREIGN KEY (pobocka)  REFERENCES Pobocka(id_pobocka);
/
ALTER TABLE Zamestnanec ADD FOREIGN KEY (pracovisko) REFERENCES Pobocka(id_pobocka);
/
ALTER TABLE Objednavka ADD FOREIGN KEY (pobocka) REFERENCES Pobocka(id_pobocka);
/
ALTER TABLE Rezervacia ADD FOREIGN KEY (objednavka) REFERENCES Objednavka(id_objednavka);
/
ALTER TABLE Rezervacie_v_sklade ADD FOREIGN KEY (id_rezervacia) REFERENCES Rezervacia(id_rezervacia);
/
ALTER TABLE Rezervacie_v_sklade ADD FOREIGN KEY (id_polozka) REFERENCES Sklad(id_polozka);



CREATE OR REPLACE TRIGGER vytvor_login_zamestnanca
BEFORE INSERT OR UPDATE
OF priezvisko, pracovisko
ON Zamestnanec
FOR EACH ROW
DECLARE
  location varchar(25);
BEGIN
  SELECT nazov into location FROM Pobocka WHERE Pobocka.ID_POBOCKA = :new.pracovisko;
  :new.login := :new.id_zamestnanec || SUBSTR(:new.priezvisko, 1, 4) || '_'||SUBSTR(location, 1, 3);
END;
/


CREATE OR REPLACE TRIGGER trigger_pobocka_ad_url
BEFORE INSERT OR UPDATE 
OF adresa,url_ 
ON pobocka
FOR EACH ROW
BEGIN
  if (NOT((:new.url_ = NULL AND :new.adresa != NULL) OR (:new.url_ != NULL AND :new.adresa = NULL))) then
    ROLLBACK;
  end if;
END;
/


CREATE OR REPLACE PROCEDURE getEmployeesWorkingAtCursor(
  nazov_pobocky IN Pobocka.nazov%TYPE,
  c_zamestnanec OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN c_zamestnanec FOR
  SELECT Z.meno, Z.priezvisko FROM Zamestnanec Z JOIN Pobocka P ON (Z.pracovisko = P.id_pobocka) WHERE P.nazov = nazov_pobocky;
END;
/





CREATE OR REPLACE PROCEDURE medIsInStock(nazovLieku in VARCHAR2)
IS
  cursor liek_c is SELECT * FROM Liek L JOIN Sklad S ON (S.liek = L.id_sukl);
  polozkaLiek liek_c%ROWTYPE;
  x liek_c%ROWTYPE;
  iter NUMBER;
  
BEGIN
  iter := 0;
  OPEN liek_c;
  loop
    fetch liek_c into polozkaLiek;
    exit when liek_c%NOTFOUND;
    if (polozkaLiek.nazov = nazovLieku) THEN
      dbms_output.put_line('Pozadovany liek mame na sklade.');
    end if;
    iter := iter + 1;
  end loop;
EXCEPTION
  WHEN NO_DATA_FOUND THEN --ak zadame neexistujuceho zivocicha/ak neni este umiestneny v reale sa nestane
    dbms_output.put_line('Liek s menom ' || nazovLieku || ' nie je na sklade!');
  WHEN OTHERS THEN
    Raise_Application_Error (-20206, 'Nastala chyba!');
END;
/

--Dodavatel
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Acme United Corporation', '48 Sherman Junction', '+213697467874', 'vmurray0@symantec.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Vi-Jon', '32215 Dahle Center', '+923814315572', 'acastillo1@imageshack.us');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('REMEDYREPACK INC.', '75 Granby Crossing', '+243434021075', 'lsnyder2@weebly.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Avon Products, Inc.', '95 2nd Alley', '+563060908820', 'hellis3@mozilla.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('NATURE REPUBLIC CO., LTD.', '8524 Katie Park', '+353240357599', 'mstone4@sohu.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Physicians Total Care, Inc.', '2 Grim Street', '+987557081842', 'kphillips5@theglobeandmail.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('PD-Rx Pharmaceuticals, Inc.', '703 Dunning Court', '+840393662444', 'dday6@xing.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Rebel Distributors Corp', '274 Arrowood Center', '+038338652105', 'ecoleman7@chronoengine.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Ranbaxy Laboratories Ltd.', '11 Lerdahl Parkway', '+579061710759', 'jfields9@ibm.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('RWM TECHNOLOGIES', '2943 Pierstorff Alley', '+670841850218', 'afergusonb@icio.us');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Procter Gamble Manufacturing Company', '0046 Linden Avenue', '+385034698847', 'gwrightc@ted.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Boots Retail USA Inc', '128 Sugar Park', '+944915235440', 'jmorrisd@ucsd.edu');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Preferred Pharmaceuticals, Inc', '44487 Ridgeview Street', '+933110416302', 'mbakere@e-recht24.de');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Major Pharmaceuticals', '105 Gina Center', '+705289555128', 'kmartinezg@live.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Good Neighbor Pharmacy', '586 Kipling Plaza', '+955006924095', 'mstewarth@va.gov');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Energique, Inc.', '0 Crest Line Court', '+494066523134', 'dkellyi@edublogs.org');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('AMI Cosmetic Co.,Ltd.', '2063 Hazelcrest Crossing', '+657148214295', 'aperryj@geocities.jp');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Target Corporation', '4995 Hooker Terrace', '+809426870823', 'lgibsonk@hao123.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('WG Critical Care, LLC', '1 Oakridge Terrace', '+126346231892', 'mperryl@amazon.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Unifirst First Aid Corporation', '191 Moose Plaza', '+109499962694', 'ralvarezm@smh.com.au');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('AZ Pharmaceutical, Inc.', '360 Carpenter Drive', '+009357411295', 'cmillsn@ca.gov');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('AbbVie Inc.', '626 Dahle Center', '+109288487156', 'fnelsono@a8.net');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('PRESCRIPTIVES INC', '13 Roxbury Crossing', '+572315300417', 'kriverap@blogspot.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('ALK-Abello, Inc.', '12271 Main Point', '+138914081360', 'khunts@ibm.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Integria Healthcare US Inc.', '6405 Fordem Plaza', '+930585415039', 'hbankst@weibo.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Baxter Healthcare Corporation', '3035 Bobwhite Road', '+346385829101', 'lcookv@skyrock.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Nelco Laboratories, Inc.', '8081 Larry Place', '+502171288184', 'tphillipsw@feedburner.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Accra-Pac, Inc.', '08 North Crossing', '+995086570513', 'ssullivanx@squarespace.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Janssen Pharmaceuticals, Inc.', '7308 Dunning Plaza', '+096055462509', 'lgilberty@sina.com.cn');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Cardinal Health', '2372 Longview Parkway', '+185521121586', 'jnguyen10@vistaprint.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Supervalu Inc', '3896 Oakridge Court', '+105445058157', 'fedwards11@china.com.cn');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Zydus Pharmaceuticals (USA) Inc.', '55903 Golf Terrace', '+389520078959', 'sgreene12@cisco.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('L''Oreal USA Products Inc', '9076 Mayer Court', '+592025115882', 'dwilson13@is.gd');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Western Family Foods Inc', '05 Fair Oaks Crossing', '+130528432057', 'mbanks14@netlog.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Hydrox Laboratories', '81899 Derek Park', '+304453556897', 'ahansen15@cnbc.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Mylan Institutional Inc.', '111 Dovetail Point', '+727677745572', 'kthompson18@g.co');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('WOCKHARDT USA LLC.', '42 Clyde Gallagher Plaza', '+046477533468', 'bmiller19@patch.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Healing Natural Oils LLC', '0 Namekagon Place', '+047176737128', 'akelly1a@photobucket.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Walgreen Company', '797 Golf View Pass', '+614183917494', 'kgreen1b@nasa.gov');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Lofthouse of Fleetwood, Ltd.', '00 Loomis Place', '+455357571585', 'clee1c@mapy.cz');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('A-S Medication Solutions LLC', '9 Bellgrove Road', '+041951386170', 'dturner1d@skype.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Liberty Pharmaceuticals, Inc.', '7347 Towne Parkway', '+319479573071', 'rharvey0@msn.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Meijer Distribution Inc', '133 Jana Park', '+703286099586', 'jgibson1@gnu.org');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Medline Industries, Inc.', '84370 Claremont Alley', '+618633958898', 'mdean2@plala.or.jp');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Newton Laboratories, Inc.', '0 Atwood Park', '+658993318027', 'mwilliams3@theglobeandmail.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('GlaxoSmithKline LLC', '72081 Judy Trail', '+573560738497', 'jcruz5@sitemeter.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Novartis Pharmaceuticals Corporation', '8456 Fulton Crossing', '+298208215725', 'cphillips8@lulu.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Lake Erie Medical Surgical Supplies DBA Quality Care Products LLC', '30 Larry Lane', '+914190487603', 'amartinez9@ucoz.ru');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Nash-Finch Company (Our Family)', '6 Swallow Crossing', '+773265255025', 'bhart0@adobe.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('L. Perrigo Company', '3 Manufacturers Park', '+516963233661', 'bhudson1@so-net.ne.jp');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Kremers Urban Pharmaceuticals Inc.', '8 Coleman Terrace', '+970872902925', 'pcrawford2@addtoany.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('McNeil Consumer Healthcare Div McNeil-PPC, Inc', '52 Troy Alley', '+924077636738', 'jthompson3@google.com.hk');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('SHISEIDO CO., LTD.', '82328 Artisan Circle', '+686873345696', 'ereynolds4@usda.gov');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('H.J. Harkins Company, Inc.', '457 Esch Road', '+455551914675', 'lgutierrez6@sogou.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('McKesson Packaging Services Business Unit of McKesson Corporation', '897 Division Crossing', '+905709414410', 'smatthews7@cbsnews.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Ethex Corporation', '82 Mallard Way', '+611687641535', 'pcastillo8@dion.ne.jp');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Mylan Pharmaceuticals Inc.', '5 Grasskamp Circle', '+264238759812', 'wwilliams9@storify.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Mylan Institutional LLC', '013 Sunnyside Plaza', '+871673756923', 'cmccoya@utexas.edu');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Select Brand Distributors', '5542 Golf View Hill', '+552620899536', 'breidd@mtv.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Bryant Ranch Prepack', '257 Bunting Circle', '+754967107285', 'wpetersone@google.de');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Blenheim Pharmacal, Inc.', '614 Clarendon Lane', '+975723055431', 'mriley@fmsu.edu');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Johnson Johnson Consumer Products Company, Division of Johnson Johnson Consumer Companies, Inc.', '9591 Hovde Parkway', '+055773780764', 'ppriceg@wsj.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Aphena Pharma Solutions - Tennessee, Inc.', '31538 Straubel Point', '+341351721340', 'cfranklinh@amazon.co.uk');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Genentech, Inc.', '0 Kedzie Court', '+887783120616', 'dmorrisoni@slate.com');
insert into Dodavatel (nazov, sidlo, tel_c, email) values ('Shopko Stores Operating Co., LLC', '7 Sachs Center', '+448592586508', 'jkingj@house.gov');


--LIEKY
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('LWCWLJ', 'Progesterone', 'Deseret Biologicals, Inc.', '7', 878.9, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('51IIJ7', 'ACYCLOVIR', 'Stat Rx USA', '37', 441.05, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('N05WCE', 'OCTINOXATE, OCTISALATE, and OXYBENZONE', 'Guthy-Renker LLC', '8', 476.73, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('2250FW', 'Lisinopril and Hydrochlorothiazide', 'Golden State Medical Supply, Inc.', '9', 690.51, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('PR2MV0', 'naproxen sodium', 'Rebel Distributors Corp', '2', 905.31, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('QBARU1', 'TITANIUM DIOXIDE', 'Shanghai Justking Enterprise Co. Ltd.', '4', 585.93, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('91687E', 'Titanium Dioxide', 'TONYMOLY CO., LTD.', '4', 31.2, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('RHZU37', 'Pear', 'Antigen Laboratories, Inc.', '59', 763.07, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('00R045', 'Diltiazem Hydrochloride', 'NCS HealthCare of KY, Inc dba Vangard Labs', '2', 895.31, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('0PY2JY', 'ACETAMINOPHEN', 'FREDS, INC', '46', 353.81, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7TJ9RX', 'Miconazole nitrate', 'Walgreen Company', '57', 729.69, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('77W66T', 'Octinoxate, Octisalate', 'Lancaster S.A.M.', '52', 235.61, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('G3UVVS', 'Dexbrompheniramine Maleate, Pseudoephedrine', 'Llorens Pharmaceutical International Division', '50', 241.51, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('0U2752', 'Alcohol', 'Ecolab Inc.', '8', 340.0, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('8GBU3D', 'Quetiapine Fumarate', 'REMEDYREPACK INC.', '8', 82.3, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('4NM5W3', 'Aluminum Zirconium Trichlorohydrex Gly', 'Procter Gamble Manufacturing Company', '7', 689.6, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('GVHV0R', 'SPONGIA OFFICINALIS SKELETON, ROASTED and CALCIUM IODIDE and FUCUS VESICULOSUS and SILICON DIOXIDE and', 'Heel Inc', '56', 58.97, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('KEU22F', 'octinoxate, octisalate, zinc oxide, oxybenzone,', 'Mary Kay Inc.', '3', 161.41, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('388WUV', 'OCTINOXATE, TITANIUM DIOXIDE, OXYBENZONE', 'Parfums Christian Dior', '53', 340.19, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('T62ZK0', 'BENZALKONIUM CHLORIDE', 'Artemis Bio-Solutions Inc', '7', 366.06, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('743ZPW', 'Tranexamic Acid', 'X-GEN Pharmaceuticals, Inc.', '37', 230.08, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('8664ZR', 'Testosterone', 'AbbVie Inc.', '6', 773.43, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('8J806N', 'GLYCERIN', 'AMI Cosmetic Co.,Ltd.', '5', 799.84, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('971OV4', 'White Petrolatum', 'Geiss, Destin and Dunn, Inc', '9', 687.87, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('Y70CM7', 'not applicable', 'VitaMed, LLC', '8', 722.27, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7GB15I', 'Menthol, Methyl salicylate', 'Perrigo New York Inc', '19', 361.53, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('13WV3S', 'CUTTLEFISH', 'Remedy Makers', '9', 191.23, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('NKSUQ8', 'Acetaminophen', 'Safeway', '9', 729.23, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('2TLB30', 'phenobarbital', 'Atlantic Biologicals Corps', '6', 398.01, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('D5IF60', 'ALCOHOL', 'Rite Aid Corporation', '6', 89.3, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('5151GN', 'Nitrous Oxide', 'General Air Service Supply Co', '4', 277.22, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('SWN128', 'lisinopril', 'RedPharm Drug Inc.', '41', 827.63, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('DTG3TV', 'LOSARTAN POTASSIUM AND HYDROCHLOROTHIAZIDE', 'Unit Dose Services', '38', 769.97, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('103T8V', 'iron sucrose', 'Fresenius Medical Care North America', '56', 469.93, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('O2BBJ5', 'Quetiapine Fumarate', 'AvKARE, Inc.', '2', 385.59, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('I0NEHW', 'Promethazine Hydrochloride', 'Hi-Tech Pharmacal Co., Inc.', '9', 812.55, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('Z4Z1XA', 'GLYCOPYRROLATE', 'Rising Pharmaceuticals Inc', '9', 502.7, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('38VI37', 'Lamivudine and Zidovudine', 'Camber Pharmaceuticals, Inc.', '57', 59.57, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('B2EVEP', 'Cephalosporium', 'Antigen Laboratories, Inc.', '43', 589.4, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('0I7IE4', 'Olanzapine', 'Macleods Pharmaceuticals Limited', '55', 135.88, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('CO6BX8', 'Chloroxylenol', 'Betco Corporation, Ltd.', '9', 324.13, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('V022TE', 'GLYCERIN', 'MEGASOL COSMETIC GMBH', '33', 253.55, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('4ID9WV', 'benzoyl peroxide', 'Allergan, Inc.', '56', 405.1, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('47P2S1', 'probenecid', 'Mylan Pharmaceuticals Inc.', '26', 98.84, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('U57NFQ', 'Ciprofloxacin', 'Carlsbad Technology, Inc.', '58', 917.88, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('6HFTQX', 'benazepril hydrochloride and hydrochlorothiazide', 'Clinical Solutions Wholesale', '57', 675.62, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7391UW', 'PANTOPRAZOLE SODIUM', 'Wyeth Pharmaceuticals Inc., a subsidiary of Pfizer Inc.', '9', 349.47, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('J9VSNI', 'cefoxitin sodium', 'Sagent Pharmaceuticals', '46', 182.23, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('ZS817L', 'Carbamazepine', 'Teva Pharmaceuticals USA Inc', '49', 974.53, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('PP9JMA', 'TITANIUM DIOXIDE', 'Laboratoires Clarins S.A.', '9', 388.66, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('MVY85P', 'bisacodyl', 'H and P Industries, Inc. dba Triad Group', '58', 5.13, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('L7R57U', 'Red (River) Birch', 'Antigen Laboratories, Inc.', '3', 542.37, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('512LHR', 'nebivolol hydrochloride', 'Forest laboratories, Inc.', '9', 637.85, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('5XS146', 'Triclosan', 'SJ Creations, Inc.', '6', 305.02, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('8F0WC2', 'acetaminophen, dextromethorphan hydrobromide, doxylamine succinate', 'Topco Associates LLC', '9', 184.27, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('947GYB', 'EPICOCCUM NIGRUM', 'ALK-Abello, Inc.', '7', 85.53, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('9J28M6', 'Ketotifen Fumarate', 'Meijer Distribution Inc', '5', 485.41, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('C6L8XQ', 'Loratadine', 'Western Family Foods Inc', '4', 159.47, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('63C3QS', 'OCTINOXATE and TITANIUM DIOXIDE', 'NARS Cosmetics', '59', 903.73, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('8666QZ', 'Hyoscyamine Sulfate Extended-Release', 'County Line Pharmaceuticals, LLC', '48', 755.62, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('5Z3GVL', '0.63% Stannous Fluoride', 'Cypress Pharmaceutical, Inc.', '9', 519.8, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('DRIGY3', 'Promethazine hydrochloride and phenylephrine hydrochloride', 'Bryant Ranch Prepack', '1', 418.0, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('UL2098', 'Phentermine Hydrochloride', 'Unit Dose Services', '7', 540.88, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('3X6837', 'Salicylic Acid', 'Dermalogica, Inc.', '54', 995.33, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('81U02A', 'ALUMINUM CHLOROHYDRATE', 'Dukal Corporation', '1', 513.91, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('S75K64', 'Methadone Hydrochloride', 'Lake Erie Medical DBA Quality Care Products LLC', '5', 176.21, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('X2UDJ4', 'enoxaparin sodium', 'sanofi-aventis U.S. LLC', '39', 759.39, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('W565K5', 'HELMINTHOSPORIUM SOROKINIANUM', 'ALK-Abello, Inc.', '42', 204.81, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7DWG0W', 'glipizide', 'REMEDYREPACK INC.', '54', 305.46, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('71CU92', 'Nortriptyline Hydrochloride', 'Watson Laboratories, Inc.', '51', 249.05, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('4L4KJ0', 'ibuprofen', 'Dolgencorp Inc', '49', 562.98, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('X73176', 'Camphor and Menthol', 'Quality Care Distributors LLC', '53', 410.0, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('0B79S4', 'Diclofenac Sodium and Misoprostol', 'Eagle Pharmaceuticals, Inc.', '58', 693.01, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7NFU1C', 'Cetirizine Hydrochloride and Pseudoephedrine Hydrochloride', 'McNeil Consumer Healthcare Div McNeil-PPC, Inc', '25', 170.88, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('04T320', 'Benzocaine', 'CVS Pharmacy', '38', 523.13, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('9247Z2', 'Ethanol', 'Best Sanitizers, Inc', '9', 553.14, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('NXC5TI', 'Quetiapine Fumarate', 'Teva Pharmaceuticals USA Inc', '54', 399.87, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('QV88OE', 'DOCUSATE SODIUM', 'PuraVation Pharmaceuticals Inc', '9', 402.29, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('6485KL', 'Phosphorus comp.', 'Uriel Pharmacy Inc.', '45', 805.16, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('9U04ES', 'Lanolin, Petrolatum', 'Wal-Mart Stores Inc', '57', 393.25, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('Q3A9RJ', 'Clotrimazole', 'United Exchange Corp.', '9', 755.01, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('ZSKP83', 'MORPHINE SULFATE', 'Paddock Laboratories, LLC', '56', 172.27, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('90JYI5', 'Beta Vulgaris, Boldo, Carduus Marianus, Chelidonium Majus, Peteroselinum Sativum, Taraxacum Officinale', 'BioActive Nutritional, Inc.', '40', 284.16, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('V96RT3', 'Sennosides', 'New World Imports', '2', 289.22, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('V05V6G', 'Lidocaine Hydrochloride', 'LLC Federal Solutions', '41', 969.08, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('5251SE', 'Bismuth subsalicylate', 'Procter Gamble Manufacturing Company', '2', 587.58, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('4FN030', 'Duloxetine', 'Lupin Pharmaceuticals, Inc.', '44', 84.21, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('48FNGR', 'Phenylephrine HCl', 'Safeway', '58', 204.88, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('G6HST0', 'GABAPENTIN', 'Greenstone LLC', '42', 721.89, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('OP974R', 'Octinoxate', 'Elizabeth Arden, Inc', '9', 781.29, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7UU388', 'Guinea Pig Epithelium', 'Nelco Laboratories, Inc.', '57', 478.18, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('9918FV', 'Erythromycin', 'REMEDYREPACK INC.', '56', 725.61, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('2SAZW8', 'Fenofibric Acid', 'AbbVie Inc.', '7', 230.34, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('27TMH2', 'SUCRALFATE', 'State of Florida DOH Central Pharmacy', '41', 30.86, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('37U599', 'Coal Tar', 'Family Dollar Services Inc', '5', 641.58, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('EP26C9', 'Amlodipine Besylate and Benazepril Hydrochloride', 'Dr.Reddy''s Laboratories Limited', '47', 719.54, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('987JKW', 'anthralin', 'Elorac Inc.', '16', 309.45, 0);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('B0VM4W', 'OCTINOXATE', 'LAURA GELLER MAKE UP INC.', '3', 199.28, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('7U4IB1', 'Ensulizole Octinoxate', 'L''Oreal USA Products Inc', '45', 679.15, 1);
insert into Liek (id_sukl, nazov, vyrobca, dodavatel, cena, na_predpis) values ('9D5EB6', 'Terbinafine Hydrochloride', 'Physicians Total Care, Inc.', '5', 444.17, 0);

--Poistovna
insert into Poistovna (nazov) values ('Union');
insert into Poistovna (nazov) values ('Všeobecná zdravotná poistov?a');
insert into Poistovna (nazov) values ('Dôvera');

--Pobocka
insert into Pobocka (nazov, adresa) values ('Bratislava', 'Obchodná 24');
insert into Pobocka (nazov, adresa) values ('Banská Bystrica', 'Námestie SNP 85');
insert into Pobocka (nazov, adresa) values ('Košice', 'Hlavná 195');
insert into Pobocka (nazov, url_) values ('eshop', 'www.najlepsialekaren.sk');

--Predane
insert into Predane (pobocka, mnozstvo, liek) values (1, 13, '9U04ES');
insert into Predane (pobocka, mnozstvo, liek) values (2, 546, 'Q3A9RJ');
insert into Predane (pobocka, mnozstvo, liek) values (3, 35, 'ZSKP83');
insert into Predane (pobocka, mnozstvo, liek) values (4, 21, '90JYI5');
insert into Predane (pobocka, mnozstvo, liek) values (1, 74, 'V96RT3');
insert into Predane (pobocka, mnozstvo, liek) values (2, 45, 'V05V6G');
insert into Predane (pobocka, mnozstvo, liek) values (3, 25, '5251SE');
insert into Predane (pobocka, mnozstvo, liek) values (4, 63, '4FN030');
insert into Predane (pobocka, mnozstvo, liek) values (1, 5, '48FNGR');
insert into Predane (pobocka, mnozstvo, liek) values (2, 3 ,'G6HST0');
insert into Predane (pobocka, mnozstvo, liek) values (3, 4, 'OP974R');
insert into Predane (pobocka, mnozstvo, liek) values (4, 5, '7UU388');
insert into Predane (pobocka, mnozstvo, liek) values (1, 8, '9918FV');
insert into Predane (pobocka, mnozstvo, liek) values (2, 9, '2SAZW8');
insert into Predane (pobocka, mnozstvo, liek) values (3, 9, '27TMH2');
insert into Predane (pobocka, mnozstvo, liek) values (4, 9, '37U599');
insert into Predane (pobocka, mnozstvo, liek) values (1, 9, 'EP26C9');
insert into Predane (pobocka, mnozstvo, liek) values (2, 7, '987JKW');
insert into Predane (pobocka, mnozstvo, liek) values (3, 59, 'B0VM4W');
insert into Predane (pobocka, mnozstvo, liek) values (4, 78, '7U4IB1');
insert into Predane (pobocka, mnozstvo, liek) values (1, 36, '9D5EB6');

--Fakt_udaje
--insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo, ico) values(1, 1, '941124/9441', '123456');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(2, 2, '941124/9430');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(3, 3, '941124/9419');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(4, 3, '941124/9408');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(5, 1, '941124/9397');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(6, 2, '941124/9386');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(7, 3, '941124/9375');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(8, 3, '941124/934');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(9, 1, '941124/933');
insert into Fakt_udaje (id_predaj, poistovna, rodne_cislo) values(10, 2, '941124/932');

insert into Fakt_udaje (id_predaj, poistovna, ico) values(11, 1, '12345678');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(12, 2, '65844645');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(13, 3, '635986');
--insert into Fakt_udaje (id_predaj, poistovna, ico) values(14, 3, '7894522');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(15, 1, '48748989');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(16, 2, '85522463');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(17, 3, '78945689');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(18, 3, '654231');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(19, 1, '98732165');
insert into Fakt_udaje (id_predaj, poistovna, ico) values(20, 3, '78965632');

--Zamestanec
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (1, 'Jimmy', 'Howard', '8 Muir Road', '2', 'Riaditel');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (2, 'Shawn', 'Elliott', '95 Stone Corner Place', '3', 'Riaditel');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (3, 'Johnny', 'Boyd', '42263 Aberg Alley', '3', 'Lekarnik');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (4, 'Chris', 'Hall', '16 Hazelcrest Circle', '1', 'Riaditel');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (5, 'Sara', 'Payne', '6450 Brown Plaza', '2', 'Lekarnik');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (6, 'Diane', 'Murray', '72535 Lunder Park', '2', 'Lekarnik');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (7, 'Stephanie', 'Hanson', '16822 Cottonwood Terrace', '3', 'Lekarnik');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (8, 'Jeffrey', 'Dunn', '166 Harper Drive', '1', 'Lekarnik');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (9, 'Julie', 'Roberts', '70 Maywood Place', '4', 'Administrator');
insert into Zamestnanec (id_zamestnanec, meno, priezvisko, adresa, pracovisko, pozicia) values (10, 'Paula', 'Anderson', '1651 Arapahoe Lane', '4', 'Lekarnik');


--Sklad
insert into Sklad (mnozstvo, liek, pobocka) values (154, '9U04ES', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (52, 'Q3A9RJ', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (3, 'Q3A9RJ', '1');
insert into Sklad (mnozstvo, liek, pobocka) values (9, 'Q3A9RJ', '2');
insert into Sklad (mnozstvo, liek, pobocka) values (55, 'Q3A9RJ', '2');
insert into Sklad (mnozstvo, liek, pobocka) values (100, 'Q3A9RJ', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (34, 'ZSKP83', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (44, '90JYI5', '3');
insert into Sklad (mnozstvo, liek, pobocka) values (55, 'V96RT3', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (68, 'V05V6G', '1');
insert into Sklad (mnozstvo, liek, pobocka) values (79, '5251SE', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (88, '4FN030', '3');
insert into Sklad (mnozstvo, liek, pobocka) values (98, '48FNGR', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (10, 'G6HST0', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (181, 'OP974R', '1');
insert into Sklad (mnozstvo, liek, pobocka) values (182, '7UU388', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (13, '9918FV', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (148, '2SAZW8', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (15, '27TMH2', '3');
insert into Sklad (mnozstvo, liek, pobocka) values (186, '37U599', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (17, 'EP26C9', '2');
insert into Sklad (mnozstvo, liek, pobocka) values (18, '987JKW', '4');
insert into Sklad (mnozstvo, liek, pobocka) values (189, 'B0VM4W', '3');
insert into Sklad (mnozstvo, liek, pobocka) values (20, '7U4IB1', '4');


--Objednavka
insert into Objednavka (meno, priezvisko, pobocka) values ('Janet', 'Austin', '3');
insert into Objednavka (meno, priezvisko, pobocka) values ('Martin', 'Baker', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Nancy', 'Thomas', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Joseph', 'Ross', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Andrea', 'Gonzales', '1');
insert into Objednavka (meno, priezvisko, pobocka) values ('Scott', 'Hart', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Pamela', 'Hunt', '2');
insert into Objednavka (meno, priezvisko, pobocka) values ('Phyllis', 'Collins', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Brian', 'Henry', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Amy', 'Burton', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Laura', 'Mitchell', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Russell', 'Bryant', '1');
insert into Objednavka (meno, priezvisko, pobocka) values ('Kimberly', 'Mason', '3');
insert into Objednavka (meno, priezvisko, pobocka) values ('Heather', 'Scott', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Michael', 'Campbell', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Christina', 'Ramos', '3');
insert into Objednavka (meno, priezvisko, pobocka) values ('Doris', 'Nichols', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Raymond', 'Murphy', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Todd', 'Taylor', '4');
insert into Objednavka (meno, priezvisko, pobocka) values ('Sara', 'Price', '3');
insert into Objednavka (meno, priezvisko, pobocka) values ('Julie', 'Roberts', 2); 
insert into Objednavka (meno, priezvisko, pobocka) values ('Paula', 'Anderson', 4);

--Rezervacia
insert into Rezervacia (mnozstvo, objednavka) values ('3', 1);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 2);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 3);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 4);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 5);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 6);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 7);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 8);
insert into Rezervacia (mnozstvo, objednavka) values ('2', 9);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 10);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 11);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 12);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 13);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 14);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 15);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 16);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 17);
insert into Rezervacia (mnozstvo, objednavka) values ('3', 18);
insert into Rezervacia (mnozstvo, objednavka) values ('4', 19);
insert into Rezervacia (mnozstvo, objednavka) values ('1', 20);


--Rezervacia v sklade
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (1, 1);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (2, 2);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (3, 3);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (4, 4);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (5, 5);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (6, 6);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (7, 7);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (8, 8);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (9, 9);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (10, 10);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (11, 11);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (12, 12);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (13, 13);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (14, 14);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (15, 15);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (16, 16);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (17, 17);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (18, 18);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (19, 19);
insert into Rezervacie_v_sklade (id_polozka, id_rezervacia) values (20, 20);


/*

-- vyberame vsetky udaje o liekoch a ich dodavateloch
SELECT * FROM Liek LEFT JOIN Dodavatel ON dodavatel = id_dodavatel;

-- vyberame vsetky udaje o zamestnancoch a aj na akej pobocke pracuju a aku maju pracovnu poziciu
SELECT * FROM Zamestnanec INNER JOIN Pobocka ON pracovisko = id_pobocka;

-- vyberame lieky ktore boli kupene jednym konkretnym clovekom s danym rodnym cislom
SELECT Liek.nazov, Predane.mnozstvo
FROM Predane
INNER JOIN Liek ON Predane.liek = Liek.id_sukl 
LEFT JOIN Fakt_udaje ON Fakt_udaje.id_predaj = Predane.id_predaja
WHERE Fakt_udaje.rodne_cislo = '941124/9419';

-- zaujima nas kolko ktoreho lieku bolo predaneho na konkretnej pobocke
SELECT Liek.nazov, SUM(Predane.mnozstvo)
FROM Predane
INNER JOIN Liek ON Liek.id_sukl = Predane.liek
INNER JOIN Pobocka ON Pobocka.id_pobocka = Predane.pobocka
WHERE Pobocka.nazov = 'Košice'
GROUP BY Liek.id_sukl, Liek.nazov;

-- chceme vediet kolko lieku mame naskladneneho na ktorej pobocke
SELECT Liek.nazov, SUM(Sklad.mnozstvo), Pobocka.nazov
FROM Pobocka
LEFT JOIN Sklad ON Sklad.pobocka = Pobocka.id_pobocka
INNER JOIN Liek ON Liek.id_sukl = Sklad.liek
GROUP BY Pobocka.nazov, Liek.nazov;

-- zaujima nas ci na sklade nejakej pobocky mame konkretny liek
SELECT Pobocka.nazov
FROM Pobocka
LEFT JOIN Sklad ON Sklad.pobocka = Pobocka.id_pobocka
INNER JOIN Liek ON Liek.id_sukl = Sklad.liek
WHERE EXISTS(
  SELECT 1 FROM Sklad
  INNER JOIN Liek ON Liek.id_sukl = Sklad.liek
  WHERE Sklad.pobocka = Pobocka.id_pobocka and Liek.nazov = 'Clotrimazole')
GROUP BY Pobocka.nazov;

-- vyberame len take objednavky ktore su napisane na zamestnancov 
SELECT Objednavka.meno, Objednavka.priezvisko
FROM Objednavka
WHERE Objednavka.priezvisko IN (
  SELECT Zamestnanec.priezvisko
  FROM Zamestnanec
  WHERE Objednavka.meno = Zamestnanec.meno AND Objednavka.priezvisko = Zamestnanec.priezvisko
);

*/

-- CURSOR c IS SELECT * FROM Zamestnances;
--exec getEmployeesWorkingAtCursor('Košice',c);

GRANT ALL ON Liek TO Zendulka;



exec medIsInStock('Progesterone');






-- GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO xsroka00;




-- EXPLAIN PLAN --


EXPLAIN PLAN FOR 
SELECT Liek.nazov, SUM(Sklad.mnozstvo), Pobocka.nazov
FROM Pobocka
LEFT JOIN Sklad ON Sklad.pobocka = Pobocka.id_pobocka
INNER JOIN Liek ON Liek.id_sukl = Sklad.liek
GROUP BY Pobocka.nazov, Liek.nazov;
SELECT * FROM TABLE(DBMS_XPLAN.display);


CREATE INDEX explainIndex ON Liek (nazov);


SELECT /*+ INDEX(Liek explainIndex)*/ Liek.nazov , SUM(Sklad.mnozstvo), Pobocka.nazov
FROM Pobocka
LEFT JOIN Sklad ON Sklad.pobocka = Pobocka.id_pobocka
INNER JOIN Liek ON Liek.id_sukl = Sklad.liek
GROUP BY Pobocka.nazov, Liek.nazov;
SELECT * FROM TABLE(DBMS_XPLAN.display);

DROP INDEX explainIndex;


-- Prava pre druheho clena tymu

GRANT ALL ON Liek TO xscavn00;
GRANT ALL ON Dodavatel TO xscavn00;
GRANT ALL ON Predane TO xscavn00;
GRANT ALL ON Fakt_udaje TO xscavn00;
GRANT ALL ON Poistovna TO xscavn00;
GRANT ALL ON Zamestnanec TO xscavn00;
GRANT ALL ON Pobocka TO xscavn00;
GRANT ALL ON Sklad TO xscavn00;
GRANT ALL ON Rezervacia TO xscavn00;
GRANT ALL ON Objednavka TO xscavn00;
GRANT ALL ON Rezervacie_v_sklade TO xscavn00;

-- Materialized view

CREATE MATERIALIZED VIEW predaneVKosiciach
AS
  SELECT L.* FROM Predane PR JOIN Pobocka PO ON (PO.id_pobocka = PR.POBOCKA) JOIN Liek L ON (L.ID_SUKL = PR.LIEK) WHERE PO.Nazov = 'Ko�ice';

GRANT ALL ON predaneVKosiciach TO xscavn00;


/*
CREATE MATERIALIZED VIEW LOG ON xsroka00.predaneVKosiciach Predane;
CREATE MATERIALIZED VIEW LOG ON xsroka00.predaneVKosiciach Pobocka;
CREATE MATERIALIZED VIEW LOG ON xsroka00.predaneVKosiciach Liek;

CREATE MATERIALIZED VIEW xsroka00.predaneVKosiciach CACHE BUILD IMMEDIATE REFRESH FAST ON COMMIT ENABLE QUERY REWRITE
AS
  SELECT L.* FROM Predane PR JOIN Pobocka PO ON (PO.id_pobocka = PR.POBOCKA) JOIN Liek L ON (L.ID_SUKL = PR.LIEK) WHERE PO.Nazov = 'Košice';

GRANT ALL ON predaneVKosiciach TO xscavn00;


/*

CREATE MATERIALIZED VIEW LOG ON predaneVKosiciach WITH PRIMARY KEY,ROWID(funkcia)INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW predaneVKosiciach CACHE BUILD IMMEDIATE REFRESH FAST ON COMMIT ENABLE QUERY REWRITE
AS
  SELECT L.* FROM Predane PR JOIN Pobocka PO ON (PO.id_pobocka = PR.POBOCKA) JOIN Liek L ON (L.ID_SUKL = PR.LIEK) WHERE PO.Nazov = 'Košice';

GRANT ALL ON predaneVKosiciach TO xsroka00;

SELECT * FROM predaneVKosiciach;
*/



