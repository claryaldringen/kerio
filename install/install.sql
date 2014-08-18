
CREATE TABLE `list` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(64) NOT NULL
) COMMENT='' ENGINE='InnoDB' COLLATE 'utf8_czech_ci';

CREATE TABLE `bug_list` (
  `bug_id` mediumint(9) NOT NULL,
  `list_id` tinyint(3) unsigned NOT NULL,
  `sort_key` int unsigned NOT NULL,
  FOREIGN KEY (`bug_id`) REFERENCES `bugs` (`bug_id`) ON DELETE CASCADE,
  FOREIGN KEY (`list_id`) REFERENCES `list` (`id`) ON DELETE CASCADE
) COMMENT='' ENGINE='InnoDB' COLLATE 'utf8_czech_ci';

-- [2014-08-16 Clary 0.012s] Naplneni testovacimi daty
INSERT INTO `list` (`name`)
VALUES ('Backlog'),('Sprint 1'),('Sprint 2');

INSERT INTO `bug_list` (`bug_id`, `list_id`, `sort_key`) VALUES
(1,	2,	0),
(2,	2,	1);


INSERT INTO `bugs` (`bug_id`, `assigned_to`, `bug_file_loc`, `bug_severity`, `bug_status`, `creation_ts`, `delta_ts`, `short_desc`, `op_sys`, `priority`, `product_id`, `rep_platform`, `reporter`, `version`, `component_id`, `resolution`, `target_milestone`, `qa_contact`, `status_whiteboard`, `lastdiffed`, `everconfirmed`, `reporter_accessible`, `cclist_accessible`, `estimated_time`, `remaining_time`, `deadline`, `alias`, `cf_reproted_by`) VALUES
  (7,	1,	'',	'',	'NEW',	NULL,	'0000-00-00 00:00:00',	'Testovací user story',	'',	'',	2,	'',	1,	'',	3,	'',	'---',	NULL,	'',	NULL,	0,	1,	1,	0.00,	0.00,	NULL,	NULL,	'---'),
  (10,	1,	'',	'',	'NEW',	NULL,	'0000-00-00 00:00:00',	'Ticket 1',	'',	'',	2,	'',	1,	'',	2,	'',	'---',	NULL,	'',	NULL,	0,	1,	1,	0.00,	0.00,	NULL,	NULL,	'---');

INSERT INTO `dependencies` (`blocked`, `dependson`) VALUES
  (7,	10);

ALTER TABLE `list`
ADD `type` enum('left','right') COLLATE 'utf8_czech_ci' NOT NULL,
COMMENT='';