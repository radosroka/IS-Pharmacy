-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `medicine` int(6) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '1',
  `ordered` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`,`user`,`medicine`),
  KEY `medicine` (`medicine`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`medicine`) REFERENCES `medicine` (`id_sukl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `id_sukl` int(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) COLLATE utf8_bin NOT NULL,
  `producer` varchar(1024) COLLATE utf8_bin NOT NULL,
  `distributor` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `prescription` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id_sukl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `medicine` (`id_sukl`, `name`, `producer`, `distributor`, `price`, `prescription`) VALUES
(1, 'Diltiazem Hydrochloride',  'NCS HealthCare of KY, Inc dba Vangard Labs', 2,  895,  CONV('1', 2, 10) + 0),
(2, 'Benzocaine', 'CVS Pharmacy', 38, 523,  CONV('1', 2, 10) + 0),
(3, 'Diclofenac Sodium and Misoprostol',  'Eagle Pharmaceuticals, Inc.',  58, 693,  CONV('0', 2, 10) + 0),
(4, 'Olanzapine', 'Macleods Pharmaceuticals Limited', 55, 136,  CONV('1', 2, 10) + 0),
(5, 'ACETAMINOPHEN',  'FREDS, INC', 46, 354,  CONV('1', 2, 10) + 0),
(6, 'Alcohol',  'Ecolab Inc.',  8,  340,  CONV('1', 2, 10) + 0),
(7, 'iron sucrose', 'Fresenius Medical Care North America', 56, 470,  CONV('1', 2, 10) + 0),
(8, 'CUTTLEFISH', 'Remedy Makers',  9,  191,  CONV('1', 2, 10) + 0),
(9, 'Lisinopril and Hydrochlorothiazide', 'Golden State Medical Supply, Inc.',  9,  691,  CONV('1', 2, 10) + 0),
(10,  'SUCRALFATE', 'State of Florida DOH Central Pharmacy',  41, 31, CONV('0', 2, 10) + 0),
(11,  'Fenofibric Acid',  'AbbVie Inc.',  7,  230,  CONV('1', 2, 10) + 0),
(12,  'phenobarbital',  'Atlantic Biologicals Corps', 6,  398,  CONV('1', 2, 10) + 0),
(13,  'Coal Tar', 'Family Dollar Services Inc', 5,  642,  CONV('1', 2, 10) + 0),
(14,  'OCTINOXATE, TITANIUM DIOXIDE, OXYBENZONE', 'Parfums Christian Dior', 53, 340,  CONV('0', 2, 10) + 0),
(15,  'Lamivudine and Zidovudine',  'Camber Pharmaceuticals, Inc.', 57, 60, CONV('1', 2, 10) + 0),
(16,  'Salicylic Acid', 'Dermalogica, Inc.',  54, 995,  CONV('0', 2, 10) + 0),
(17,  'probenecid', 'Mylan Pharmaceuticals Inc.', 26, 99, CONV('0', 2, 10) + 0),
(18,  'Phenylephrine HCl',  'Safeway',  58, 205,  CONV('1', 2, 10) + 0),
(19,  'Duloxetine', 'Lupin Pharmaceuticals, Inc.',  44, 84, CONV('1', 2, 10) + 0),
(20,  'benzoyl peroxide', 'Allergan, Inc.', 56, 405,  CONV('1', 2, 10) + 0),
(21,  'ibuprofen',  'Dolgencorp Inc', 49, 563,  CONV('0', 2, 10) + 0),
(22,  'Aluminum Zirconium Trichlorohydrex Gly', 'Procter Gamble Manufacturing Company', 7,  690,  CONV('0', 2, 10) + 0),
(23,  'nebivolol hydrochloride',  'Forest laboratories, Inc.',  9,  638,  CONV('0', 2, 10) + 0),
(24,  'Nitrous Oxide',  'General Air Service Supply Co',  4,  277,  CONV('1', 2, 10) + 0),
(25,  'ACYCLOVIR',  'Stat Rx USA',  37, 441,  CONV('1', 2, 10) + 0),
(26,  'Bismuth subsalicylate',  'Procter Gamble Manufacturing Company', 2,  588,  CONV('1', 2, 10) + 0),
(27,  'Triclosan',  'SJ Creations, Inc.', 6,  305,  CONV('0', 2, 10) + 0),
(28,  '0.63% Stannous Fluoride',  'Cypress Pharmaceutical, Inc.', 9,  520,  CONV('1', 2, 10) + 0),
(29,  'OCTINOXATE and TITANIUM DIOXIDE',  'NARS Cosmetics', 59, 904,  CONV('1', 2, 10) + 0),
(30,  'Phosphorus comp.', 'Uriel Pharmacy Inc.',  45, 805,  CONV('1', 2, 10) + 0),
(31,  'benazepril hydrochloride and hydrochlorothiazide', 'Clinical Solutions Wholesale', 57, 676,  CONV('0', 2, 10) + 0),
(32,  'Nortriptyline Hydrochloride',  'Watson Laboratories, Inc.',  51, 249,  CONV('0', 2, 10) + 0),
(33,  'PANTOPRAZOLE SODIUM',  'Wyeth Pharmaceuticals Inc., a subsidiary of Pfizer Inc.',  9,  349,  CONV('1', 2, 10) + 0),
(34,  'Tranexamic Acid',  'X-GEN Pharmaceuticals, Inc.',  37, 230,  CONV('1', 2, 10) + 0),
(35,  'Octinoxate, Octisalate', 'Lancaster S.A.M.', 52, 236,  CONV('1', 2, 10) + 0),
(36,  'glipizide',  'REMEDYREPACK INC.',  54, 305,  CONV('1', 2, 10) + 0),
(37,  'Menthol, Methyl salicylate', 'Perrigo New York Inc', 19, 362,  CONV('0', 2, 10) + 0),
(38,  'Cetirizine Hydrochloride and Pseudoephedrine Hydrochloride', 'McNeil Consumer Healthcare Div McNeil-PPC, Inc', 25, 171,  CONV('0', 2, 10) + 0),
(39,  'Miconazole nitrate', 'Walgreen Company', 57, 730,  CONV('0', 2, 10) + 0),
(40,  'Ensulizole Octinoxate',  'L\'Oreal USA Products Inc',  45, 679,  CONV('1', 2, 10) + 0),
(41,  'Guinea Pig Epithelium',  'Nelco Laboratories, Inc.', 57, 478,  CONV('1', 2, 10) + 0),
(42,  'ALUMINUM CHLOROHYDRATE', 'Dukal Corporation',  1,  514,  CONV('0', 2, 10) + 0),
(43,  'Testosterone', 'AbbVie Inc.',  6,  773,  CONV('1', 2, 10) + 0),
(44,  'Hyoscyamine Sulfate Extended-Release', 'County Line Pharmaceuticals, LLC', 48, 756,  CONV('0', 2, 10) + 0),
(45,  'acetaminophen, dextromethorphan hydrobromide, doxylamine succinate', 'Topco Associates LLC', 9,  184,  CONV('1', 2, 10) + 0),
(46,  'Quetiapine Fumarate',  'REMEDYREPACK INC.',  8,  82, CONV('1', 2, 10) + 0),
(47,  'GLYCERIN', 'AMI Cosmetic Co.,Ltd.',  5,  800,  CONV('0', 2, 10) + 0),
(48,  'Beta Vulgaris, Boldo, Carduus Marianus, Chelidonium Majus, Peteroselinum Sativum, Taraxacum Officinale', 'BioActive Nutritional, Inc.',  40, 284,  CONV('0', 2, 10) + 0),
(49,  'Titanium Dioxide', 'TONYMOLY CO., LTD.', 4,  31, CONV('1', 2, 10) + 0),
(50,  'Ethanol',  'Best Sanitizers, Inc', 9,  553,  CONV('0', 2, 10) + 0),
(51,  'EPICOCCUM NIGRUM', 'ALK-Abello, Inc.', 7,  86, CONV('0', 2, 10) + 0),
(52,  'White Petrolatum', 'Geiss, Destin and Dunn, Inc',  9,  688,  CONV('0', 2, 10) + 0),
(53,  'anthralin',  'Elorac Inc.',  16, 309,  CONV('0', 2, 10) + 0),
(54,  'Erythromycin', 'REMEDYREPACK INC.',  56, 726,  CONV('0', 2, 10) + 0),
(55,  'Terbinafine Hydrochloride',  'Physicians Total Care, Inc.',  5,  444,  CONV('0', 2, 10) + 0),
(56,  'Ketotifen Fumarate', 'Meijer Distribution Inc',  5,  485,  CONV('0', 2, 10) + 0),
(57,  'Lanolin, Petrolatum',  'Wal-Mart Stores Inc',  57, 393,  CONV('0', 2, 10) + 0),
(58,  'OCTINOXATE', 'LAURA GELLER MAKE UP INC.',  3,  199,  CONV('1', 2, 10) + 0),
(59,  'Cephalosporium', 'Antigen Laboratories, Inc.', 43, 589,  CONV('0', 2, 10) + 0),
(60,  'Loratadine', 'Western Family Foods Inc', 4,  159,  CONV('0', 2, 10) + 0),
(61,  'Chloroxylenol',  'Betco Corporation, Ltd.',  9,  324,  CONV('0', 2, 10) + 0),
(62,  'ALCOHOL',  'Rite Aid Corporation', 6,  89, CONV('1', 2, 10) + 0),
(63,  'Promethazine hydrochloride and phenylephrine hydrochloride', 'Bryant Ranch Prepack', 1,  418,  CONV('1', 2, 10) + 0),
(64,  'LOSARTAN POTASSIUM AND HYDROCHLOROTHIAZIDE', 'Unit Dose Services', 38, 770,  CONV('0', 2, 10) + 0),
(65,  'Amlodipine Besylate and Benazepril Hydrochloride', 'Dr.Reddy\'s Laboratories Limited', 47, 720,  CONV('1', 2, 10) + 0),
(66,  'Dexbrompheniramine Maleate, Pseudoephedrine',  'Llorens Pharmaceutical International Division',  50, 242,  CONV('0', 2, 10) + 0),
(67,  'GABAPENTIN', 'Greenstone LLC', 42, 722,  CONV('1', 2, 10) + 0),
(68,  'SPONGIA OFFICINALIS SKELETON, ROASTED and CALCIUM IODIDE and FUCUS VESICULOSUS and SILICON DIOXIDE and', 'Heel Inc', 56, 59, CONV('1', 2, 10) + 0),
(69,  'Promethazine Hydrochloride', 'Hi-Tech Pharmacal Co., Inc.',  9,  813,  CONV('0', 2, 10) + 0),
(70,  'cefoxitin sodium', 'Sagent Pharmaceuticals', 46, 182,  CONV('0', 2, 10) + 0),
(71,  'octinoxate, octisalate, zinc oxide, oxybenzone,',  'Mary Kay Inc.',  3,  161,  CONV('1', 2, 10) + 0),
(72,  'Red (River) Birch',  'Antigen Laboratories, Inc.', 3,  542,  CONV('1', 2, 10) + 0),
(73,  'Progesterone', 'Deseret Biologicals, Inc.',  7,  879,  CONV('0', 2, 10) + 0),
(74,  'bisacodyl',  'H and P Industries, Inc. dba Triad Group', 58, 5,  CONV('1', 2, 10) + 0),
(75,  'OCTINOXATE, OCTISALATE, and OXYBENZONE', 'Guthy-Renker LLC', 8,  477,  CONV('1', 2, 10) + 0),
(76,  'Acetaminophen',  'Safeway',  9,  729,  CONV('0', 2, 10) + 0),
(77,  'Quetiapine Fumarate',  'Teva Pharmaceuticals USA Inc', 54, 400,  CONV('0', 2, 10) + 0),
(78,  'Quetiapine Fumarate',  'AvKARE, Inc.', 2,  386,  CONV('1', 2, 10) + 0),
(79,  'Octinoxate', 'Elizabeth Arden, Inc', 9,  781,  CONV('0', 2, 10) + 0),
(80,  'TITANIUM DIOXIDE', 'Laboratoires Clarins S.A.',  9,  389,  CONV('0', 2, 10) + 0),
(81,  'naproxen sodium',  'Rebel Distributors Corp',  2,  905,  CONV('0', 2, 10) + 0),
(82,  'Clotrimazole', 'United Exchange Corp.',  9,  755,  CONV('0', 2, 10) + 0),
(83,  'TITANIUM DIOXIDE', 'Shanghai Justking Enterprise Co. Ltd.',  4,  586,  CONV('0', 2, 10) + 0),
(84,  'DOCUSATE SODIUM',  'PuraVation Pharmaceuticals Inc', 9,  402,  CONV('1', 2, 10) + 0),
(85,  'Pear', 'Antigen Laboratories, Inc.', 59, 763,  CONV('1', 2, 10) + 0),
(86,  'Methadone Hydrochloride',  'Lake Erie Medical DBA Quality Care Products LLC',  5,  176,  CONV('0', 2, 10) + 0),
(87,  'lisinopril', 'RedPharm Drug Inc.', 41, 828,  CONV('0', 2, 10) + 0),
(88,  'BENZALKONIUM CHLORIDE',  'Artemis Bio-Solutions Inc',  7,  366,  CONV('0', 2, 10) + 0),
(89,  'Ciprofloxacin',  'Carlsbad Technology, Inc.',  58, 918,  CONV('1', 2, 10) + 0),
(90,  'Phentermine Hydrochloride',  'Unit Dose Services', 7,  541,  CONV('0', 2, 10) + 0),
(91,  'GLYCERIN', 'MEGASOL COSMETIC GMBH',  33, 254,  CONV('0', 2, 10) + 0),
(92,  'Lidocaine Hydrochloride',  'LLC Federal Solutions',  41, 969,  CONV('1', 2, 10) + 0),
(93,  'Sennosides', 'New World Imports',  2,  289,  CONV('0', 2, 10) + 0),
(94,  'HELMINTHOSPORIUM SOROKINIANUM',  'ALK-Abello, Inc.', 42, 205,  CONV('1', 2, 10) + 0),
(95,  'enoxaparin sodium',  'sanofi-aventis U.S. LLC',  39, 759,  CONV('1', 2, 10) + 0),
(96,  'Camphor and Menthol',  'Quality Care Distributors LLC',  53, 410,  CONV('1', 2, 10) + 0),
(97,  'not applicable', 'VitaMed, LLC', 8,  722,  CONV('0', 2, 10) + 0),
(98,  'GLYCOPYRROLATE', 'Rising Pharmaceuticals Inc', 9,  503,  CONV('1', 2, 10) + 0),
(99,  'Carbamazepine',  'Teva Pharmaceuticals USA Inc', 49, 975,  CONV('1', 2, 10) + 0),
(100, 'MORPHINE SULFATE', 'Paddock Laboratories, LLC',  56, 172,  CONV('0', 2, 10) + 0);

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `city` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `street` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `code` int(5) NOT NULL,
  `handeled` bit(1) NOT NULL,
  `disallowed` bit(1) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`,`cart_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DROP TABLE IF EXISTS `orders_auto_increment`;
CREATE TABLE `orders_auto_increment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DROP TABLE IF EXISTS `prescription`;
CREATE TABLE `prescription` (
  `id` int(11) NOT NULL,
  `image` varchar(100) COLLATE utf8_bin NOT NULL,
  KEY `cart_id` (`id`),
  CONSTRAINT `prescription_ibfk_1` FOREIGN KEY (`id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


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
(6, 'zamestnanec',  UNHEX('243279243130246D716D33777A5361385445563457732F42515652367549614C744E646669387A73545870556856427076346B544C4374682F743169'),  'admin@this.com', 'employee');

-- 2016-12-03 19:15:13