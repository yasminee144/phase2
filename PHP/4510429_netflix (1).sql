-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: fdb1030.awardspace.net
-- Generation Time: Aug 03, 2024 at 06:28 PM
-- Server version: 8.0.32
-- PHP Version: 8.1.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `4510429_netflix`
--

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `media_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`) VALUES
(17, 'imh154807@gmail.com', '$2y$10$4GcvX.F6KDeOaZNKuSWhP.uOe/ATq87yq9YvQpCtgLDIfP1ZhDisu'),
(18, 'imh1548@gmail.com', '$2y$10$ZM26zdoJhNBqUAZbr6zI4e5zVMdbXGMMxj0GzyfeeFofbZM5n1S3G'),
(19, 'mohamaddaoud@gmail.com', '$2y$10$DM.6PnRpxNFOFXBI6FeDkub5QzgvZkd6fV3TWyNW0BilCRLiPW5tG'),
(20, 'imh157@gmail.com', '$2y$10$ipZKZFgnI3tvY6JmpRtKHe1kQ7v3gFIdCi6b6cqfyuVRzxlEu5h4K'),
(21, 'imh157807@gmail.com', '$2y$10$QNYVfaKX.fZnPD0gS4O4w.SzRPmKcUs29C4C1gTb8AhTXq.j197G6'),
(22, 'yasminewayzani@gmail.com', '$2y$10$ZpQ7mYzJbrf18W2HkrQe5O8jjqUYn6zFZTDhSeok0xTO0dlsboMci'),
(23, 'yasmine@gmail.com', '$2y$10$cK0.rfyuLkA.u6FDMTEnH..pzLhSmIiSb7r4CJIlprVyaN6uEjd0q'),
(24, '', '$2y$10$78wExvzNTJmxFqV1O455vuYpqiJf2iD4nxohzyonjr7XnbcStaH3.');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
