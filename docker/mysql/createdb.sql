CREATE DATABASE swarms;
USE swarms;
CREATE TABLE `nodes`
(
    `timeof`        timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `name`          varchar(60) NOT NULL,
    `peers`         int         NOT NULL,
    `diskavail`     bigint               DEFAULT NULL,
    `diskfree`      bigint               DEFAULT NULL,
    `cheque`        int         NOT NULL,
    `ip`            varchar(60) NOT NULL,
    `address`       varchar(60) NOT NULL,
    `chequeaddress` varchar(60),
    `category`      varchar(20) not null,
    `uncashednum`   int                  DEFAULT 0,
    primary key (address),
    KEY             `index1` (`name`),
    KEY             `index2` (`chequeaddress`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;