#!/bin/bash

# setup.sh Author : Eliel César
# Instalar pacotes e dependencias necessarias.
# --------------------------------------------------------


#Cores para script
cyan='\e[0;36m'

#Banner 
echo -e $cyan ""
echo "         [ ]=================================================[ ] ";
echo "         [ ]          setup.sh - configuration script        [ ]"
echo "         [ ]       Use este script p/ configurar clonezilla  [ ]"
echo "         [ ]          Installe todas as  dependencias        [ ]"
echo "         [ ]=================================================[ ]";
echo ""

#Verifica se o usuario e o root.
if [ $(id -u) != "0" ]; then

      echo [*]::[Checando Dependencias] ;
      sleep 2
      echo [!]::[Check User]: $USER ;
      sleep 1
      echo [x]::[not root]: você precisa ser [root] para rodar este script.;
      echo ""
   	  sleep 1
	  exit
	  
else

   echo [*]::[Check Dependencies]: ;
   sleep 1
   echo [OK]::[Check User]: $USER ;

fi

#Verifica se existe conexão com a internet.

  ping -c 5 google.com > /dev/null 2>&1
  if [ "$?" != 0 ]

then

    echo [*]::[Teste de conexão]: FEITO!;
    echo [x]::[Aviso]: Este script precisa de conexão com a internet.;
    sleep 2

else

    echo [OK]::[Teste de conexão]: conectado!;
    sleep 2
fi

#Desabilita o selinux

echo [*]::[Desabilita Selinux]: FEITO!;
sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

#Iniciando a atualização dos pacotes.                                      

echo [*]::[Atualizando o sistema]: Aguarde!;
	sleep 2
	yum update -y && yum upgrade -y
	yum install epel-release.noarch -y -q
	yum update -y
	echo

#Desabilita o firewalld usaremos somente o iptables.

echo [*]::[Desabilita firewalld]: Aguarde!;
	systemctl stop firewalld
	systemctl disable firewalld
	sleep 2

#Instalar a chave do drbl no sistema
	echo [*]::[Baixando a chave do DRBL]: Aguarde!
	rm -f GPG-KEY-DRBL; wget http://drbl.org/GPG-KEY-DRBL; rpm --import GPG-KEY-DRBL && sleep 2 && echo

#Faz a instalação do pacote no sistema 
	echo [*]::[Instalando o pacote no sitema]: Aguarde!;
	yum install ./drbl-2.25.10-drbl1.noarch.rpm -y && sleep 2 && echo

#Instala o modulo perl 
	echo [*]::[Instalando o modulo perl no sistema]: Aguarde!
	yum install perl-Digest-SHA1.x86_64 -y && sleep 2 && echo 

#Iniciando as configurações do clonezilla server
	chmod +x /usr/sbin/drblpush
	chmod +x /usr/sbin/drblsrv
	/usr/sbin/drblsrv -i


echo "";
  echo "[ ]====================================================================[ ]";
  echo "[ ]           Tudo pronto!! Execulte o script clonezilla.sh  :) !      [ ]";
  echo "[ ]====================================================================[ ]";
  echo "";
  sleep 3
  exit