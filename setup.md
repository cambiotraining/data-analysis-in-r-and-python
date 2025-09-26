---
title: "Data & Setup"
number-sections: false
---

<!-- 
Note for Training Developers:
We provide instructions for commonly-used software as commented sections below.
Uncomment the sections relevant for your materials, and add additional instructions where needed (e.g. specific packages used).
Note that we use tabsets to provide instructions for all three major operating systems.
-->

::: {.callout-tip level=2}
## Course attendees

If you are attending one of our courses, we might provide a training environment with all of the required software and data, depending on the format.

For in-person courses taking place at our training room in Cambridge, we have dedicated computers with all the required software. For online courses we generally expect participants to set up their own computer. Installation instructions are provided below.

In general we highly encourage everyone to have all the software installed locally, since that will allow you to use immediately all the tools you have learnt during the course.
:::

## Data

The data used in these materials is provided as a zip file. 
Download and unzip the folder to your Desktop, then copy it into your working directory to follow along with the materials. We cover how to do this in the [Intro to software](materials/da1-01-intro-software.qmd) section.

<!-- Note for Training Developers: add the link to 'href' -->
<a href="https://github.com/cambiotraining/data-analysis-in-r-and-python/raw/refs/heads/main/data.zip">
  <button class="btn"><i class="fa fa-download"></i> Download</button>
</a>

## Software

### R

- First install R and RStudio following [these instructions](https://cambiotraining.github.io/software-installation/materials/r-base.html).
- Then, open RStudio and run the following commands on the Console (bottom left panel) to install the required packages:

    ```r
    install.packages(c("MASS", "janitor", "naniar", 
                      "patchwork", "scales", "tidyverse"))
    ```

### Python

- First install Mamba following [these instructions](https://cambiotraining.github.io/software-installation/materials/mamba.html).
  - **Windows users:** Make sure to first install WSL2 as instructed on that page.
- Then, open a terminal and run the following command to install the required packages:

  ```bash
  mamba create -n data-analysis-course -y -c conda-forge python plotnine pyjanitor matplotlib missingno numpy pandas seaborn textwrap jupyterlab
  ```

- Once installation completes, activate the environment (your prompt should change to indicate you are in the `data-analysis-course` environment):

  ```bash
  mamba activate data-analysis-course
  ```
  
- Finally, launch JupyterLab:

  ```bash
  jupyter lab
  ```
