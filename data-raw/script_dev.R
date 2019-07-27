#https://speakerdeck.com/colinfay/building-a-package-that-lasts-erum-2018-workshop
#https://thinkr.fr/creer-package-r-quelques-minutes/

unlink("DESCRIPTION")
my_desc <- desc::description$new("!new")
my_desc$set("Package","nemo")
my_desc$set("Authors@R", "person('Mathieu', 'Garnier',email='matai.dat@gmail.com', role=c('cre','aut'))")
#my_desc$set_authors()
my_desc$del("Maintainer")
my_desc$set_version("0.0.0.9000")
my_desc$set(Description = "Find largest empty circle")
my_desc$set("URL","https://github.com/mtmx/nemo")
my_desc$set("BugReports","https://github.com/mtmx/nemo/issues")

# save
my_desc$write(file = "DESCRIPTION")

#
use_readme_rmd()
use_mit_license(name="mtmx")


usethis::use_package("dplyr", "magrittr","concaveman","sf", "nngeo")





library(roxygen2)
#générer doc .Rd
roxygen2::roxygenise()


#vignettes :
#devtools::build_vignettes()

# pour générer les articles issues des vignettes
#pkgdown::build_articles(pkg = ".")


# vérification de l'intégrité du package
devtools::check()
