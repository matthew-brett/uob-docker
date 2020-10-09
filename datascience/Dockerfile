# Customize UoB docker container
FROM gcr.io/ucb-datahub-2018/workshop-user-image:3cd7a6b

# Install jupytext
RUN pip install jupytext

# Ottr grader.
RUN Rscript -e "devtools::install_github('ucbds-infra/ottr', ref='0.0.1', upgrade_dependencies=FALSE, quiet=FALSE)"
