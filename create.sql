-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL ,
  `cart_id` int(11),
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `city` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `street` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `code` int(5) NOT NULL,
  `handeled` bit NOT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`id`, `cart_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `medicine` int(6) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '1',
  `ordered` bit,
  PRIMARY KEY (`id`, `user`,`medicine`),
  KEY `medicine` (`medicine`),
  -- CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`medicine`) REFERENCES `medicine` (`id_sukl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `id_sukl` int(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) COLLATE utf8_bin NOT NULL,
  `producer` varchar(1024) COLLATE utf8_bin NOT NULL,
  `distributor` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `prescription` bit DEFAULT NULL,
  PRIMARY KEY (`id_sukl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `orders_auto_increment`;
CREATE TABLE `orders_auto_increment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` bit NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `medicine` (`name`, `producer`, `distributor`, `price`, `prescription`) VALUES
('Diltiazem Hydrochloride',  'NCS HealthCare of KY, Inc dba Vangard Labs', 2,  895,  1),
('Benzocaine', 'CVS Pharmacy', 38, 523,  1),
('Diclofenac Sodium and Misoprostol',  'Eagle Pharmaceuticals, Inc.',  58, 693,  0),
('Olanzapine', 'Macleods Pharmaceuticals Limited', 55, 136,  1),
('ACETAMINOPHEN',  'FREDS, INC', 46, 354,  1),
('Alcohol',  'Ecolab Inc.',  8,  340,  1),
('iron sucrose', 'Fresenius Medical Care North America', 56, 470,  1),
('CUTTLEFISH', 'Remedy Makers',  9,  191,  1),
('Lisinopril and Hydrochlorothiazide', 'Golden State Medical Supply, Inc.',  9,  691,  1),
('SUCRALFATE', 'State of Florida DOH Central Pharmacy',  41, 31, 0),
('Fenofibric Acid',  'AbbVie Inc.',  7,  230,  1),
('phenobarbital',  'Atlantic Biologicals Corps', 6,  398,  1),
('Coal Tar', 'Family Dollar Services Inc', 5,  642,  1),
('OCTINOXATE, TITANIUM DIOXIDE, OXYBENZONE', 'Parfums Christian Dior', 53, 340,  0),
('Lamivudine and Zidovudine',  'Camber Pharmaceuticals, Inc.', 57, 60, 1),
('Salicylic Acid', 'Dermalogica, Inc.',  54, 995,  0),
('probenecid', 'Mylan Pharmaceuticals Inc.', 26, 99, 0),
('Phenylephrine HCl',  'Safeway',  58, 205,  1),
('Duloxetine', 'Lupin Pharmaceuticals, Inc.',  44, 84, 1),
('benzoyl peroxide', 'Allergan, Inc.', 56, 405,  1),
('ibuprofen',  'Dolgencorp Inc', 49, 563,  0),
('Aluminum Zirconium Trichlorohydrex Gly', 'Procter Gamble Manufacturing Company', 7,  690,  0),
('nebivolol hydrochloride',  'Forest laboratories, Inc.',  9,  638,  0),
('Nitrous Oxide',  'General Air Service Supply Co',  4,  277,  1),
('ACYCLOVIR',  'Stat Rx USA',  37, 441,  1),
('Bismuth subsalicylate',  'Procter Gamble Manufacturing Company', 2,  588,  1),
('Triclosan',  'SJ Creations, Inc.', 6,  305,  0),
('0.63% Stannous Fluoride',  'Cypress Pharmaceutical, Inc.', 9,  520,  1),
('OCTINOXATE and TITANIUM DIOXIDE',  'NARS Cosmetics', 59, 904,  1),
('Phosphorus comp.', 'Uriel Pharmacy Inc.',  45, 805,  1),
('benazepril hydrochloride and hydrochlorothiazide', 'Clinical Solutions Wholesale', 57, 676,  0),
('Nortriptyline Hydrochloride',  'Watson Laboratories, Inc.',  51, 249,  0),
('PANTOPRAZOLE SODIUM',  'Wyeth Pharmaceuticals Inc., a subsidiary of Pfizer Inc.',  9,  349,  1),
('Tranexamic Acid',  'X-GEN Pharmaceuticals, Inc.',  37, 230,  1),
('Octinoxate, Octisalate', 'Lancaster S.A.M.', 52, 236,  1),
('glipizide',  'REMEDYREPACK INC.',  54, 305,  1),
('Menthol, Methyl salicylate', 'Perrigo New York Inc', 19, 362,  0),
('Cetirizine Hydrochloride and Pseudoephedrine Hydrochloride', 'McNeil Consumer Healthcare Div McNeil-PPC, Inc', 25, 171,  0),
('Miconazole nitrate', 'Walgreen Company', 57, 730,  0),
('Ensulizole Octinoxate',  'L\'Oreal USA Products Inc',  45, 679,  1),
('Guinea Pig Epithelium',  'Nelco Laboratories, Inc.', 57, 478,  1),
('ALUMINUM CHLOROHYDRATE', 'Dukal Corporation',  1,  514,  0),
('Testosterone', 'AbbVie Inc.',  6,  773,  1),
('Hyoscyamine Sulfate Extended-Release', 'County Line Pharmaceuticals, LLC', 48, 756,  0),
('acetaminophen, dextromethorphan hydrobromide, doxylamine succinate', 'Topco Associates LLC', 9,  184,  1),
('Quetiapine Fumarate',  'REMEDYREPACK INC.',  8,  82, 1),
('GLYCERIN', 'AMI Cosmetic Co.,Ltd.',  5,  800,  0),
('Beta Vulgaris, Boldo, Carduus Marianus, Chelidonium Majus, Peteroselinum Sativum, Taraxacum Officinale', 'BioActive Nutritional, Inc.',  40, 284,  0),
('Titanium Dioxide', 'TONYMOLY CO., LTD.', 4,  31, 1),
('Ethanol',  'Best Sanitizers, Inc', 9,  553,  0),
('EPICOCCUM NIGRUM', 'ALK-Abello, Inc.', 7,  86, 0),
('White Petrolatum', 'Geiss, Destin and Dunn, Inc',  9,  688,  0),
('anthralin',  'Elorac Inc.',  16, 309,  0),
('Erythromycin', 'REMEDYREPACK INC.',  56, 726,  0),
('Terbinafine Hydrochloride',  'Physicians Total Care, Inc.',  5,  444,  0),
('Ketotifen Fumarate', 'Meijer Distribution Inc',  5,  485,  0),
('Lanolin, Petrolatum',  'Wal-Mart Stores Inc',  57, 393,  0),
('OCTINOXATE', 'LAURA GELLER MAKE UP INC.',  3,  199,  1),
('Cephalosporium', 'Antigen Laboratories, Inc.', 43, 589,  0),
('Loratadine', 'Western Family Foods Inc', 4,  159,  0),
('Chloroxylenol',  'Betco Corporation, Ltd.',  9,  324,  0),
('ALCOHOL',  'Rite Aid Corporation', 6,  89, 1),
('Promethazine hydrochloride and phenylephrine hydrochloride', 'Bryant Ranch Prepack', 1,  418,  1),
('LOSARTAN POTASSIUM AND HYDROCHLOROTHIAZIDE', 'Unit Dose Services', 38, 770,  0),
('Amlodipine Besylate and Benazepril Hydrochloride', 'Dr.Reddy\'s Laboratories Limited', 47, 720,  1),
('Dexbrompheniramine Maleate, Pseudoephedrine',  'Llorens Pharmaceutical International Division',  50, 242,  0),
('GABAPENTIN', 'Greenstone LLC', 42, 722,  1),
('SPONGIA OFFICINALIS SKELETON, ROASTED and CALCIUM IODIDE and FUCUS VESICULOSUS and SILICON DIOXIDE and', 'Heel Inc', 56, 59, 1),
('Promethazine Hydrochloride', 'Hi-Tech Pharmacal Co., Inc.',  9,  813,  0),
('cefoxitin sodium', 'Sagent Pharmaceuticals', 46, 182,  0),
('octinoxate, octisalate, zinc oxide, oxybenzone,',  'Mary Kay Inc.',  3,  161,  1),
('Red (River) Birch',  'Antigen Laboratories, Inc.', 3,  542,  1),
('Progesterone', 'Deseret Biologicals, Inc.',  7,  879,  0),
('bisacodyl',  'H and P Industries, Inc. dba Triad Group', 58, 5,  1),
('OCTINOXATE, OCTISALATE, and OXYBENZONE', 'Guthy-Renker LLC', 8,  477,  1),
('Acetaminophen',  'Safeway',  9,  729,  0),
('Quetiapine Fumarate',  'Teva Pharmaceuticals USA Inc', 54, 400,  0),
('Quetiapine Fumarate',  'AvKARE, Inc.', 2,  386,  1),
('Octinoxate', 'Elizabeth Arden, Inc', 9,  781,  0),
('TITANIUM DIOXIDE', 'Laboratoires Clarins S.A.',  9,  389,  0),
('naproxen sodium',  'Rebel Distributors Corp',  2,  905,  0),
('Clotrimazole', 'United Exchange Corp.',  9,  755,  0),
('TITANIUM DIOXIDE', 'Shanghai Justking Enterprise Co. Ltd.',  4,  586,  0),
('DOCUSATE SODIUM',  'PuraVation Pharmaceuticals Inc', 9,  402,  1),
('Pear', 'Antigen Laboratories, Inc.', 59, 763,  1),
('Methadone Hydrochloride',  'Lake Erie Medical DBA Quality Care Products LLC',  5,  176,  0),
('lisinopril', 'RedPharm Drug Inc.', 41, 828,  0),
('BENZALKONIUM CHLORIDE',  'Artemis Bio-Solutions Inc',  7,  366,  0),
('Ciprofloxacin',  'Carlsbad Technology, Inc.',  58, 918,  1),
('Phentermine Hydrochloride',  'Unit Dose Services', 7,  541,  0),
('GLYCERIN', 'MEGASOL COSMETIC GMBH',  33, 254,  0),
('Lidocaine Hydrochloride',  'LLC Federal Solutions',  41, 969,  1),
('Sennosides', 'New World Imports',  2,  289,  0),
('HELMINTHOSPORIUM SOROKINIANUM',  'ALK-Abello, Inc.', 42, 205,  1),
('enoxaparin sodium',  'sanofi-aventis U.S. LLC',  39, 759,  1),
('Camphor and Menthol',  'Quality Care Distributors LLC',  53, 410,  1),
('not applicable', 'VitaMed, LLC', 8,  722,  0),
('GLYCOPYRROLATE', 'Rising Pharmaceuticals Inc', 9,  503,  1),
('Carbamazepine',  'Teva Pharmaceuticals USA Inc', 49, 975,  1),
('MORPHINE SULFATE', 'Paddock Laboratories, LLC',  56, 172,  0);

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
(5, 'mainadmin',  UNHEX('243279243130246D716D33777A5361385445563457732F42515652367549614C744E646669387A73545870556856427076346B544C4374682F743169'),  'admin@this.com', 'mainAdmin'),
(6, 'admin',  UNHEX('243279243130246D716D33777A5361385445563457732F42515652367549614C744E646669387A73545870556856427076346B544C4374682F743169'),  'admin@this.com', 'admin');

-- 2016-11-16 23:49:39