
.onAttach <- function(libname, pkgname) {
  msg <- paste0("WMO Resolution 40. NOAA Policy'\n",
                "'The following data and products may have conditions placed\n",
                "their international commercial use. They can be used within\n",
                "the U.S. or for non-commercial international activities\n",
                "without restriction. The non-U.S. data cannot be\n",
                "redistributed for commercial purposes. Re-distribution of\n",
                "these data by others must provide this same notification.\n",
                "\n",
                "For details, visit https://github.com/databrew/gsod.")
  packageStartupMessage(msg)
}
