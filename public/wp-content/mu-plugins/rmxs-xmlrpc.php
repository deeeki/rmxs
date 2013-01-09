<?php
/*
Plugin Name: Rmxs Xmlrpc
Plugin URI:
Description:
Version: 0.0.1
Revision Date: Dec. 15, 2012
Tested up to: WordPress 3.5
License: GNU General Public License 2.0 (GPL) http://www.gnu.org/licenses/gpl.html
Author: itzki
Author URI: https://github.com/itzki
Site Wide Only: true
*/

add_filter('xmlrpc_methods', array('RmxsXmlrpc', 'add'));

class RmxsXmlrpc {
	static public function add($methods) {
		return array_merge($methods, array('wp.getUids' => array('RmxsXmlrpc', 'wp_getUids')));
	}

	static public function wp_getUids($args) {
		global $wpdb;

		$wp_xmlrpc_server_class = apply_filters('wp_xmlrpc_server_class', 'wp_xmlrpc_server');
		$wp_xmlrpc = new $wp_xmlrpc_server_class;
		if ( count( $args ) < 3 ) {
			$wp_xmlrpc->error = new IXR_Error( 400, __( 'Insufficient arguments passed to this XML-RPC method.' ) );
			return false;
		}

		$wp_xmlrpc->escape( $args );

		$blog_id  = (int) $args[0];
		$username = $args[1];
		$password = $args[2];

		if ( !$wp_xmlrpc->login($username, $password) )
			return $wp_xmlrpc->error;

		//currently not support filtering by category
		//if (isset($args[3]) && $category = get_category_by_slug($args[3])) {
			//$cat_id = $category->cat_ID;
		//}
		//else {
			//$cat_id = 0;
		//}
		return $wpdb->get_col('SELECT post_content_filtered FROM ' . $wpdb->posts . ' WHERE post_content_filtered <> ""');
	}
}
