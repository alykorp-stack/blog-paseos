#gallery

library(fs)
library(glue)


images <- NULL

#read all files
images <- dir_ls(".", glob = "*jpg")
images <- images + dir_ls(".", glob = "png")

#build quarto grid
cat("::: {layout-ncol = 4}\n")
for (img in images){
  cat(glue("![]({img})\n"))
}
cat(":::\n")



