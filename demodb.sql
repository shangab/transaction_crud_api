SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";
CREATE DATABASE IF NOT EXISTS `demodb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `demodb`;

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullname` varchar(40) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

INSERT INTO `customers` (`id`, `fullname`, `phone`) VALUES
(1, 'Ricky Max', '+14 (342) 346-9054'),
(2, 'Scotty Harlan', '+8 (200) 491-2600'),
(3, 'Douglas Murray', '+0 (841) 361-5333'),
(4, 'Spencer Alan', '+19 (640) 200-6503'),
(5, 'Derek Rami', '+7 (232) 836-4363'),
(6, 'Clinton Mohammed', '+6 (969) 725-3332'),
(7, 'Caleb Jarred', '+2 (245) 899-1809'),
(8, 'Nathan Ali', '+15 (200) 515-7488'),
(9, 'Enrique Eddie', '+5 (299) 205-4265'),
(10, 'David Sung', '+12 (200) 264-9823');

DROP TABLE IF EXISTS `orderitems`;
CREATE TABLE IF NOT EXISTS `orderitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productid` int(4) DEFAULT NULL,
  `qty` int(4) DEFAULT NULL,
  `totalprice` decimal(10,2) DEFAULT NULL,
  `unitprice` decimal(10,2) DEFAULT NULL,
  `orderid` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=latin1;

INSERT INTO `orderitems` (`id`, `productid`, `qty`, `totalprice`, `unitprice`, `orderid`) VALUES
(1, 1, 5, '2.00', '23.00', 28),
(2, 3, 4, '3.00', '13.00', 41),
(3, 1, 2, '2.00', '16.00', 98),
(4, 1, 2, '2.00', '24.00', 59),
(5, 3, 5, '4.00', '22.00', 98),
(6, 2, 4, '3.00', '19.00', 97),
(7, 1, 6, '2.00', '25.00', 51),
(8, 1, 2, '4.00', '23.00', 82),
(9, 2, 6, '4.00', '30.00', 11),
(10, 2, 2, '3.00', '18.00', 81),
(11, 3, 4, '2.00', '25.00', 65),
(12, 1, 5, '3.00', '19.00', 11),
(13, 3, 2, '2.00', '24.00', 35),
(14, 1, 3, '3.00', '29.00', 87),
(15, 3, 2, '3.00', '18.00', 38),
(16, 1, 2, '4.00', '18.00', 33),
(17, 1, 6, '2.00', '31.00', 27),
(18, 1, 3, '3.00', '22.00', 75),
(19, 3, 5, '2.00', '30.00', 28),
(20, 1, 2, '4.00', '30.00', 5),
(21, 1, 2, '2.00', '12.00', 93),
(22, 3, 3, '2.00', '17.00', 46),
(23, 3, 2, '3.00', '12.00', 64),
(24, 2, 4, '4.00', '27.00', 68),
(25, 2, 5, '2.00', '30.00', 25),
(26, 3, 2, '3.00', '24.00', 38),
(27, 1, 2, '4.00', '29.00', 68),
(28, 3, 4, '4.00', '30.00', 74),
(29, 3, 2, '4.00', '28.00', 63),
(30, 3, 5, '4.00', '19.00', 6),
(31, 2, 6, '2.00', '30.00', 34),
(32, 1, 5, '3.00', '31.00', 43),
(33, 2, 2, '3.00', '22.00', 30),
(34, 3, 5, '3.00', '25.00', 46),
(35, 3, 2, '3.00', '18.00', 43),
(36, 1, 6, '3.00', '12.00', 48),
(37, 2, 2, '4.00', '24.00', 53),
(38, 3, 2, '3.00', '14.00', 31),
(39, 1, 6, '4.00', '25.00', 84),
(40, 2, 3, '3.00', '27.00', 14),
(41, 1, 4, '2.00', '22.00', 69),
(42, 2, 4, '4.00', '15.00', 64),
(43, 1, 6, '2.00', '13.00', 16),
(44, 3, 2, '3.00', '19.00', 21),
(45, 1, 2, '3.00', '20.00', 92),
(46, 1, 6, '2.00', '21.00', 5),
(47, 1, 3, '3.00', '18.00', 84),
(48, 1, 2, '2.00', '29.00', 82),
(49, 1, 5, '2.00', '26.00', 62),
(50, 3, 2, '3.00', '13.00', 24),
(51, 1, 2, '3.00', '29.00', 75),
(52, 1, 3, '4.00', '22.00', 91),
(53, 1, 5, '3.00', '12.00', 83),
(54, 3, 2, '4.00', '28.00', 40),
(55, 2, 6, '2.00', '30.00', 32),
(56, 1, 2, '4.00', '21.00', 38),
(57, 1, 3, '2.00', '16.00', 17),
(58, 1, 2, '2.00', '18.00', 32),
(59, 3, 6, '3.00', '15.00', 5),
(60, 1, 2, '3.00', '18.00', 6),
(61, 1, 4, '2.00', '12.00', 5),
(62, 1, 2, '4.00', '24.00', 16),
(63, 2, 2, '4.00', '12.00', 53),
(64, 2, 2, '2.00', '30.00', 30),
(65, 2, 6, '2.00', '26.00', 59),
(66, 1, 3, '4.00', '16.00', 82),
(67, 2, 6, '4.00', '18.00', 47),
(68, 2, 3, '3.00', '22.00', 17),
(69, 1, 2, '3.00', '17.00', 4),
(70, 1, 2, '4.00', '28.00', 97),
(71, 1, 2, '2.00', '20.00', 75),
(72, 1, 5, '3.00', '21.00', 1),
(73, 1, 6, '4.00', '19.00', 83),
(74, 1, 2, '2.00', '19.00', 42),
(75, 1, 4, '4.00', '12.00', 24),
(76, 1, 3, '3.00', '17.00', 86),
(77, 2, 2, '3.00', '22.00', 64),
(78, 1, 3, '2.00', '18.00', 44),
(79, 3, 4, '3.00', '14.00', 70),
(80, 3, 2, '4.00', '30.00', 56),
(81, 3, 2, '2.00', '17.00', 99),
(82, 3, 2, '2.00', '24.00', 96),
(83, 3, 5, '4.00', '19.00', 45),
(84, 1, 5, '3.00', '29.00', 76),
(85, 3, 6, '4.00', '15.00', 59),
(86, 2, 3, '4.00', '16.00', 61),
(87, 1, 5, '2.00', '28.00', 96),
(88, 1, 2, '2.00', '19.00', 79),
(89, 2, 2, '2.00', '13.00', 85),
(90, 2, 6, '2.00', '27.00', 38),
(91, 2, 4, '4.00', '17.00', 69),
(92, 1, 3, '2.00', '22.00', 57),
(93, 1, 3, '4.00', '28.00', 84),
(94, 2, 3, '2.00', '24.00', 97),
(95, 2, 2, '4.00', '26.00', 43),
(96, 1, 5, '4.00', '16.00', 37),
(97, 1, 3, '4.00', '16.00', 93),
(98, 1, 2, '4.00', '19.00', 78),
(99, 2, 2, '2.00', '24.00', 52),
(100, 1, 3, '3.00', '14.00', 85),
(101, 1, 3, '2.00', '29.00', 85),
(102, 3, 6, '2.00', '18.00', 65),
(103, 1, 2, '3.00', '22.00', 51),
(104, 2, 2, '4.00', '23.00', 72),
(105, 1, 3, '3.00', '24.00', 16),
(106, 1, 2, '3.00', '19.00', 45),
(107, 1, 2, '4.00', '26.00', 63),
(108, 1, 2, '2.00', '28.00', 41),
(109, 3, 2, '4.00', '18.00', 19),
(110, 2, 5, '2.00', '22.00', 93),
(111, 1, 6, '3.00', '18.00', 19),
(112, 2, 6, '2.00', '15.00', 77),
(113, 3, 3, '2.00', '19.00', 98),
(114, 3, 2, '4.00', '15.00', 24),
(115, 1, 2, '4.00', '21.00', 33),
(116, 1, 4, '2.00', '17.00', 71),
(117, 2, 4, '4.00', '29.00', 29),
(118, 3, 5, '4.00', '22.00', 8),
(119, 3, 5, '2.00', '14.00', 49),
(120, 3, 2, '2.00', '13.00', 40),
(121, 2, 3, '4.00', '17.00', 85),
(122, 2, 5, '2.00', '30.00', 94),
(123, 2, 3, '3.00', '18.00', 39),
(124, 3, 6, '4.00', '26.00', 84),
(125, 3, 5, '2.00', '24.00', 45),
(126, 2, 6, '4.00', '13.00', 55),
(127, 1, 2, '4.00', '24.00', 22),
(128, 1, 2, '3.00', '13.00', 94),
(129, 2, 3, '2.00', '20.00', 4),
(130, 1, 2, '4.00', '22.00', 41),
(131, 2, 2, '3.00', '29.00', 82),
(132, 1, 2, '4.00', '31.00', 1),
(133, 3, 6, '3.00', '29.00', 94),
(134, 1, 2, '2.00', '13.00', 42),
(135, 1, 2, '3.00', '30.00', 63),
(136, 2, 6, '4.00', '26.00', 71),
(137, 1, 4, '2.00', '19.00', 43),
(138, 1, 3, '4.00', '13.00', 30),
(139, 1, 5, '2.00', '30.00', 67),
(140, 2, 2, '2.00', '22.00', 50),
(141, 1, 2, '2.00', '22.00', 18),
(142, 1, 3, '2.00', '29.00', 54),
(143, 3, 5, '4.00', '25.00', 7),
(144, 2, 6, '4.00', '18.00', 38),
(145, 1, 4, '3.00', '15.00', 59),
(146, 3, 2, '3.00', '21.00', 51),
(147, 2, 2, '3.00', '21.00', 87),
(148, 1, 2, '2.00', '17.00', 74),
(149, 1, 2, '4.00', '13.00', 47),
(150, 2, 2, '4.00', '12.00', 61),
(151, 1, 5, '4.00', '22.00', 79),
(152, 3, 2, '3.00', '19.00', 39),
(153, 1, 3, '2.00', '14.00', 55),
(154, 1, 3, '3.00', '16.00', 2),
(155, 1, 5, '2.00', '18.00', 12),
(156, 2, 4, '3.00', '28.00', 87),
(157, 3, 4, '2.00', '23.00', 33),
(158, 2, 3, '2.00', '17.00', 28),
(159, 1, 3, '4.00', '17.00', 42),
(160, 3, 4, '3.00', '13.00', 9),
(161, 1, 3, '2.00', '26.00', 42),
(162, 3, 2, '2.00', '14.00', 12),
(163, 2, 5, '2.00', '12.00', 25),
(164, 1, 4, '3.00', '25.00', 21),
(165, 2, 5, '4.00', '29.00', 27),
(166, 1, 2, '2.00', '18.00', 44),
(167, 1, 2, '4.00', '19.00', 7),
(168, 1, 5, '2.00', '25.00', 83),
(169, 1, 3, '4.00', '27.00', 56),
(170, 2, 2, '3.00', '17.00', 65),
(171, 3, 2, '4.00', '29.00', 9),
(172, 1, 2, '3.00', '13.00', 41),
(173, 1, 3, '4.00', '24.00', 83),
(174, 2, 5, '2.00', '27.00', 97),
(175, 1, 2, '2.00', '14.00', 64),
(176, 2, 4, '2.00', '21.00', 34),
(177, 3, 2, '3.00', '14.00', 23),
(178, 1, 4, '2.00', '21.00', 43),
(179, 2, 6, '2.00', '13.00', 27),
(180, 1, 2, '3.00', '17.00', 17),
(181, 2, 6, '4.00', '31.00', 95),
(182, 1, 5, '4.00', '21.00', 22),
(183, 3, 2, '2.00', '23.00', 10),
(184, 3, 6, '2.00', '12.00', 76),
(185, 3, 2, '4.00', '19.00', 55),
(186, 3, 2, '2.00', '27.00', 98),
(187, 2, 2, '2.00', '23.00', 47),
(188, 3, 2, '4.00', '21.00', 72),
(189, 2, 4, '2.00', '16.00', 29),
(190, 1, 2, '2.00', '22.00', 64),
(191, 1, 2, '3.00', '24.00', 77),
(192, 3, 2, '2.00', '14.00', 26),
(193, 1, 2, '2.00', '31.00', 50),
(194, 1, 4, '2.00', '29.00', 99),
(195, 3, 2, '3.00', '29.00', 48),
(196, 3, 6, '3.00', '20.00', 8),
(197, 3, 5, '4.00', '25.00', 55),
(198, 1, 6, '3.00', '26.00', 21),
(199, 1, 5, '3.00', '27.00', 78),
(200, 3, 2, '3.00', '27.00', 23),
(201, 1, 6, '3.00', '16.00', 9),
(202, 2, 2, '3.00', '12.00', 76),
(203, 3, 2, '4.00', '17.00', 42),
(204, 3, 2, '4.00', '31.00', 10),
(205, 3, 4, '4.00', '13.00', 25),
(206, 1, 3, '4.00', '20.00', 96),
(207, 1, 2, '4.00', '12.00', 79),
(208, 2, 2, '3.00', '20.00', 44),
(209, 3, 2, '4.00', '25.00', 93),
(210, 2, 2, '3.00', '19.00', 11),
(211, 1, 5, '3.00', '27.00', 36),
(212, 2, 6, '2.00', '25.00', 17),
(213, 1, 4, '4.00', '25.00', 30),
(214, 3, 3, '2.00', '23.00', 82),
(215, 2, 6, '3.00', '14.00', 33),
(216, 3, 5, '2.00', '28.00', 37),
(217, 3, 2, '2.00', '26.00', 14),
(218, 1, 6, '3.00', '21.00', 90),
(219, 3, 2, '3.00', '28.00', 37),
(220, 1, 6, '3.00', '15.00', 25),
(221, 2, 2, '3.00', '23.00', 38),
(222, 2, 2, '4.00', '22.00', 88),
(223, 2, 2, '2.00', '31.00', 40),
(224, 1, 2, '2.00', '21.00', 76),
(225, 1, 6, '3.00', '18.00', 55),
(226, 3, 2, '4.00', '30.00', 16),
(227, 1, 6, '4.00', '19.00', 22),
(228, 1, 2, '3.00', '27.00', 50),
(229, 1, 2, '3.00', '29.00', 6),
(230, 1, 2, '3.00', '28.00', 49),
(231, 3, 5, '2.00', '25.00', 81),
(232, 3, 4, '4.00', '23.00', 32),
(233, 1, 6, '2.00', '12.00', 26),
(234, 2, 2, '3.00', '26.00', 33),
(235, 1, 5, '3.00', '23.00', 74),
(236, 1, 2, '2.00', '18.00', 40),
(237, 2, 4, '2.00', '25.00', 82),
(238, 1, 3, '3.00', '20.00', 92),
(239, 2, 3, '4.00', '28.00', 38),
(240, 2, 2, '4.00', '23.00', 66),
(241, 1, 3, '2.00', '28.00', 3),
(242, 3, 2, '2.00', '20.00', 63),
(243, 2, 3, '4.00', '13.00', 57),
(244, 1, 5, '4.00', '18.00', 93),
(245, 1, 6, '2.00', '29.00', 35),
(246, 2, 3, '2.00', '12.00', 76),
(247, 1, 6, '2.00', '20.00', 40),
(248, 1, 3, '3.00', '24.00', 58),
(249, 2, 5, '4.00', '19.00', 1),
(250, 1, 5, '2.00', '17.00', 91),
(251, 1, 5, '4.00', '14.00', 51),
(252, 3, 3, '3.00', '16.00', 78),
(253, 1, 2, '3.00', '26.00', 24),
(254, 1, 2, '3.00', '23.00', 45),
(255, 2, 6, '3.00', '18.00', 69),
(256, 1, 6, '2.00', '21.00', 85),
(257, 1, 2, '3.00', '17.00', 28),
(258, 1, 5, '2.00', '16.00', 81),
(259, 1, 2, '2.00', '21.00', 66),
(260, 3, 3, '4.00', '31.00', 62),
(261, 1, 2, '2.00', '12.00', 18),
(262, 1, 2, '4.00', '21.00', 62),
(263, 2, 2, '4.00', '14.00', 30),
(264, 2, 4, '2.00', '27.00', 5),
(265, 2, 6, '4.00', '17.00', 34),
(266, 2, 4, '4.00', '27.00', 47),
(267, 1, 5, '3.00', '24.00', 66),
(268, 1, 5, '3.00', '16.00', 37),
(269, 1, 2, '4.00', '12.00', 57),
(270, 1, 2, '3.00', '13.00', 90),
(271, 2, 6, '2.00', '13.00', 77),
(272, 3, 5, '4.00', '12.00', 28),
(273, 1, 6, '2.00', '20.00', 85),
(274, 1, 4, '4.00', '24.00', 76),
(275, 1, 4, '4.00', '18.00', 81),
(276, 3, 2, '3.00', '14.00', 91),
(277, 1, 2, '4.00', '26.00', 81),
(278, 1, 5, '3.00', '31.00', 38),
(279, 2, 2, '2.00', '22.00', 38),
(280, 2, 4, '4.00', '19.00', 50),
(281, 1, 2, '2.00', '14.00', 70),
(282, 3, 2, '3.00', '24.00', 26),
(283, 2, 2, '4.00', '30.00', 21),
(284, 1, 2, '3.00', '30.00', 52),
(285, 1, 2, '3.00', '26.00', 76),
(286, 1, 2, '4.00', '30.00', 94),
(287, 1, 6, '2.00', '29.00', 48),
(288, 3, 2, '4.00', '26.00', 90),
(289, 1, 5, '2.00', '12.00', 77),
(290, 2, 2, '3.00', '25.00', 48),
(291, 2, 2, '2.00', '23.00', 15),
(292, 1, 5, '4.00', '25.00', 62),
(293, 3, 2, '4.00', '29.00', 61),
(294, 1, 4, '2.00', '14.00', 79),
(295, 1, 5, '2.00', '17.00', 28),
(296, 3, 2, '2.00', '14.00', 69),
(297, 3, 2, '3.00', '24.00', 27),
(298, 1, 4, '2.00', '12.00', 99),
(299, 3, 2, '3.00', '30.00', 10),
(300, 1, 3, '3.00', '31.00', 95);

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerid` int(4) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;

INSERT INTO `orders` (`id`, `customerid`, `date`, `amount`) VALUES
(1, 4, '2019-01-01 10:48:48', '262.00'),
(2, 1, '2019-08-06 01:19:28', '48.00'),
(3, 2, '2019-03-11 03:35:55', '84.00'),
(4, 1, '2019-09-22 05:28:19', '94.00'),
(5, 5, '2019-11-23 09:21:31', '432.00'),
(6, 5, '2019-01-24 02:55:12', '189.00'),
(7, 8, '2019-08-27 12:35:23', '163.00'),
(8, 1, '2019-10-22 02:12:59', '230.00'),
(9, 1, '2019-10-03 03:19:06', '206.00'),
(10, 6, '2019-02-03 02:35:09', '168.00'),
(11, 1, '2019-01-23 07:09:58', '313.00'),
(12, 9, '2019-10-05 06:46:54', '118.00'),
(13, 1, '2019-05-10 01:35:53', '0.00'),
(14, 5, '2019-06-11 03:25:16', '133.00'),
(15, 1, '2019-06-28 03:13:54', '46.00'),
(16, 6, '2019-08-16 06:53:15', '258.00'),
(17, 1, '2019-10-27 01:29:13', '298.00'),
(18, 3, '2019-12-03 08:30:55', '68.00'),
(19, 5, '2019-10-15 07:43:17', '144.00'),
(20, 6, '2019-12-11 09:47:14', '0.00'),
(21, 1, '2019-08-08 12:27:49', '354.00'),
(22, 9, '2019-09-05 10:59:59', '267.00'),
(23, 5, '2019-10-18 04:41:25', '82.00'),
(24, 8, '2019-02-26 08:42:42', '156.00'),
(25, 5, '2019-09-27 06:03:13', '352.00'),
(26, 6, '2019-01-23 06:31:54', '148.00'),
(27, 1, '2019-02-24 04:18:16', '457.00'),
(28, 3, '2019-06-04 08:52:48', '495.00'),
(29, 1, '2019-02-23 08:17:47', '180.00'),
(30, 2, '2019-07-06 01:53:02', '271.00'),
(31, 6, '2019-08-24 08:41:20', '28.00'),
(32, 8, '2019-03-08 09:24:42', '308.00'),
(33, 8, '2019-04-14 09:21:56', '306.00'),
(34, 1, '2019-07-14 09:08:01', '366.00'),
(35, 7, '2019-01-16 02:01:41', '222.00'),
(36, 9, '2019-11-16 08:04:39', '135.00'),
(37, 1, '2019-04-03 10:48:07', '356.00'),
(38, 3, '2019-07-10 09:29:15', '725.00'),
(39, 7, '2019-08-17 01:18:06', '92.00'),
(40, 4, '2019-08-17 10:50:58', '300.00'),
(41, 8, '2019-06-12 06:02:46', '178.00'),
(42, 6, '2019-04-18 06:26:07', '227.00'),
(43, 4, '2019-12-08 07:55:03', '403.00'),
(44, 7, '2019-06-07 09:27:35', '130.00'),
(45, 2, '2019-06-17 04:08:53', '299.00'),
(46, 6, '2019-10-26 09:07:36', '176.00'),
(47, 3, '2019-08-18 02:11:19', '288.00'),
(48, 4, '2019-01-06 02:46:06', '354.00'),
(49, 5, '2019-10-18 06:40:04', '126.00'),
(50, 9, '2019-09-01 02:18:24', '236.00'),
(51, 2, '2019-09-17 03:45:51', '306.00'),
(52, 8, '2019-05-27 11:29:59', '108.00'),
(53, 1, '2019-01-07 11:05:24', '72.00'),
(54, 9, '2019-04-01 02:41:36', '87.00'),
(55, 5, '2019-06-15 09:27:11', '391.00'),
(56, 5, '2019-02-25 02:07:12', '141.00'),
(57, 3, '2019-06-28 10:11:11', '129.00'),
(58, 1, '2019-05-26 01:58:02', '72.00'),
(59, 4, '2019-09-01 04:59:22', '354.00'),
(60, 1, '2019-09-21 03:06:53', '0.00'),
(61, 6, '2019-09-14 08:53:01', '130.00'),
(62, 7, '2019-05-24 05:13:14', '390.00'),
(63, 6, '2019-11-16 08:42:43', '208.00'),
(64, 1, '2019-04-05 05:42:55', '200.00'),
(65, 6, '2019-09-16 06:39:13', '242.00'),
(66, 5, '2019-10-21 08:59:30', '208.00'),
(67, 3, '2019-12-05 04:02:28', '150.00'),
(68, 6, '2019-12-22 08:40:58', '166.00'),
(69, 4, '2019-04-22 12:14:40', '292.00'),
(70, 6, '2019-04-12 10:26:07', '84.00'),
(71, 1, '2019-07-22 08:10:36', '224.00'),
(72, 2, '2019-05-22 02:20:06', '88.00'),
(73, 2, '2019-03-17 08:45:51', '0.00'),
(74, 7, '2019-10-08 01:14:04', '269.00'),
(75, 5, '2019-06-01 08:47:06', '164.00'),
(76, 1, '2019-12-10 02:22:05', '467.00'),
(77, 2, '2019-05-04 06:15:44', '276.00'),
(78, 1, '2019-01-25 11:35:13', '221.00'),
(79, 2, '2019-05-05 05:19:00', '228.00'),
(80, 1, '2019-05-18 05:22:54', '0.00'),
(81, 5, '2019-07-19 03:02:05', '365.00'),
(82, 8, '2019-11-16 02:06:02', '379.00'),
(83, 8, '2019-08-25 04:54:15', '371.00'),
(84, 4, '2019-03-01 03:51:36', '444.00'),
(85, 3, '2019-01-07 01:13:50', '452.00'),
(86, 1, '2019-06-25 05:18:06', '51.00'),
(87, 1, '2019-05-12 06:20:18', '241.00'),
(88, 2, '2019-04-22 08:33:43', '44.00'),
(89, 1, '2019-09-23 08:02:15', '0.00'),
(90, 4, '2019-08-18 04:13:06', '204.00'),
(91, 2, '2019-03-05 08:50:46', '179.00'),
(92, 1, '2019-01-21 02:57:05', '100.00'),
(93, 1, '2019-10-26 11:41:17', '322.00'),
(94, 8, '2019-06-24 10:51:56', '410.00'),
(95, 7, '2019-07-25 11:14:19', '279.00'),
(96, 3, '2019-11-15 09:35:28', '248.00'),
(97, 1, '2019-01-04 01:48:23', '339.00'),
(98, 6, '2019-06-25 10:06:14', '253.00'),
(99, 8, '2019-10-13 01:59:24', '198.00'),
(100, 5, '2019-03-22 07:41:43', '0.00');

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

INSERT INTO `products` (`id`, `name`) VALUES
(1, 'Gallaxy Chocolate'),
(2, 'Delight Kake'),
(3, 'Sweet Muffin');
COMMIT;
