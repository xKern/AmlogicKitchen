# Working with the third level of Amlogic firmware
--------------------------------------------------------

Instructions:

1) To work with the third level, you must unpack level 1 first

2) run unpack and select level3

3) In the level3 folder, we replace/correct the files in the folders:

- boot - boot partition (kernel)
- boot_* - boot partition (kernel)
- recovery - partition recovery
- recovery_* - partition recovery
- logo - logo section
- devtree - device tree section

4) run pack and select level3

5) then pack level 1 to run pack and select 1 or to create full OTA, run pack_level1_fota
