extract_and_render_post <- function(docx_path) {
  library(officer)
  library(fs)
  library(glue)
  
  doc <- read_docx(docx_path)
  post_folder <- path_dir(docx_path)
  
  # Extract text
  text <- docx_summary(doc) |>
    dplyr::filter(content_type == "paragraph") |>
    dplyr::pull(text) |>
    paste(collapse = "\n\n")
  
  # Extract images
  img_folder <- path(post_folder, "imgs")
  dir_create(img_folder)
  media <- doc$package$media
  if (length(media) > 0) file_copy(media, img_folder, overwrite = TRUE)
  
  list(text = text, img_folder = img_folder)
}


