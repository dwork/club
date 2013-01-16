<?php

/**
 * Implements hook_install_tasks().
 */
function club_install_tasks($install_state) {
  return array(
    // Just a hidden task callback.
    'club_profile_setup' => array(),
    'club_block_setup' => array(),
  );
}

/**
 * Installer task callback.
 */
function club_block_setup() {

  $default_theme = 'omega_club';
  $admin_theme = 'seven';

  $values = array(
    array(
      'module' => 'simplenews',
      'delta' => 'Newsletter: Multi Subscription',
      'theme' => $default_theme,
      'status' => 1,
      'weight' => 0,
      'region' => 'sidebar_second',
      'pages' => '',
      'cache' => -1,
    ),
  );
  $query = db_insert('block')->fields(array('module', 'delta', 'theme', 'status', 'weight', 'region', 'pages', 'cache'));
  foreach ($values as $record) {
    $query->values($record);
  }
  $query->execute();

}

/**
 * Installer task callback.
 */
function club_profile_setup() {

	# SMTP module defaults
	variable_set('smtp_on','1');
	variable_set('smtp_username','crxymail');
	variable_set('smtp_password','crxy010#');
	variable_set('smtp_port','587');
	variable_set('smtp_host','smtp.earthclick.net');
	variable_set('smtp_fromname','Rotary');
	variable_set('smtp_from','aegir@aegir.earthclick.net');

	// phone/address locations
	club_create_taxonomy_term('Billing', 'location');
	club_create_taxonomy_term('Home', 'location');
	club_create_taxonomy_term('Mailing', 'location');
	club_create_taxonomy_term('Other', 'location');
	club_create_taxonomy_term('Work', 'location');

	// phone type
	club_create_taxonomy_term('Phone', 'phone_types');
	club_create_taxonomy_term('Cell', 'phone_types');
	club_create_taxonomy_term('Fax', 'phone_types');
	club_create_taxonomy_term('Message', 'phone_types');
	club_create_taxonomy_term('Pager', 'phone_types');
	club_create_taxonomy_term('Toll Free', 'phone_types');

    	// committee Types
	club_create_taxonomy_term('Committee', 'committee_type');

    	// Project Types
	club_create_taxonomy_term('Community Service', 'project_type');
	club_create_taxonomy_term('Fund Raiser', 'project_type');
	club_create_taxonomy_term('World Service', 'project_type');

    	// club officers
	club_create_taxonomy_term('President', 'officers');
	club_create_taxonomy_term('President Elect', 'officers');
	club_create_taxonomy_term('President Nominee', 'officers');
	club_create_taxonomy_term('Past President', 'officers');
	club_create_taxonomy_term('Secretary', 'officers');
	club_create_taxonomy_term('Treasurer', 'officers');
	club_create_taxonomy_term('Sergeant at Arms', 'officers');

    	// Member Status
	club_create_taxonomy_term('Charter Member', 'member_status');
	club_create_taxonomy_term('Active', 'member_status');
	club_create_taxonomy_term('Honorary', 'member_status');
	club_create_taxonomy_term('Inactive', 'member_status');
	club_create_taxonomy_term('Former Member', 'member_status');

    	// Member Title
	club_create_taxonomy_term('Miss', 'title');
	club_create_taxonomy_term('Mr', 'title');
	club_create_taxonomy_term('Ms', 'title');
	club_create_taxonomy_term('Mrs', 'title');
	club_create_taxonomy_term('Sir', 'title');
  

    // attendance
    club_create_taxonomy_term_custom('Absent', 'attendance', 'Absent');
    club_create_taxonomy_term_custom('Excused', 'attendance', 'Do Not Count');
    club_create_taxonomy_term_custom('Makeup', 'attendance', 'Makeup');
    club_create_taxonomy_term_custom('Regular Meeting', 'attendance', 'Present');

        // Event
	club_create_taxonomy_term('Meeting', 'event_type');
	club_create_taxonomy_term('Committee Meeting', 'event_type');
	club_create_taxonomy_term('Social', 'event_type');
        
}
/*
 * Create taxonomy vocabulary
*/
function club_create_taxonomy($name,$machine_name,$description,$help) {
  $vocabulary = (object) array(
    'name' => $name,
    'description' => $description,
    'machine_name' => $machine_name,
    'help' => $help,
  );
  taxonomy_vocabulary_save($vocabulary);

}

/*
 * Create taxonomy terms give machine name ($mac)
 */
function club_create_taxonomy_term($name,$machine_name) {
  $voc = taxonomy_vocabulary_machine_name_load($machine_name);
  $term = new stdClass();
  $term->name = $name;
  if (isset($voc)) {
  	$term->vid = $voc->vid;
  } else {
    	$term->vid = 1;
  }
  taxonomy_term_save($term);
  return $term->tid;
}

/*
 * Create taxonomy terms give machine name ($mac)
 */
function _create_taxonomy_term_custom($name,$machine_name,$statistic) {
  $voc = taxonomy_vocabulary_machine_name_load($machine_name);
  $term = new stdClass();
  $term->name = $name;
  if (isset($statistic)) {
    $term->statistic['und'][0]['value'] = $statistic;
  }
  if (isset($voc)) {
        $term->vid = $voc->vid;
  } else {
        $term->vid = 1;
  }
  taxonomy_term_save($term);
  return $term->tid;
}

