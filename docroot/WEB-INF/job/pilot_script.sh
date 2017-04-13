#!/bin/sh
echo "------------------------------------------------"
echo "                WRF EXECUTION                   "
echo "------------------------------------------------"
# Get the hostname
HOSTNAME=$(hostname)
NAMELIST_WPS=$(ls -1 | grep $1)
NAMELIST_INPUT=$(ls -1 | grep $2)
DOWNLOAD_SCRIPT=$(ls -1 | grep $3)
PASSWORD_FILE=$(ls -1 | grep $4)
echo "Job landed on: '"$HOSTNAME"'"
echo "WPS file:  '"$NAMELIST_WPS"'"
echo "INPUT file:  '"$NAMELIST_INPUT"'"
echo "DOWNLOAD SCRIPT:  '"$DOWNLOAD_SCRIPT"'"
echo "-------------------------------------------------"
echo "  JOB STARTS AT: '"$(date)"'"
echo ""
echo "Download GRIB file ... "
mkdir datafile
cd datafile
cp ../$DOWNLOAD_SCRIPT .
cp ../$PASSWORD_FILE .
PASSWORD=$(cat $PASSWORD_FILE)
./$DOWNLOAD_SCRIPT $PASSWORD & 
PID=$!
# 5GB
SIZE="5242880"
while ps -p $PID > /dev/null
do

        # check the current size
        CHECK="`du | awk '{print $1}'`"
        if [ "$CHECK" -gt "$SIZE" ]; then
                echo "Maximum download size (5GB) exceeded."
                break
        fi
done
rm $DOWNLOAD_SCRIPT $PASSWORD_FILE
cd ..
echo "Copying WPS folder ..."
cp -r /opt/Build_WRF/WPS/ .
mkdir WRF
echo "Copying WRF run files ..."
cp /opt/Build_WRF/WRFV3/run/* WRF
echo "Copying '"$NAMELIST_WPS"' in WPS folder ..."
cp $NAMELIST_WPS WPS/namelist.wps
echo "Copying '"$NAMELIST_WPS"' in WPS folder ..."
cd WPS
echo "Performing geogrid.exe ..."
./geogrid.exe
echo "Performing ungrib.exe  ..."
./link_grib.csh ../datafile/* .
cp ungrib/Variable_Tables/Vtable.GFS Vtable
./ungrib.exe
echo "Performing metgrid.exe ..."
./metgrid.exe
echo "Performing real.exe ..."
cd ../
cp $NAMELIST_INPUT WRF/namelist.input
cd WRF
ln -sf ../WPS/met_em.d0* .
./real.exe
echo "Performing wrf.exe ..."
./wrf.exe
cd ..
echo "Creating output archive ..."
mkdir outputs
mv WPS/*.log outputs
mv WRF/wrfout* outputs
mv WRF/rsl.* outputs

tar -zcf outputs.tar.gz outputs/
echo "Cleaning work directory ..."
rm -rf WRF WPS outputs datafile
echo "  JOB ENDS AT: '"$(date)"'"
echo "-------------------------------------------------"
