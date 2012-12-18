<?php
/*
Author: Douglas Karr
Author URI: http://www.dknewmedia.com
Description: Administrative options for PostPost
*/

load_plugin_textdomain('wppp',$path = 'wp-content/plugins/postpost');
$location = get_option('siteurl') . '/wp-admin/options-general.php?page=postpost/postpost.php';

/*Lets add some default options if they don't exist*/
add_option('wppp_prepost', __('', 'wppp'));
add_option('wppp_postpost', __('', 'wppp'));
add_option('wppp_presingle', __('', 'wppp'));
add_option('wppp_postsingle', __('', 'wppp'));
add_option('wppp_beforefeed', __('', 'wppp'));
add_option('wppp_prefeed', __('', 'wppp'));
add_option('wppp_postfeed', __('', 'wppp'));
add_option('wppp_afterfeed', __('', 'wppp'));
add_option('wppp_prepage', __('', 'wppp'));
add_option('wppp_postpage', __('', 'wppp'));

// Load jQuery
wp_enqueue_script('jquery');

/* update options */
if ('process' == $_POST['stage'])
{
update_option('wppp_prepost', __($_POST['wppp_prepost'], 'wppp'));
update_option('wppp_postpost', __($_POST['wppp_postpost'], 'wppp'));
update_option('wppp_presingle', __($_POST['wppp_presingle'], 'wppp'));
update_option('wppp_postsingle', __($_POST['wppp_postsingle'], 'wppp'));
update_option('wppp_beforefeed', __($_POST['wppp_beforefeed'], 'wppp'));
update_option('wppp_prefeed', __($_POST['wppp_prefeed'], 'wppp'));
update_option('wppp_postfeed', __($_POST['wppp_postfeed'], 'wppp'));
update_option('wppp_afterfeed', __($_POST['wppp_afterfeed'], 'wppp'));
update_option('wppp_prepage', __($_POST['wppp_prepage'], 'wppp'));
update_option('wppp_postpage', __($_POST['wppp_postpage'], 'wppp'));
}

/*Get options for form fields*/
$wppp_prepost = stripslashes(get_option('wppp_prepost'));
$wppp_postpost = stripslashes(get_option('wppp_postpost'));
$wppp_presingle = stripslashes(get_option('wppp_presingle'));
$wppp_postsingle = stripslashes(get_option('wppp_postsingle'));
$wppp_beforefeed = stripslashes(get_option('wppp_beforefeed'));
$wppp_prefeed = stripslashes(get_option('wppp_prefeed'));
$wppp_postfeed = stripslashes(get_option('wppp_postfeed'));
$wppp_afterfeed = stripslashes(get_option('wppp_afterfeed'));
$wppp_prepage = stripslashes(get_option('wppp_prepage'));
$wppp_postpage = stripslashes(get_option('wppp_postpage'));

?>

<div class="wrap">
  <h2><?php _e('PostPost', 'wppp') ?></h2>
  <p>PostPost is a simple plugin to add content before and after posts by <a href="http://dknewmedia.com">DK New Media</a>. Be sure to read <a href="http://marketingtechblog.com">The Marketing Technology Blog</a>... here are the latest posts:</p>
	<?php // Get RSS Feed(s)
    include_once(ABSPATH . WPINC . '/rss.php');
    $rss = fetch_rss('http://feedproxy.google.com/DouglasKarr');
    $maxitems = 7;
    $items = array_slice($rss->items, 0, $maxitems);
    ?>
    
    <ul style="list-style:square; margin-left: 50px">
    <?php foreach ( $items as $item ) : ?>
    <?php if (substr($item['title'],0,5)!="links") { ?>
    <li><a href='<?php echo $item['link']; ?>' 
    title='<?php echo $item['title']; ?>'>
    <?php echo $item['title']; ?>
    </a></li>
    <?php } endforeach; ?>
    </ul>
  <h2><?php _e('PostPost Options', 'wppp') ?></h2>
  <p>Simply paste your HTML into the text area and update options.  The page will refresh with the actual content displayed.</p>
  <form name="form1" method="post" action="<?php echo $location ?>&amp;updated=true">
	<input type="hidden" name="stage" value="process" />
    <table width="875px" cellspacing="5" cellpadding="5">
      <tr valign="top">
        <th scope="row" width="200px" align="right"><?php _e('Before Every Post:') ?></th>
        <td width="60px" align="center">
        	<a href="#" class="wppp_prepost"><?php if(strlen($wppp_prepost)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td width="600px">
        	<?php if(strlen($wppp_prepost)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_prepost."</p>"; } ?>
        	<span class="wppp_prepost"><textarea name="wppp_prepost" id="wppp_prepost" rows="6" style="width:600px"><?php echo $wppp_prepost; ?></textarea></span>
        	<script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_prepost").hide();
				$("a.wppp_prepost").click(function () {
				  $("span.wppp_prepost").toggle();
				});
			  });
		  </script>
        </td>
      </tr>
      <tr valign="top">
        <th scope="row" align="right"><?php _e('After Every Post:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_postpost"><?php if(strlen($wppp_postpost)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_postpost)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_postpost."</p>"; } ?>
        <span class="wppp_postpost"><textarea name="wppp_postpost" id="wppp_postpost" rows="6" style="width:600px"><?php echo $wppp_postpost; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_postpost").hide();
				$("a.wppp_postpost").click(function () {
				  $("span.wppp_postpost").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
      <tr valign="top">
        <th scope="row" align="right"><?php _e('Before Single Post on Page:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_presingle"><?php if(strlen($wppp_presingle)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_presingle)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_presingle."</p>"; } ?>
        <span class="wppp_presingle"><textarea name="wppp_presingle" id="wppp_presingle" rows="6" style="width:600px"><?php echo $wppp_presingle; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_presingle").hide();
				$("a.wppp_presingle").click(function () {
				  $("span.wppp_presingle").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
      <tr valign="top">
        <th scope="row" align="right"><?php _e('After Single Post on Page:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_postsingle"><?php if(strlen($wppp_postsingle)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_postsingle)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_postsingle."</p>"; } ?>
        <span class="wppp_postsingle"><textarea name="wppp_postsingle" id="wppp_postsingle" rows="6" style="width:600px"><?php echo $wppp_postsingle; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_postsingle").hide();
				$("a.wppp_postsingle").click(function () {
				  $("span.wppp_postsingle").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
      <tr valign="top">
        <th scope="row" align="right"><?php _e('Before the Feed:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_beforefeed"><?php if(strlen($wppp_beforefeed)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_beforefeed)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_beforefeed."</p>"; } ?>
        <span class="wppp_beforefeed"><textarea name="wppp_beforefeed" id="wppp_beforefeed" rows="6" style="width:600px"><?php echo $wppp_beforefeed; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_beforefeed").hide();
				$("a.wppp_beforefeed").click(function () {
				  $("span.wppp_beforefeed").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
	  <tr valign="top">
        <th scope="row" align="right"><?php _e('Before each Post in Feed:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_prefeed"><?php if(strlen($wppp_prefeed)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_prefeed)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_prefeed."</p>"; } ?>
        <span class="wppp_prefeed"><textarea name="wppp_prefeed" id="wppp_prefeed" rows="6" style="width:600px"><?php echo $wppp_prefeed; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_prefeed").hide();
				$("a.wppp_prefeed").click(function () {
				  $("span.wppp_prefeed").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
	  <tr valign="top">
        <th scope="row" align="right"><?php _e('After each Post in Feed:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_postfeed"><?php if(strlen($wppp_postfeed)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_postfeed)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_postfeed."</p>"; } ?>
        <span class="wppp_postfeed"><textarea name="wppp_postfeed" id="wppp_postfeed" rows="6" style="width:600px"><?php echo $wppp_postfeed; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_postfeed").hide();
				$("a.wppp_postfeed").click(function () {
				  $("span.wppp_postfeed").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
  <tr valign="top">
        <th scope="row" align="right"><?php _e('After the Feed:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_afterfeed"><?php if(strlen($wppp_afterfeed)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_afterfeed)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_afterfeed."</p>"; } ?>
        <span class="wppp_afterfeed"><textarea name="wppp_afterfeed" id="wppp_afterfeed" rows="6" style="width:600px"><?php echo $wppp_afterfeed; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_afterfeed").hide();
				$("a.wppp_afterfeed").click(function () {
				  $("span.wppp_afterfeed").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
	  <tr valign="top">
        <th scope="row" align="right"><?php _e('Before your Page:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_prepage"><?php if(strlen($wppp_prepage)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_prepage)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_prepage."</p>"; } ?>
        <span class="wppp_prepage"><textarea name="wppp_prepage" id="wppp_prepage" rows="6" style="width:600px"><?php echo $wppp_prepage; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_prepage").hide();
				$("a.wppp_prepage").click(function () {
				  $("span.wppp_prepage").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
	  <tr valign="top">
        <th scope="row" align="right"><?php _e('After your Page:') ?></th>
        <td align="center">
        	<a href="#" class="wppp_postpage"><?php if(strlen($wppp_postpage)>0) { echo "Update"; } else { echo "Add"; }?></a>
        </td>
		<td>
        <?php if(strlen($wppp_postpage)>0) { echo "<p style=\"background-color:#FFF; border: #000 thin\">".$wppp_postpage."</p>"; } ?>
        <span class="wppp_postpage"><textarea name="wppp_postpage" id="wppp_postpage" rows="6" style="width:600px"><?php echo $wppp_postpage; ?></textarea></span>
        <script type="text/javascript">
			  jQuery(document).ready(function($){
				$("span.wppp_postpage").hide();
				$("a.wppp_postpage").click(function () {
				  $("span.wppp_postpage").toggle();
				});
			  });
		  </script>
          </td>
      </tr>
	</table>
    <p class="submit">
      <input type="submit" name="Submit" value="<?php _e('Update Options', 'wppp') ?> &raquo;" />
    </p>
  </form>
</div>