# !/bin/bash
########
# Autori
########
# Script realizzato da:
# Matteo Mattei, e-mail: matteo.mattei@gmail.com
# Marco  Sciatta, e-mail: marco.sciatta@gmail.com
# 
# grazie per la collaborazione a:
# Emanuele Rogledi, e-mail: emanuele@rogledi.com
# Daniele  Maio, e-mail: daniele.maio@gmail.com
# Giovanni Scafora, e-mail linuxmania@gmail.com





############################################
# Gestisce le opzioni passate allo script 
############################################
# Setta le variabili per le opzioni di base le setta qui,poi verranno passate
# agli altri script attraverso il file /tmp/lfs/lfs-var, che viene modificato 
# alla fine di questo file, in questo modo si evita di sporcare il file,
# ottenuto dalla decompressione del pacchetto originale.

######## ********** SERVE QUI ! ******* ##########
function setlan()
{
if [[ $linguaggio != "eng" ]]
then
	for lingua in $(ls ./lang/); do	
		if [[ $linguaggio == $lingua ]]
		then
			cp ./lang/$linguaggio ./language
			templang="1"
			continue
		fi
	done
	if [[ $templang != "1" ]]
	then
		echo "LANGUAGE REQUESTED NOT FOUND, USE ENGLISH DEFAULT..."
		cp ./lang/eng ./language
	fi
else
	cp ./lang/eng ./language
fi
source ./language
}
linguaggio="eng" #di default lo script e' in inglese.
check_control="false" #di default e' disabilitato.
execute_stripping="false" #di default non viene eseguito.
md5_sum="true" #di default viene eseguito il controllo md5
create_swap="false" # di default viene utilizzata quella del sistema host
fsformat=""
optimize="false" # di default no high optmization

source ./lfs-utils
source ./lfs-var

setlan

source ./language

for option 
do
  	optarg=`expr "$option" : '[^=]*=\(.*\)'`
	case $option in 
		#aggiungere nel case le opzioni necessarie.
		#in forma lunga o a carattere.
		#se un'opzione accetta un argomento usare la forma =* 
		-c | --check)
			check_control="true" ;; 
		-l=* | --language=*)
			linguaggio=$optarg 
			setlan;;
		-s | --stripping)
			execute_stripping="true" ;;
		-m | --no-sum)
			md5_sum="false" ;;
		-s | --new_swap)
			create_swap="true" ;; #da abilitare (forse)
		-o | --optimize)
			optimize="true";;
		-h  | --help)
			##print_help
			echo -e $h
			exit 0;;
		-V  | --version) 
			echo -e $version
			exit 0;;
	         *)
			echo -e $opz
			echo -e $h
			exit 1 ;;
	esac
done

########################################
# SCANNO LE VAR PER OTTENERE LA LINGUA #
########################################
# Questa parte e' ok...ma lfs-utils va in cresh per via
# Dell'include all'inizio di questo file.
# Infatti quando viene caricato lfs-utils, il file 
# language non esiste ancora
#mkdir /tmp/lfs &> /dev/null

##############################################################
# controllo se l'utente che esegue lo script e' root oppure no
##############################################################
if [ "$UID" -ne "$ROOT_UID" ]
then
	echo -e $(echo $COLOR_RED)$instT1 $(echo $REPLACE)
#	rm -r /tmp/lfs
	exit $E_NONROOT
fi

##########################################################
# controllo se il sistema host rispetta i requisiti minimi
##########################################################

kmachine=($(cat /proc/version | awk '{print $3}{print $7}'))
echo $(echo $COLOR_GREEN_LIGHT) $msck1 ${kmachine[0]} $msck2 ${kmachine[1]} $(echo $REPLACE)

	kmachine[0]=$(echo `expr match "${kmachine[0]}" '\([0-9].[0-9].[0-9]*\)'`)
	check_triple ${kmachine[0]} $KMIN
	if [ $? -eq 0 ]; then
		echo -e $(echo $COLOR_RED)$mserr1 $KMIN. \n $mserr2 $(echo $REPLACE)
		exit  $E_KERNEL
	else
	   kmachine[1]=$(echo `expr match "${kmachine[1]}" '\([0-9].[0-9].[0-9]*\)'`)
           check_triple ${kmachine[1]} $GMIN
	   if [ $? -eq 0 ]; then 
		echo -e $(echo $COLOR_RED) $msok1 ${kmachine[0]} $msok2 ${kmachine[1]} $msok3 $(echo $REPLACE)
		exit $E_GCC
	   fi
	fi


###########################################################
# Controllo se lo script e' gia' stato lanciato altre volte
###########################################################
[ `grep lfs /etc/passwd` ] && userdel lfs
[ -h /tools ] && rm /tools
umount /mnt/lfs/dev/pts &> /dev/null
umount /mnt/lfs/proc &> /dev/null
umount /mnt/lfs/sys &> /dev/null
umount /mnt/lfs/dev/shm &> /dev/null
umount /mnt/lfs/dev &> /dev/null
umount /mnt/lfs &> /dev/null 
rm -r /tmp/lfs &> /dev/null
rm -r /home/lfs &> /dev/null


####################
# messaggio iniziale
####################
clear  
echo -e $(echo $COLOR_GREEN_LIGHT)$instTM $(echo $REPLACE)
sleep 3
echo $(echo $COLOR_PURPLE)$instTT
fdisk -l
echo "" $(echo $REPLACE)
##### Multiple Partition
hmp
#echo -e $(echo $COLOR_PURPLE)$instT2 $(echo $REPLACE)
#read hdax
########################################################
######## PROVA DI INSERIMENTO SWAP #####################
########################################################
echo -e $(echo $COLOR_PURPLE)$instSWAP $(echo $REPLACE)
risp="f"
while [[ $risp = "f" ]] ; do
	echo -e $(echo $COLOR_PURPLE)"[Yes,no]"$(echo $REPLACE)
	risp=$(read_risp)
done
if [[ $risp = "n" ]]
then
	echo ""
	swap="'# shared'"
else
	echo -e $(echo $COLOR_PURPLE)$instSWAP1 $(echo $REPLACE)
	read hday
	if [[ -b $hday && $hday != "" ]]
	then
		swap=$hday
		mkswap $hday && \
		echo -e $(echo $COLOR_PURPLE)$instSWAP2 $(echo $REPLACE)
	else
		echo -e $(echo $COLOR_PURPLE)$instSWAP3 $(echo $REPLACE)
		swap="'# shared'"
	fi
fi
########################################################
########################################################

################################################
##### verifico quante partizioni ha scelto #####
################################################
if [ ! -z $hdax1 ]
then
        ver=$hdax1"#"
        echo -e $(echo $COLOR_PURPLE)$instT3bis "" $f "is" $hdax1
fi
if [ ! -z $hdax2 ]
then
        ver=$ver$hdax2"#"
        echo -e $(echo $COLOR_PURPLE)$instT3bis "" $s "is" $hdax2
fi
if [ ! -z $hdax3 ]
then
        ver=$ver$hdax3"#"
        echo -e $(echo $COLOR_PURPLE)$instT3bis "" $t "is" $hdax3
fi
if [ ! -z $hdax4 ]
then
        echo -e $(echo $COLOR_PURPLE)$instT3bis $hdax4
fi
echo -e $instT4$(echo $REPLACE)
#echo -e $(echo $COLOR_PURPLE)$instT3 $hdax
#echo -e $instT4$(echo $REPLACE)
risp="f"
while [[ $risp = "f" ]] ; do
	echo -e $(echo $COLOR_PURPLE)"[Yes,no]"$(echo $REPLACE)
	risp=$(read_risp)
done

#if [[ -b $hdax && $hdax != "" ]]
#then
if [[ $risp = "n" ]]
then
	echo ""
	exit 0 #uscita dal programma
fi
if [[ $risp = "y" ]]
then
	verifyhd;
	if [[ "$x" == "$E_HDP" ]]
        then
                echo -e $(echo $COLOR_RED)$instT5 $cmd $(echo $REPLACE)
                echo ""
                exit 0 #uscita dal programma
        fi
fi


########### ERA COMMENTATO ANCHE PRIMA ??? ##########
#else
#	echo -e $(echo $COLOR_RED)$instT5 $(echo $REPLACE)
#	echo ""
#	exit 0 #uscita dal programma
#fi
#fi
################################################
# formatto e monto la/le partizione in /mnt/lfs
################################################
export LFS=/mnt/lfs
if [ $part -gt 1 ]
then
	##### con questo le esporto (sinceramente nn so se serve...)
        case $part in
                2) echo "export LFSS=/mnt/lfs$s";
	                export LFSS=/mnt/lfs$s
        	        ##second partion to export 
                	;;
                3) export LFSS=/mnt/lfs$s
                        export LFST=/mnt/lfs$t
                        ;;
		4) export LFSS=/mnt/lfs$s
			export LFST=/mnt/lfs$t
			export LFSQ=/mnt/lfs$q
			;;
                *) echo ";("
			;;
        esac
fi

for ((i=1;$i<=$part;i++)); do
	#### con questo le monto ;D
        case $i in
                1) p=$hdax1
                mtp="/mnt/lfs"
		#$f" ##mount point
                ;;
                2) p=$hdax2
                mtp="/mnt/lfs$s"
                ;;
                3) p=$hdax3
                mtp="/mnt/lfs$t"
                ;;
		4) p=$hdax4
		mtp="/mnt/lfs$q"
		;;
        esac

# echo "export LFS="$LFS

echo -e $(echo $COLOR_PURPLE)$instTFP1 $p 
echo -e $instTFP2$(echo $REPLACE)
risp="f"
while [[ $risp = "f" ]] ; do
	echo -e $(echo $COLOR_PURPLE)"[Yes,no]"$(echo $REPLACE)
	risp=$(read_risp)
done
		
if [[ $risp = "n" ]]
then
	echo ""
	exit 0
else
#SCELTA TIPO FS
echo -e $(echo $COLOR_PURPLE)$FSsT

choice="5"
while [[ $choice = "5" ]] ; do
	echo -e $(echo $COLOR_PURPLE)$FSqT $(echo $REPLACE)
	choice=$(scelta)
done
hdax=$p
case "$choice" in
	"1" )
		echo -e $(echo $COLOR_GREEN_LIGHT)$MET3
		echo -e $(echo $COLOR_CYAN)$M1T
	   	fsformat="ext3"
		if fs_ext3
	   	then 
			echo -e $M2T $(echo $REPLACE)
       	else
			echo -e $(echo $COLOR_RED)$MFT $(echo $REPLACE)
			echo ""
			exit 0
   	fi ;;
	"2")
		echo -e $(echo $COLOR_GREEN_LIGHT)$MET
		echo -e $(echo $COLOR_CYAN)$M1T
		fsformat="ext2"
		if fs_ext2
		then 
			echo -e $M2T $(echo $REPLACE)
          	else
			echo -e $(echo $COLOR_RED)$MFT $(echo $REPLACE)
			echo ""
			exit 0
	   	fi ;;
	"3")
		echo -e $(echo $COLOR_GREEN_LIGHT)$MRT
		echo -e $(echo $COLOR_CYAN)$M1T
	   	fsformat="reiserfs"
		if fs_reiserfs
	   	then 
			echo -e $M2T $(echo $REPLACE)
        	else
			echo -e $(echo $COLOR_RED)$MFT $(echo $REPLACE)
			echo ""
			exit 0
	   	fi ;;  
esac

fi
sleep 1
echo -e $(echo $COLOR_GREEN_LIGHT)$instTMT $p $mtp $(echo $REPLACE)
mkdir -p $mtp #creo il punto di mount della nuova partizione

if mount $p $mtp #controllo che la partizione esista
then
	echo -e $(echo $COLOR_GREEN_LIGHT)$p $instTMK $(echo $REPLACE)
else
        echo -e $(echo $COLOR_RED)$instTMF $p $(echo $REPLACE)
	exit 0 #uscita dal programma
fi
done
###########################################
# Entro nella dir $LFS e preparo l'ambiente
###########################################

echo -e $(echo $COLOR_GREEN_LIGHT)$instTPA $(echo $REPLACE)
mkdir -p $LFS/sources
mkdir -p $LFS/tools
chmod a+wt $LFS/sources
ln -s $LFS/tools / #creo il link simbolico nella root del sistema ospite

###################
# Creo l'utente lfs
###################
groupadd lfs 
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
echo -e $(echo $COLOR_PURPLE)$instTPU
passwd lfs #imposto la password per l'utente lfs

########################################
# Modificare i permessi per l'utente lfs 
########################################

echo -e $(echo $COLOR_GREEN_LIGHT)$instTAPU $(echo $REPLACE)
chown lfs $LFS/tools
chown lfs $LFS/sources

################################
# Copio tutti i file in /tmp/lfs 
################################
mkdir /tmp/lfs
chmod 777 /tmp/lfs
cp ./*.sh /tmp/lfs
cp ./lfs* /tmp/lfs
# copio file linguaggio 
# Lo sposto in modo che la dir rimanga pulita.
mv ./language /tmp/lfs
######################
chmod +xwr -R /tmp/lfs
cp ./defconfig /tmp/lfs
###################################################
# Imposta lo script  con i parametri di avvio 
###################################################
echo "execute_stripping=$execute_stripping" >> /tmp/lfs/lfs-var
echo "check_control=$check_control" >> /tmp/lfs/lfs-var
echo "md5_sum=$md5_sum" >> /tmp/lfs/lfs-var
echo "hdax=$hdax" >> /tmp/lfs/lfs-var
echo "swap=$swap" >> /tmp/lfs/lfs-var
echo "fsformat=$fsformat" >> /tmp/lfs/lfs-var
##################################
# Non cancellare !! debug funzioni
##################################
touch /qlfs-debug
chmod a+rw /qlfs-debug 
#################################
echo ""
echo -e $(echo $COLOR_GREEN_LIGHT)$instTF $(echo $REPLACE)
echo ""
su - lfs
