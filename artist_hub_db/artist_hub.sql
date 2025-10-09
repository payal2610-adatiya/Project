-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 09, 2025 at 02:54 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `artist_hub`
--

-- --------------------------------------------------------

--
-- Table structure for table `g_artist_category`
--

CREATE TABLE `g_artist_category` (
  `id` int(11) NOT NULL,
  `artist_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `g_artist_media`
--

CREATE TABLE `g_artist_media` (
  `media_id` int(11) NOT NULL,
  `artist_id` int(11) NOT NULL,
  `media_url` varchar(255) NOT NULL,
  `media_type` enum('image','video') NOT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `g_bookings`
--

CREATE TABLE `g_bookings` (
  `booking_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `artist_id` int(11) NOT NULL,
  `event_date` date NOT NULL,
  `event_time` time DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled','completed') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `g_categories`
--

CREATE TABLE `g_categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `g_feedbacks`
--

CREATE TABLE `g_feedbacks` (
  `feedback_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `g_reviews`
--

CREATE TABLE `g_reviews` (
  `review_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `artist_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `g_users`
--

CREATE TABLE `g_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role` enum('admin','artist','customer') NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `g_artist_category`
--
ALTER TABLE `g_artist_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `artist_id` (`artist_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `g_artist_media`
--
ALTER TABLE `g_artist_media`
  ADD PRIMARY KEY (`media_id`),
  ADD KEY `artist_id` (`artist_id`);

--
-- Indexes for table `g_bookings`
--
ALTER TABLE `g_bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `artist_id` (`artist_id`);

--
-- Indexes for table `g_categories`
--
ALTER TABLE `g_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `g_feedbacks`
--
ALTER TABLE `g_feedbacks`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `g_reviews`
--
ALTER TABLE `g_reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `artist_id` (`artist_id`);

--
-- Indexes for table `g_users`
--
ALTER TABLE `g_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `g_artist_category`
--
ALTER TABLE `g_artist_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `g_artist_media`
--
ALTER TABLE `g_artist_media`
  MODIFY `media_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `g_bookings`
--
ALTER TABLE `g_bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `g_categories`
--
ALTER TABLE `g_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `g_feedbacks`
--
ALTER TABLE `g_feedbacks`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `g_reviews`
--
ALTER TABLE `g_reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `g_users`
--
ALTER TABLE `g_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `g_artist_category`
--
ALTER TABLE `g_artist_category`
  ADD CONSTRAINT `g_artist_category_ibfk_1` FOREIGN KEY (`artist_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `g_artist_category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `g_categories` (`category_id`) ON DELETE CASCADE;

--
-- Constraints for table `g_artist_media`
--
ALTER TABLE `g_artist_media`
  ADD CONSTRAINT `g_artist_media_ibfk_1` FOREIGN KEY (`artist_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `g_bookings`
--
ALTER TABLE `g_bookings`
  ADD CONSTRAINT `g_bookings_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `g_bookings_ibfk_2` FOREIGN KEY (`artist_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `g_feedbacks`
--
ALTER TABLE `g_feedbacks`
  ADD CONSTRAINT `g_feedbacks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `g_reviews`
--
ALTER TABLE `g_reviews`
  ADD CONSTRAINT `g_reviews_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `g_bookings` (`booking_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `g_reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `g_reviews_ibfk_3` FOREIGN KEY (`artist_id`) REFERENCES `g_users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
