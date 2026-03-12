module ApplicationHelper
  # Returns "nav-link active" when the current page matches the given path,
  # "nav-link" otherwise. Anchor-only paths (#section) are never active.
  # For non-root paths, prefix matching is used so sub-pages also highlight
  # the parent nav link (e.g. /blog_posts/my-post highlights Blog).
  def nav_link_class(path)
    active = if path.start_with?("#")
               false
             elsif path == root_path
               current_page?(path)
             else
               current_page?(path) || request.path.start_with?(path)
             end
    active ? "nav-link active" : "nav-link"
  end

end
