WRF Portlet
===

![](assets/wrf-logo.png)

###### **Damas Makweba**, DIT - Dar es Salaam Institute of Technology - ( [@dmakweba](https://github.com/dmakweba) )
###### **Triphonia Ngailo**, DIT - Dar es Salaam Institute of Technology
###### **Mario Torrisi**, DFA-UNICT - Physics and Astronomy Department, University of Catania - ( [@mtorrisi](https://github.com/mtorrisi) )

---

### The Weather Research & Forecasting (WRF) Model
is a next-generation mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting needs.

For more information, visit [www.wrf-model.org](http://www.wrf-model.org/index.php)

---

### WRF user interface

The **WRF portlet** provides an easy way to perform WRF model on **D**istributed **C**omputing **I**nfrastructure (**DCI**).

![](assets/screenshot.png)

---

### How to use WRF portlet

Visit [sgw.africa-grid.org/wrf](https://sgw.africa-grid.org/wrf) to run WRF from Africa Grid Science Gateway.

1. Select the **namelist.wps** using the '*Choose File*' button.
1. Select the **namelist.input** using the '*Choose File*' button.
1. Create the script to download the Lateral Boundary Condition (**LBC**) files for your analysis, from [rda.ucar.edu](https://rda.ucar.edu/) repository
> NB You need a valid account on [rda.ucar.edu](https://rda.ucar.edu/index.html?hash=data_user&action=register) to proceed.
1. Fill the password fields with your [rda.ucar.edu](https://rda.ucar.edu/) password.
1. Click ![](assets/submit.png) and ... ![](https://www.webpagefx.com/tools/emoji-cheat-sheet/graphics/emojis/tada.png) Your analysis will perform on a remote site. ![](https://www.webpagefx.com/tools/emoji-cheat-sheet/graphics/emojis/tada.png)

---?gist=29a1e75e40c7bae7d6114214dfab06b9

An example of *WPS* file of Italy. ([namelist.wps](https://gist.github.com/mtorrisi/29a1e75e40c7bae7d6114214dfab06b9))

---?gist=a7c11a812b5294e011977cd290818de0

An example of *INPUT* file. ([namelist.input](https://gist.github.com/mtorrisi/a7c11a812b5294e011977cd290818de0))

---?gist=380ea4af805494fc85dc668dff46ec12

The download script for the previous inputs. ([download-lbc.csh](https://gist.github.com/mtorrisi/380ea4af805494fc85dc668dff46ec12))

---

### Demo

![Video](https://www.youtube.com/embed/KT9QfURIOcA)

---

### Are you stuck or need any help?

Start new discussions at: [discourse.sci-gaia.eu](http://discourse.sci-gaia.eu/)

---

### Thank you!
#### [www.sci-gaia.eu](http://www.sci-gaia.eu)
