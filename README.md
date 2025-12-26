# Aseprite Scripts

![Status: Stable & Ongoing](https://img.shields.io/badge/status-Stable%20&%20Ongoing-green.svg)

Random scripts to help create art in Aseprite. Written using the
[Aseprite API](https://github.com/aseprite/api).

## Installation

1. Find your Aseprite script folder with **File -> Scripts -> Open Scripts Folder**.

2. Hard-link (Aseprite does not support soft links) the scripts you want using
   `ln {path to cloned script} {path to Aseprite script folder}`.

Or, alternatively, do something like `cp {path to cloned repository}/*.lua {path to Aseprite script
folder}`. This might fail (e.g., if the files already exist)  in which case you'll need to take
additional steps or use additional flags.
