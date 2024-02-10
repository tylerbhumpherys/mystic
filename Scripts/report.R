library(rmarkdown)

# render the R Markdown file
input_file <- "report.Rmd"
output_file <- "report.pdf"
rmarkdown::render(input_file, output_format = "pdf_document", 
                  output_file = output_file)