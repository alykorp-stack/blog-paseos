library(fs)
install.packages("officer")
library(officer)
library(glue)

# Find all word docs in subfolders
docx_files <- dir_ls(".", glob = "*.docx", recurse = TRUE)

# Extract images from each doc
for (doc_path in docx_files) {
  doc <- read_docx(doc_path)
  
  # Get the folder this doc lives in
  post_folder <- path_dir(doc_path)
  
  # Extract all media (images) from the docx
  img_folder <- path(post_folder, "extracted_imgs")
  dir_create(img_folder)
  
  # officer stores media in a temp location
  media <- doc$package$media
  
  if (length(media) > 0) {
    file_copy(media, img_folder, overwrite = TRUE)
  }
}

# Now your gallery code works as before
images <- c(
  dir_ls(".", glob = "*.jpg", recurse = TRUE),
  dir_ls(".", glob = "*.png", recurse = TRUE)
)

cat("::: {layout-ncol=4}\n")
for (img in images) {
  cat(glue("![]({img})\n\n"))
}
cat(":::\n")
