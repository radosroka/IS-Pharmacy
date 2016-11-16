-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `medicine` char(6) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `medicine` (`medicine`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`medicine`) REFERENCES `medicine` (`id_sukl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `id_sukl` char(6) COLLATE utf8_bin NOT NULL,
  `name` varchar(1024) COLLATE utf8_bin NOT NULL,
  `producer` varchar(1024) COLLATE utf8_bin NOT NULL,
  `distributor` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `prescription` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_sukl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `medicine` (`id_sukl`, `name`, `producer`, `distributor`, `price`, `prescription`) VALUES
('00R045',  'Diltiazem Hydrochloride',  'NCS HealthCare of KY, Inc dba Vangard Labs', 2,  895,  1),
('04T320',  'Benzocaine', 'CVS Pharmacy', 38, 523,  1),
('0B79S4',  'Diclofenac Sodium and Misoprostol',  'Eagle Pharmaceuticals, Inc.',  58, 693,  0),
('0I7IE4',  'Olanzapine', 'Macleods Pharmaceuticals Limited', 55, 136,  1),
('0PY2JY',  'ACETAMINOPHEN',  'FREDS, INC', 46, 354,  1),
('0U2752',  'Alcohol',  'Ecolab Inc.',  8,  340,  1),
('103T8V',  'iron sucrose', 'Fresenius Medical Care North America', 56, 470,  1),
('13WV3S',  'CUTTLEFISH', 'Remedy Makers',  9,  191,  1),
('2250FW',  'Lisinopril and Hydrochlorothiazide', 'Golden State Medical Supply, Inc.',  9,  691,  1),
('27TMH2',  'SUCRALFATE', 'State of Florida DOH Central Pharmacy',  41, 31, 0),
('2SAZW8',  'Fenofibric Acid',  'AbbVie Inc.',  7,  230,  1),
('2TLB30',  'phenobarbital',  'Atlantic Biologicals Corps', 6,  398,  1),
('37U599',  'Coal Tar', 'Family Dollar Services Inc', 5,  642,  1),
('388WUV',  'OCTINOXATE, TITANIUM DIOXIDE, OXYBENZONE', 'Parfums Christian Dior', 53, 340,  0),
('38VI37',  'Lamivudine and Zidovudine',  'Camber Pharmaceuticals, Inc.', 57, 60, 1),
('3X6837',  'Salicylic Acid', 'Dermalogica, Inc.',  54, 995,  0),
('47P2S1',  'probenecid', 'Mylan Pharmaceuticals Inc.', 26, 99, 0),
('48FNGR',  'Phenylephrine HCl',  'Safeway',  58, 205,  1),
('4FN030',  'Duloxetine', 'Lupin Pharmaceuticals, Inc.',  44, 84, 1),
('4ID9WV',  'benzoyl peroxide', 'Allergan, Inc.', 56, 405,  1),
('4L4KJ0',  'ibuprofen',  'Dolgencorp Inc', 49, 563,  0),
('4NM5W3',  'Aluminum Zirconium Trichlorohydrex Gly', 'Procter Gamble Manufacturing Company', 7,  690,  0),
('512LHR',  'nebivolol hydrochloride',  'Forest laboratories, Inc.',  9,  638,  0),
('5151GN',  'Nitrous Oxide',  'General Air Service Supply Co',  4,  277,  1),
('51IIJ7',  'ACYCLOVIR',  'Stat Rx USA',  37, 441,  1),
('5251SE',  'Bismuth subsalicylate',  'Procter Gamble Manufacturing Company', 2,  588,  1),
('5XS146',  'Triclosan',  'SJ Creations, Inc.', 6,  305,  0),
('5Z3GVL',  '0.63% Stannous Fluoride',  'Cypress Pharmaceutical, Inc.', 9,  520,  1),
('63C3QS',  'OCTINOXATE and TITANIUM DIOXIDE',  'NARS Cosmetics', 59, 904,  1),
('6485KL',  'Phosphorus comp.', 'Uriel Pharmacy Inc.',  45, 805,  1),
('6HFTQX',  'benazepril hydrochloride and hydrochlorothiazide', 'Clinical Solutions Wholesale', 57, 676,  0),
('71CU92',  'Nortriptyline Hydrochloride',  'Watson Laboratories, Inc.',  51, 249,  0),
('7391UW',  'PANTOPRAZOLE SODIUM',  'Wyeth Pharmaceuticals Inc., a subsidiary of Pfizer Inc.',  9,  349,  1),
('743ZPW',  'Tranexamic Acid',  'X-GEN Pharmaceuticals, Inc.',  37, 230,  1),
('77W66T',  'Octinoxate, Octisalate', 'Lancaster S.A.M.', 52, 236,  1),
('7DWG0W',  'glipizide',  'REMEDYREPACK INC.',  54, 305,  1),
('7GB15I',  'Menthol, Methyl salicylate', 'Perrigo New York Inc', 19, 362,  0),
('7NFU1C',  'Cetirizine Hydrochloride and Pseudoephedrine Hydrochloride', 'McNeil Consumer Healthcare Div McNeil-PPC, Inc', 25, 171,  0),
('7TJ9RX',  'Miconazole nitrate', 'Walgreen Company', 57, 730,  0),
('7U4IB1',  'Ensulizole Octinoxate',  'L\'Oreal USA Products Inc',  45, 679,  1),
('7UU388',  'Guinea Pig Epithelium',  'Nelco Laboratories, Inc.', 57, 478,  1),
('81U02A',  'ALUMINUM CHLOROHYDRATE', 'Dukal Corporation',  1,  514,  0),
('8664ZR',  'Testosterone', 'AbbVie Inc.',  6,  773,  1),
('8666QZ',  'Hyoscyamine Sulfate Extended-Release', 'County Line Pharmaceuticals, LLC', 48, 756,  0),
('8F0WC2',  'acetaminophen, dextromethorphan hydrobromide, doxylamine succinate', 'Topco Associates LLC', 9,  184,  1),
('8GBU3D',  'Quetiapine Fumarate',  'REMEDYREPACK INC.',  8,  82, 1),
('8J806N',  'GLYCERIN', 'AMI Cosmetic Co.,Ltd.',  5,  800,  0),
('90JYI5',  'Beta Vulgaris, Boldo, Carduus Marianus, Chelidonium Majus, Peteroselinum Sativum, Taraxacum Officinale', 'BioActive Nutritional, Inc.',  40, 284,  0),
('91687E',  'Titanium Dioxide', 'TONYMOLY CO., LTD.', 4,  31, 1),
('9247Z2',  'Ethanol',  'Best Sanitizers, Inc', 9,  553,  0),
('947GYB',  'EPICOCCUM NIGRUM', 'ALK-Abello, Inc.', 7,  86, 0),
('971OV4',  'White Petrolatum', 'Geiss, Destin and Dunn, Inc',  9,  688,  0),
('987JKW',  'anthralin',  'Elorac Inc.',  16, 309,  0),
('9918FV',  'Erythromycin', 'REMEDYREPACK INC.',  56, 726,  0),
('9D5EB6',  'Terbinafine Hydrochloride',  'Physicians Total Care, Inc.',  5,  444,  0),
('9J28M6',  'Ketotifen Fumarate', 'Meijer Distribution Inc',  5,  485,  0),
('9U04ES',  'Lanolin, Petrolatum',  'Wal-Mart Stores Inc',  57, 393,  0),
('B0VM4W',  'OCTINOXATE', 'LAURA GELLER MAKE UP INC.',  3,  199,  1),
('B2EVEP',  'Cephalosporium', 'Antigen Laboratories, Inc.', 43, 589,  0),
('C6L8XQ',  'Loratadine', 'Western Family Foods Inc', 4,  159,  0),
('CO6BX8',  'Chloroxylenol',  'Betco Corporation, Ltd.',  9,  324,  0),
('D5IF60',  'ALCOHOL',  'Rite Aid Corporation', 6,  89, 1),
('DRIGY3',  'Promethazine hydrochloride and phenylephrine hydrochloride', 'Bryant Ranch Prepack', 1,  418,  1),
('DTG3TV',  'LOSARTAN POTASSIUM AND HYDROCHLOROTHIAZIDE', 'Unit Dose Services', 38, 770,  0),
('EP26C9',  'Amlodipine Besylate and Benazepril Hydrochloride', 'Dr.Reddy\'s Laboratories Limited', 47, 720,  1),
('G3UVVS',  'Dexbrompheniramine Maleate, Pseudoephedrine',  'Llorens Pharmaceutical International Division',  50, 242,  0),
('G6HST0',  'GABAPENTIN', 'Greenstone LLC', 42, 722,  1),
('GVHV0R',  'SPONGIA OFFICINALIS SKELETON, ROASTED and CALCIUM IODIDE and FUCUS VESICULOSUS and SILICON DIOXIDE and', 'Heel Inc', 56, 59, 1),
('I0NEHW',  'Promethazine Hydrochloride', 'Hi-Tech Pharmacal Co., Inc.',  9,  813,  0),
('J9VSNI',  'cefoxitin sodium', 'Sagent Pharmaceuticals', 46, 182,  0),
('KEU22F',  'octinoxate, octisalate, zinc oxide, oxybenzone,',  'Mary Kay Inc.',  3,  161,  1),
('L7R57U',  'Red (River) Birch',  'Antigen Laboratories, Inc.', 3,  542,  1),
('LWCWLJ',  'Progesterone', 'Deseret Biologicals, Inc.',  7,  879,  0),
('MVY85P',  'bisacodyl',  'H and P Industries, Inc. dba Triad Group', 58, 5,  1),
('N05WCE',  'OCTINOXATE, OCTISALATE, and OXYBENZONE', 'Guthy-Renker LLC', 8,  477,  1),
('NKSUQ8',  'Acetaminophen',  'Safeway',  9,  729,  0),
('NXC5TI',  'Quetiapine Fumarate',  'Teva Pharmaceuticals USA Inc', 54, 400,  0),
('O2BBJ5',  'Quetiapine Fumarate',  'AvKARE, Inc.', 2,  386,  1),
('OP974R',  'Octinoxate', 'Elizabeth Arden, Inc', 9,  781,  0),
('PP9JMA',  'TITANIUM DIOXIDE', 'Laboratoires Clarins S.A.',  9,  389,  0),
('PR2MV0',  'naproxen sodium',  'Rebel Distributors Corp',  2,  905,  0),
('Q3A9RJ',  'Clotrimazole', 'United Exchange Corp.',  9,  755,  0),
('QBARU1',  'TITANIUM DIOXIDE', 'Shanghai Justking Enterprise Co. Ltd.',  4,  586,  0),
('QV88OE',  'DOCUSATE SODIUM',  'PuraVation Pharmaceuticals Inc', 9,  402,  1),
('RHZU37',  'Pear', 'Antigen Laboratories, Inc.', 59, 763,  1),
('S75K64',  'Methadone Hydrochloride',  'Lake Erie Medical DBA Quality Care Products LLC',  5,  176,  0),
('SWN128',  'lisinopril', 'RedPharm Drug Inc.', 41, 828,  0),
('T62ZK0',  'BENZALKONIUM CHLORIDE',  'Artemis Bio-Solutions Inc',  7,  366,  0),
('U57NFQ',  'Ciprofloxacin',  'Carlsbad Technology, Inc.',  58, 918,  1),
('UL2098',  'Phentermine Hydrochloride',  'Unit Dose Services', 7,  541,  0),
('V022TE',  'GLYCERIN', 'MEGASOL COSMETIC GMBH',  33, 254,  0),
('V05V6G',  'Lidocaine Hydrochloride',  'LLC Federal Solutions',  41, 969,  1),
('V96RT3',  'Sennosides', 'New World Imports',  2,  289,  0),
('W565K5',  'HELMINTHOSPORIUM SOROKINIANUM',  'ALK-Abello, Inc.', 42, 205,  1),
('X2UDJ4',  'enoxaparin sodium',  'sanofi-aventis U.S. LLC',  39, 759,  1),
('X73176',  'Camphor and Menthol',  'Quality Care Distributors LLC',  53, 410,  1),
('Y70CM7',  'not applicable', 'VitaMed, LLC', 8,  722,  0),
('Z4Z1XA',  'GLYCOPYRROLATE', 'Rising Pharmaceuticals Inc', 9,  503,  1),
('ZS817L',  'Carbamazepine',  'Teva Pharmaceuticals USA Inc', 49, 975,  1),
('ZSKP83',  'MORPHINE SULFATE', 'Paddock Laboratories, LLC',  56, 172,  0);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` binary(60) NOT NULL,
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `users` (`id`, `username`, `password`, `email`, `role`) VALUES
(4, 'rado', UNHEX('243279243130243456356A5A313954326F656979383743494D5035684F775A543951794F3277387647544858642E78584433636A6C74696C6C487265'),  'radovan.sroka@gmail.com',  '0'),
(5, 'admin',  UNHEX('243279243130246D716D33777A5361385445563457732F42515652367549614C744E646669387A73545870556856427076346B544C4374682F743169'),  'admin@this.com', 'admin');

-- 2016-11-16 20:00:43