<?php
/*
Plugin Name: PostPost
Plugin URI: http://marketingtechblog.com/projects/postpost
Description: A plugin for users who wish to customize the content before and after every post on their blog and in their feed or in their pages.
Author: Douglas Karr
Author URI: http://www.dknewmedia.com
Version: 2.1.0
*/

load_plugin_textdomain('wppp',$path = 'wp-content/plugins/postpost');

function wppp_updatecontent($content) {
	// retrieve the plugin options
		$wppp_prepost = stripslashes(get_option('wppp_prepost'));
		$wppp_postpost = stripslashes(get_option('wppp_postpost'));
		$wppp_presingle = stripslashes(get_option('wppp_presingle'));
		$wppp_postsingle = stripslashes(get_option('wppp_postsingle'));
		$wppp_prefeed = stripslashes(get_option('wppp_prefeed'));
		$wppp_postfeed = stripslashes(get_option('wppp_postfeed'));
		$wppp_prepage = stripslashes(get_option('wppp_prepage'));
		$wppp_postpage = stripslashes(get_option('wppp_postpage'));
		
		if(is_feed()) {
			return $wppp_prefeed.$content.$wppp_postfeed;
		}
		if(is_page()) {
			return $wppp_prepage.$content.$wppp_postpage;
		}
		else if(is_single()) {
			return $wppp_presingle.$content.$wppp_postsingle;
		}
		if(!is_singular()) {
			return $wppp_prepost.$content.$wppp_postpost;
		}
	}

function wppp_rssfooter($content) {
	if(is_feed()) {
		$wppp_afterfeed = stripslashes(get_option('wppp_afterfeed'));
		$wppp_beforefeed = stripslashes(get_option('wppp_beforefeed'));
		$content = $wppp_beforefeed.$content.$wppp_afterfeed;
		return $content;
	} else {
		return $content;
	}
}

function wppp_admin_include() {
		include(dirname(__FILE__).'/postpost_admin.php');
	}

function wppp_add_options_page() {
	add_options_page('PostPost Options', 'PostPost',8,__FILE__, 'wppp_admin_include');
	}

add_action('admin_menu', 'wppp_add_options_page',8);
add_filter('the_content', 'wppp_updatecontent', 1);
add_filter('the_excerpt_rss', 'wppp_rssfooter', 10);
add_filter('the_content', 'wppp_rssfooter', 10);
?>