Hi,
Here are the checks I conducted

## R CMD check results

No notes were found when running the local RMD checks.

## rhub::check_for_cran() results

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Luigi Annicchiarico <luigi.annic@gmail.com>'
  
  New submission

❯ On windows-x86_64-devel (r-devel)
  checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''
    
  **This NOTE seems to be a known R-hub issue, and not related to my package (source: https://github.com/r-hub/rhub/issues/560)**  
    
❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
    
   **This NOTE seems to be a known MiKTeX bug, and not related to my package (source: https://github.com/r-hub/rhub/issues/503**  

❯ On ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... [6s/17s] NOTE
  Maintainer: ‘Luigi Annicchiarico <luigi.annic@gmail.com>’
  
  New submission

❯ On ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  
  **This is another known NOTE, which is unrelated to my local system and that should not be a problem for CRAN submission, according to https://stackoverflow.com/questions/74857062/rhub-cran-check-keeps-giving-html-note-on-fedora-test-no-command-tidy-found**

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... [6s/23s] NOTE
  Maintainer: ‘Luigi Annicchiarico <luigi.annic@gmail.com>’
  
  New submission
  


On R development version (2024-02-08 r85876 ucrt), the only note I get is the one regarding
"checking CRAN incoming feasibility", which is not an issue according to the CRAN maintainer Uwe Ligges (https://stackoverflow.com/questions/23829978/checking-cran-incoming-feasibility-note-maintainer).

No warnings or errors are found in any of the environments I checked.
