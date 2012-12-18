<?php get_header(); ?>

	<div id="primary" class="site-content">
		<div id="content" role="main">
			<?php $current_blog_id = get_current_blog_id(); ?>
			<?php foreach (array_reverse(get_blog_list()) as $blog): ?>
				<?php switch_to_blog($blog['blog_id']); ?>
				<?php if (is_main_site()) { continue; } ?>
				<?php $blog_detail = get_blog_details(); ?>
				<article id="blog-<?php $blog_detail->blog_id ?>">
					<h1 class="entry-title">
						<a href="<?php echo $blog_detail->path ?>" title="<?php echo $blog_detail->blogname ?>"><?php echo $blog_detail->blogname ?></a>
					</h1>
					<div class="entry-summary">
						<a href="http://twitter.com/<?php echo trim($blog_detail->path, '/') ?>">Twitter</a>
					</div>
				</article>
			<?php endforeach; ?>
			<?php switch_to_blog($current_blog_id); ?>
		</div><!-- #content -->
	</div><!-- #primary -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>
