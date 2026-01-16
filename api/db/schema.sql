-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 16, 2026 at 05:44 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `victus_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `carousel_home`
--

CREATE TABLE `carousel_home` (
  `id` int(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `actionTitle` varchar(255) NOT NULL,
  `urlImage` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carousel_home`
--

INSERT INTO `carousel_home` (`id`, `title`, `description`, `actionTitle`, `urlImage`) VALUES
(1, 'Bem vindo a minha App !', 'Clica aqui para iniciares a tua jornada.', 'Começa Aqui', 'https://www.modi7.com.br/img/powering_dev-74ef0ca5-432w.png'),
(2, 'Segundo titulo do mysql', 'Fake Description mysql', 'Começa Aqui', 'https://www.modi7.com.br/img/powering_dev-74ef0ca5-432w.png');

-- --------------------------------------------------------

--
-- Table structure for table `dailymessage`
--

CREATE TABLE `dailymessage` (
  `id` int(11) NOT NULL,
  `myuser` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dailymessage`
--

INSERT INTO `dailymessage` (`id`, `myuser`, `title`, `description`) VALUES
(1, 5, 'Lembrete do dia:', 'É importante agradecer pelo hoje, sem nunca desistir do amanhã !');

-- --------------------------------------------------------

--
-- Table structure for table `library`
--

CREATE TABLE `library` (
  `id` int(11) NOT NULL,
  `myuser` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `video` varchar(255) NOT NULL,
  `progress` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `library`
--

INSERT INTO `library` (`id`, `myuser`, `title`, `description`, `url`, `video`, `progress`) VALUES
(1, 5, 'My fake libro', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'https://thebackstage-deezer.com/wp-content/uploads/2023/11/musica-eletronica-1240x600.jpg', 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 10),
(2, 5, 'outro', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.', 'https://thebackstage-deezer.com/wp-content/uploads/2023/11/musica-eletronica-1240x600.jpg', 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 0),
(3, 5, 'Diferente', 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed', 'https://turismodocentro.pt/wp-content/uploads/2021/08/TC2020_PC_200708-9210-00299.jpg', '', 35);

-- --------------------------------------------------------

--
-- Table structure for table `librarysection`
--

CREATE TABLE `librarysection` (
  `id` int(11) NOT NULL,
  `idlibrary` int(11) NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `librarysection`
--

INSERT INTO `librarysection` (`id`, `idlibrary`, `title`) VALUES
(1, 1, 'Bem vindas !'),
(2, 1, 'Guias Alimentares'),
(3, 1, 'Alimentação saudável'),
(4, 1, 'Emagrecimento'),
(5, 2, 'Primeiro'),
(6, 2, 'Segundo');

-- --------------------------------------------------------

--
-- Table structure for table `librarysection_conteudo`
--

CREATE TABLE `librarysection_conteudo` (
  `id` int(11) NOT NULL,
  `idlibrarysection` int(11) NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `librarysection_conteudo`
--

INSERT INTO `librarysection_conteudo` (`id`, `idlibrarysection`, `title`) VALUES
(1, 1, 'Metodos e os seus Principios !');

-- --------------------------------------------------------

--
-- Table structure for table `libraryuseractions`
--

CREATE TABLE `libraryuseractions` (
  `id` int(11) NOT NULL,
  `mylibrary` int(11) NOT NULL,
  `myuser` int(11) NOT NULL,
  `gosto` int(11) DEFAULT NULL,
  `star` int(11) DEFAULT NULL,
  `done` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myevents`
--

CREATE TABLE `myevents` (
  `id` int(11) NOT NULL,
  `myuser` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `inicio` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `myevents`
--

INSERT INTO `myevents` (`id`, `myuser`, `title`, `inicio`) VALUES
(1, 5, 'Masterclass', '23/05'),
(2, 5, 'New Workshop', '12/08'),
(3, 5, 'Pedro new job', '19/01');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `peso` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `pass`, `peso`) VALUES
(5, 'Pedro', 'pedrootrabalhador@gmail.com', '1234', 5),
(10, 'Victus', 'victus@gmail.com', '12345', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carousel_home`
--
ALTER TABLE `carousel_home`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dailymessage`
--
ALTER TABLE `dailymessage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `myuser` (`myuser`);

--
-- Indexes for table `library`
--
ALTER TABLE `library`
  ADD PRIMARY KEY (`id`),
  ADD KEY `myuser` (`myuser`);

--
-- Indexes for table `librarysection`
--
ALTER TABLE `librarysection`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idlibrary` (`idlibrary`);

--
-- Indexes for table `librarysection_conteudo`
--
ALTER TABLE `librarysection_conteudo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idlibrarysection` (`idlibrarysection`);

--
-- Indexes for table `libraryuseractions`
--
ALTER TABLE `libraryuseractions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mylibrary` (`mylibrary`),
  ADD KEY `myuser` (`myuser`);

--
-- Indexes for table `myevents`
--
ALTER TABLE `myevents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `myuser` (`myuser`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `carousel_home`
--
ALTER TABLE `carousel_home`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `dailymessage`
--
ALTER TABLE `dailymessage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `library`
--
ALTER TABLE `library`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `librarysection`
--
ALTER TABLE `librarysection`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `librarysection_conteudo`
--
ALTER TABLE `librarysection_conteudo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `libraryuseractions`
--
ALTER TABLE `libraryuseractions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `myevents`
--
ALTER TABLE `myevents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `dailymessage`
--
ALTER TABLE `dailymessage`
  ADD CONSTRAINT `dailymessage_ibfk_1` FOREIGN KEY (`myuser`) REFERENCES `users` (`id`);

--
-- Constraints for table `library`
--
ALTER TABLE `library`
  ADD CONSTRAINT `library_ibfk_1` FOREIGN KEY (`myuser`) REFERENCES `users` (`id`);

--
-- Constraints for table `librarysection`
--
ALTER TABLE `librarysection`
  ADD CONSTRAINT `librarysection_ibfk_1` FOREIGN KEY (`idlibrary`) REFERENCES `library` (`id`);

--
-- Constraints for table `librarysection_conteudo`
--
ALTER TABLE `librarysection_conteudo`
  ADD CONSTRAINT `librarysection_conteudo_ibfk_1` FOREIGN KEY (`idlibrarysection`) REFERENCES `librarysection` (`id`);

--
-- Constraints for table `libraryuseractions`
--
ALTER TABLE `libraryuseractions`
  ADD CONSTRAINT `libraryuseractions_ibfk_1` FOREIGN KEY (`mylibrary`) REFERENCES `library` (`id`),
  ADD CONSTRAINT `libraryuseractions_ibfk_2` FOREIGN KEY (`myuser`) REFERENCES `users` (`id`);

--
-- Constraints for table `myevents`
--
ALTER TABLE `myevents`
  ADD CONSTRAINT `myevents_ibfk_1` FOREIGN KEY (`myuser`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
