SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

-- --------------------------------------------------------
-- UGC Endpoint
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_users` (
  `uid` varchar(25) NOT NULL,
  `locale` varchar(10) NOT NULL,
  `network` varchar(255) DEFAULT NULL,
  `device` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `pic` tinytext DEFAULT NULL,
  `login_count` int(11) DEFAULT 1,
  `timestamp_registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `timestamp_lastlogin` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_users_extended` (
  `uid` varchar(25) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `hometown_location` varchar(255) DEFAULT NULL,
  `birthday_date` varchar(255) DEFAULT NULL,
  `title` varchar(25) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `additional` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `email_confirmed` int(1) DEFAULT 0,
  `score` float(8,2) DEFAULT NULL,
  `newsletter` int(1) DEFAULT 0,
  `rules` int(1) DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_users_like_items` (
  `uid` varchar(25) NOT NULL,
  `rating` int(3) NOT NULL DEFAULT 1,
  `item_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `uid` (`uid`),
  KEY `item_id` (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_users_complain_items` (
  `uid` varchar(25) NOT NULL,
  `reason` tinytext NOT NULL default '',
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_itemcontainers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_container_id` int(11) NOT NULL DEFAULT 0,
  `privacy_level` int(1) NOT NULL DEFAULT 0,
  `title` varchar(255) DEFAULT NULL,
  `description` tinytext DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `parent_container_id` (`parent_container_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- role 0:owner, 1:participant, 2:follower
CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_itemcontainer_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `container_id` int(11) NOT NULL DEFAULT 0,
  `uid` varchar(25) DEFAULT NULL,
  `role` int(1) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `container_id` (`container_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------


  -- type: 0:text, 1:image, 2:video, 3:audio, 4:link
CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `container_id` int(11) NOT NULL DEFAULT 0,
  `creator_uid` varchar(25) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` tinytext DEFAULT NULL,
  `like_count` int(11) NOT NULL DEFAULT 0,
  `complain_count` int(11) NOT NULL DEFAULT 0,
  `flag` int(1) NOT NULL DEFAULT 0,
  `type` int(1) NOT NULL DEFAULT 0,
  `type_id` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `like_count` (`like_count`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_items_type_text` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_items_type_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url_big` tinytext DEFAULT NULL,
  `url_thumb` tinytext DEFAULT NULL,
  `w` int(6) NOT NULL DEFAULT 0,
  `h` int(6) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_items_type_video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` tinytext DEFAULT NULL,
  `url_thumb` tinytext DEFAULT NULL,
  `length` int(11) NOT NULL DEFAULT 0,
  `w` int(6) NOT NULL DEFAULT 0,
  `h` int(6) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_items_type_audio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` tinytext DEFAULT NULL,
  `length` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_items_type_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` tinytext DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


-- --------------------------------------------------------
-- Task Endpoint
-- --------------------------------------------------------


-- type: 0:text, 1:image, 2:video, 3:audio, 4:link
CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL DEFAULT 0,
  `task_key` tinytext DEFAULT NULL,
  `type` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_task_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_key` tinytext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_itemcontainers_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `container_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
-- Gaming Endpoint
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_user_games` (
  `uid` varchar(255) NOT NULL,
  `level` int(3) NOT NULL DEFAULT 1,
  `score` int(11) NOT NULL,
  `control` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `uid` (`uid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


-- --------------------------------------------------------
-- Facebook Invite Log. Necessary in order to enable 
-- deeplinks for requests without requiring the user to auth the app
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `@accounts.dbtableprefix@_users_invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(255) DEFAULT NULL,
  `from_id` varchar(255) DEFAULT NULL,
  `to_ids` tinytext DEFAULT NULL,
  `data` text NOT NULL default '',
  `error_code` varchar(255) DEFAULT NULL,
  `error_msg` tinytext DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
