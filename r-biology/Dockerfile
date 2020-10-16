# Customize UoB docker container
FROM gcr.io/ucb-datahub-2018/biology-user-image:e3df6f2

# Ottr grader.
RUN Rscript -e "devtools::install_github('ucbds-infra/ottr', ref='0.0.2', upgrade_dependencies=FALSE, quiet=FALSE)"
