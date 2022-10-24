#!/bin/bash 

#TODO: find a way to get a substring of download link from site: https://supportcenter.checkpoint.com/supportcenter/portal/user/anon/page/default.psml/media-type/html?action=portlets.DCFileAction&eventSubmit_doGetdcdetails=&fileid=22824
#.cp_link_block > a > button > "Donwload"

if sudo echo "" >> /dev/null
then

  read -e -p "Informe o caminho do certificado da VPN (.p12): " VPN_PATH
  
  if [[ $VPN_PATH =~ .p12 || $VPN_PATH =~ .P12 ]]
  then
  	echo "==== Verificando e instalando bibliotecas necessarias ===="
	  sudo apt-get install libgtk2.0-0:i386 libx11-6:i386 libpam0g:i386 libstdc++6:i386 libstdc++5:i386 libnss3-tools -y >> /dev/null
    curl -s -o snx_install.sh --output-dir ~/Downloads "https://dl3.checkpoint.com/paid/72/72c2c91791690927da0586ec873430cf/snx_install_linux30.sh?HashKey=1666377520_aa94472a90e0fe49e316376ba413c023&xtn=.sh"
	  
    echo "==== Baixando certificados de autoridade ===="
	  curl -s -o UsuarioV1.der --output-dir ~/Downloads "http://pki.bb.com.br/ACINTB2/cacerts/acus_v1.der"
	  curl -s -o AC_RaizV3.der --output-dir ~/Downloads "http://pki.bb.com.br/ACRAIZC/cacerts/raiz_v3.der"
	  echo "==== Certificados baixados ===="

    echo "==== Instalando VPN ===="
    
    echo "==== Configurando VPN ===="
    keytool -importcert -noprompt -keystore "$VPN_PATH" -alias acus_v1 -file ~/Downloads/UsuarioV1.der
    keytool -importcert -noprompt -keystore "$VPN_PATH" -alias raiz_v3 -file ~/Downloads/AC_RaizV3.der

    if [ -e ~/.snxrc ]
    then
      echo "server bbremoto.bb.com.br" > ~/.snxrc                                                                                                                           
      echo "certificate $VPN_PATH" >> ~/.snxrc
      echo "reauth yes" >> ~/.snxrc
    else
      touch ~/.snxrc
      echo "server bbremoto.bb.com.br" > ~/.snxrc
      echo "certificate $VPN_PATH" >> ~/.snxrc
      echo "reauth yes" >> ~/.snxrc
    fi
  
  echo "==== VPN configurada ===="
  echo "==== Instalação concluída ===="

  else
	  echo "O caminho informado não corresponde a um certificado."
    exit 1
  fi

else
  echo "Abortando"
fi
