#!/usr/bin/sudo sh

version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ -z "$version" ]; then
    echo "No Python installed!" 
fi

if [ ! -d level1 ]; then
    echo "Unpack level 1 first"
    exit 0
fi

if [ "$JAVA_HOME" != "" ]; then
    echo "Install Java first"
    exit 0
fi

if [ ! -d out ]; then
    mkdir out
fi

if [ -d tmp ]; then
    echo "Deleting out folder"
    rm -rf tmp && mkdir tmp
else
    mkdir tmp
fi

cp -r bin/common/fota/* tmp/

if [ -f level1/ddr.USB ]; then
    cp level1/ddr.USB tmp/bootloader.img
elif [ -f level1/DDR.USB ]; then
    cp level1/DDR.USB tmp/bootloader.img
fi

if [ -f level1/_aml_dtb.PARTITION ]; then
    cp level1/_aml_dtb.PARTITION tmp/dt.img
fi

for part in boot dtbo logo recovery vbmeta
do
    if [ -f level1/${part}.PARTITION ]; then
        cp level1/${part}.PARTITION tmp/${part}.img
    fi
done

for part in system system_ext vendor product odm oem
do
    if [ -f level1/$part.PARTITION ]; then
        cp level1/$part.PARTITION tmp/$part.img
        python bin/common/img2sdat.py tmp/$part.img -o tmp -v 4 -p $part
        bin/linux/brotli tmp/$part.new.dat --output=tmp/$part.new.dat.br -q 6 -w 24
        rm -rf tmp/$part.img tmp/$part.new.dat
        echo "Done compressing $part"
    fi
done

bin/linux/7za a out/update_tmp.zip ./tmp/*


filename=$(cat level1/projectname.txt)
echo "Signing..."
java -jar bin/common/zipsigner.jar bin/common/testkey.x509.pem bin/common/testkey.pk8 out/update_tmp.zip "out/${filename}_fota.zip"

rm -rf out/update_tmp.zip

if [ -d tmp ]; then
    rm -rf tmp
fi