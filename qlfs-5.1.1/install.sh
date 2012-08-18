# !/bin/bash
#****************************************************************************
#               QLFS-511-final http://lfs-italia.homelinux.org              #
#                                                                           #
#      Copyright (C) 2005 Matteo Mattei   matteo.mattei@gmail.com           #
#                         Marco Sciatta   marco.sciatta@gmail.com           #
#                                                                           #
# This program is free software; you can redistribute it and/or modify      #
# it under the terms of the GNU General Public License as published by      #
# the Free Software Foundation; either version 2 of the License, or         #
# (at your option) any later version.                                       #
#                                                                           #
# This program is distributed in the hope that it will be useful,           #
# but WITHOUT ANY WARRANTY; without even the implied warranty of            #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
# GNU General Public License for more details.                              #
#                                                                           #
# You should have received a copy of the GNU General Public License         #
# along with this program; if not, write to the Free Software               #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA #
#                                                                           #
#****************************************************************************

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


############################################
# Gestisce le opzioni passate allo script 
############################################
# Setta le variabili per le opzioni di base le setta qui,poi verranno passate
# agli altri script attraverso il file /tmp/lfs/lfs-var, che viene modificato 
# alla fine di questo file, in questo modo si evita di sporcare il file,
# ottenuto dalla decompressione del pacchetto originale.

function print_help()
{
echo -e "Uso: ./install.sh [OPZIONE] -l={ita | eng}
	
  -c, --check        			Lo script eseguira' i controlli durante 
  					la compilazione.
  -s, --stripping    			Consente la cancellazione dei simboli di 
  					debug dopo la compilazione.
  -m, --no-sum 				Non esegue il controllo md5 sui pacchetti.
					E' sconsigliato usare quest'opzione.
  -l={ita |eng}, --language={ita |eng}  Lancia lo script nella lingua selezionata 
  					italiano o inglese.
  -h, --help				Stampa questo aiuto.
  -V, --version 			Stampa informazioni sulla versione.
	\n
	Di default lo script viene lanciato in lingua inglese, non esegue 
	nessun controllo sulla compilazione,ne cancella i simboli di debug.
	Quindi tutte le opzioni risultano disabilitate.\n"
}

function print_version()
{
echo -e "QLFS install.sh versione: 5.1.1-final
Scritto da Marco Sciatta e Matteo Mattei.

Collaboratori : Emanuele Rogledi e Daniele Maio.
Copyright (C) QLFS ;P
http://lfs-italia.homelinux.org

Questo programma e' distribuito sotto licenza GPL. Quindi e'
possibile modificarlo e ridistribuirlo senza alcun problema.
Vedi la licenza GPL per ulteriori dettagli.\n"


}



linguaggio="eng" #di default lo script e' in inglese.
check_control="false" #di default e' disabilitato.
execute_stripping="false" #di default non viene eseguito.
md5_sum="true" #di default viene eseguito il controllo md5
create_swap="false" # di default viene utilizzata quella del sistema host
fsformat=""

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
			linguaggio=$optarg ;;
		-s | --stripping)
			execute_stripping="true" ;;
		-m | --no-sum)
			md5_sum="false" ;;
		-s | --new_swap)
			create_swap="true" ;; #da abilitare (forse)
		-h  | --help)
			print_help
			#echo -e $aiuto	
			exit 1 ;; 
		-V  | --version) 
			#echo -e $versione
			print_version
			exit 1 ;; 
	         *)
			echo "Opzione non riconosciuta"
			print_help
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

if [ $linguaggio = "eng" ] 
then	
	#nessun parametro passato: default inglese
	cp ./lang/eng ./language

else
		#setto lingua it come default
		cp ./lang/ita ./language
fi

source ./language
source ./lfs-utils
source ./lfs-var
#debug
#deb
#end debug
##############################################################
# controllo se l'utente che esegue lo script e' root oppure no
##############################################################
if [ "$UID" -ne "$ROOT_UID" ]
then
	echo -e $(echo $COLOR_RED)$instT1 $(echo $REPLACE)
#	rm -r /tmp/lfs
	exit $E_NONROOT
fi

###########################################################
# Controllo se lo script e' gia' stato lanciato altre volte
###########################################################
[ `grep lfs /etc/passwd` ] && userdel lfs
[ -h /tools ] && rm /tools
umount /mnt/lfs/dev/pts &> /dev/null
umount /mnt/lfs/proc &> /dev/null
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
echo ""
echo -e $(echo $COLOR_PURPLE)$instT2 $(echo $REPLACE)
read hdax
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
echo -e $(echo $COLOR_PURPLE)$instT3 $hdax
echo -e $instT4$(echo $REPLACE)
risp="f"
while [[ $risp = "f" ]] ; do
	echo -e $(echo $COLOR_PURPLE)"[Yes,no]"$(echo $REPLACE)
	risp=$(read_risp)
done

if [[ -b $hdax && $hdax != "" ]]
then
	if [[ $risp = "n" ]]
	then
		echo ""
		exit 0 #uscita dal programma
	fi
else
	echo -e $(echo $COLOR_RED)$instT5 $(echo $REPLACE)
	echo ""
	exit 0 #uscita dal programma
fi

############################################
# formatto e monto la partizione in /mnt/lfs
############################################
export LFS=/mnt/lfs
# echo "export LFS="$LFS

echo -e $(echo $COLOR_PURPLE)$instTFP1 $hdax 
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
echo -e $(echo $COLOR_GREEN_LIGHT)$instTMT $(echo $REPLACE)
mkdir -p $LFS #creo il punto di mount della nuova partizione
if mount $hdax $LFS #controllo che la partizione esista
then
	echo -e $(echo $COLOR_GREEN_LIGHT)$hdax $instTMK$(echo $REPLACE)
else
        echo -e $(echo $COLOR_RED)$instTMF $hdax $(echo $REPLACE)
	exit 0 #uscita dal programma
fi
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

useradd -s /bin/bash -m -k /dev/null lfs
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
touch /mio
chmod a+rw /mio
#################################
echo ""
echo -e $(echo $COLOR_GREEN_LIGHT)$instTF $(echo $REPLACE)
echo ""
su - lfs
