#!/bin/bash

if sudo echo "==== Iniciando verificação dos repositórios ===="
then
  curl -k -s "https://publico.fontes.intranet.bb.com.br/f3893418/instalando-linux-ubuntu-based/-/raw/master/lib3270_1540585420-0_amd64.deb?inline=false" -o lib3270_amd64.deb
  curl -k -s "https://publico.fontes.intranet.bb.com.br/f3893418/instalando-linux-ubuntu-based/-/raw/master/pw3270_1540585420-0_amd64.deb?inline=false" -o pw3270_amd64.deb
  curl -s "http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb" -o libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

  #Verificando se os arquivos foram encontrados
  if [ -e lib3270_amd64.deb ] && [ -e pw3270_amd64.deb ] && [ -e libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb ]
  then
    echo "==== Iniciando instalação dos arquivos ===="
    sudo dpkg -i lib3270_amd64.deb >> /dev/null
    sudo dpkg -i pw3270_amd64.deb >> /dev/null
    sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb >> /dev/null
  else
    echo "Não foi possível receber os arquivos dos repositórios"
    exit 1
  fi

  #realizando a instalação das dependencias
  sudo apt --fix-broken install -y
  sudo dpkg -i lib3270_amd64.deb >> /dev/null
  sudo dpkg -i pw3270_amd64.deb >> /dev/null
  sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb >> /dev/null


  sudo curl -k -s "https://publico.fontes.intranet.bb.com.br/f3893418/instalando-linux-ubuntu-based/-/raw/master/opensslTLSv1.cnf?inline=false" -o opensslTLSv1.cnf --output-dir /usr/share/pw3270

  if [ -d $HOME/config ]
  then
    touch $HOME/config/sisbb.sh
    echo "OPENSSL_CONF=/usr/share/pw3270/opensslTLSv1.cnf pw3270" > $HOME/config/sisbb.sh
  else
    mkdir $HOME/config
    touch $HOME/config/sisbb.sh
    echo "OPENSSL_CONF=/usr/share/pw3270/opensslTLSv1.cnf pw3270" > $HOME/config/sisbb.sh
  fi

  if [ -d $HOME/.local/share/applications ]
  then
    touch $HOME/.local/share/applications/sisbb.desktop
  else
    mkdir $HOME/.local/share/applications
    touch $HOME/.local/share/applications/sisbb.desktop
  fi

  echo [Desktop Entry] > $HOME/.local/share/applications/sisbb.desktop
  echo Name=SISBB >> $HOME/.local/share/applications/sisbb.desktop
  echo Comment=Executa o pw3270 ajustando o openssl.cnf primeiro >> $HOME/.local/share/applications/sisbb.desktop
  echo GenericName=SISBB >> $HOME/.local/share/applications/sisbb.desktop
  echo "Exec=bash -c \"/home/$USER/config/sisbb.sh;pw3270\"" >> $HOME/.local/share/applications/sisbb.desktop
  echo Icon=/usr/share/pw3270/pw3270-logo.png >> $HOME/.local/share/applications/sisbb.desktop
  echo Type=Application >> $HOME/.local/share/applications/sisbb.desktop
  echo StartupNotify=true >> $HOME/.local/share/applications/sisbb.desktop
  echo "Categories=GNOME;GTK;Utility;Development;IDE;" >> $HOME/.local/share/applications/sisbb.desktop

  rm -rf lib3270_amd64.deb pw3270_amd64.deb libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

  sudo sed -i "99d" /usr/share/pw3270/ui/00default.xml
  sudo sed -i "99s/menuitem action='disconnect' icon='disconnect' group='online' label='_Disconnect' /menuitem name='SISBB' action='connect' icon='connect' group='offline' label='SISBB' host='tn3270e.df.bb:9023' /" /usr/share/pw3270/ui/00default.xml
  echo "==== Instalação concluída ===="
else
  echo "Abortando"
fi
