from cyrhenry/rpi-ubuntu:trusty


RUN apt-get update && \
         apt-get install -y \
                git \
                python

ENV BACMON_HOME="/home/bacmon" BACMON_INI="${BACMON_HOME}/BACmon.ini"

RUN mkdir -p ${BACMON_HOME}; cd ${BACMON_HOME} && \
        git clone https://git.code.sf.net/p/bacmon/code bacmon-code && \
        adduser --system bacmon --home ${BACMON_HOME}

#DON'T NEED NTP in the container
#RUN apt-get install -y ntp ntpdate && \
#       /etc/init.d/ntp stop && \
#       /etc/init.d/ntp start

#PYTHON
RUN apt-get install -y gcc make python-dev python-setuptools python-libpcap && \
        easy_install pytz && \
        easy_install simplejson && \
        easy_install -U bottle && \
        easy_install -U bacpypes

# we need lib32z1-dev or something along those lines...
RUN apt-get  install -y libghc-zlib-dev && \
        apt-get install -y libxslt-dev &&  \
        easy_install lxml
RUN apt-get install -y redis-server && \
        easy_install -U redis
RUN apt-get install -y nmap && \
        chmod u+s /usr/bin/nmap

#doesn't work since it's interactive
#COPY THE CONFIG FILE INSTEAD
#RUN cd ${BAMON_HOME}/bacmon-code/ && \
#       python bacmon_config_helper.py || exit 1 && \
#       sudo -u bacmon cp -v bacmon_ini ${BACMON_INI}

COPY BACmon.ini ${BACMON_INI}


#ENV BACMON_LOGDIR=`cat /home/bacmon/BACmon.ini | grep ^logdir: | awk -F:\  '{ print $2 }'`
#ENV BACMON_APACHEDIR=`cat /home/bacmon/BACmon.ini | grep ^apachedir: | awk -F:\  '{ print $2 }'`
#ENV BACMON_STATICDIR=`cat /home/bacmon/BACmon.ini | grep ^staticdir: | awk -F:\  '{ print $2 }'`
#ENV BACMON_TEMPLATEDIR=`cat /home/bacmon/BACmon.ini | grep ^templatedir: | awk -F:\  '{ print $2 }'`

#RUN sudo -u bacmon mkdir $BACMON_LOGDIR; \
#       sudo -u bacmon chmod +rw $BACMON_LOGDIR
#RUN sudo -u bacmon mkdir $BACMON_APACHEDIR; \
#        sudo -u bacmon chmod +rw $BACMON_APACHEDIR
#RUN sudo -u bacmon mkdir $BACMON_STATICDIR; \
#        sudo -u bacmon chmod +rw $BACMON_STATICDIR; \
#        sudo -u bacmon mkdir $BACMON_STATICDIR/js; \
#        sudo -u bacmon chmod +rw $BACMON_STATICDIR/js; \
#        sudo -u bacmon cp -v ./static/* $BACMON_STATICDIR; \
#        sudo -u bacmon cp -v ./static/js/* $BACMON_STATICDIR/js
#RUN sudo -u bacmon mkdir $BACMON_TEMPLATEDIR; \
#        sudo -u bacmon chmod +rw $BACMON_TEMPLATEDIR; \
#        sudo -u bacmon cp -v ./template/* $BACMON_TEMPLATEDIR

#TODO in the entry point
#RUN apt-get install -y libapache2-mod-wsgi; \
#       sudo -u bacmon cp BACmonWSGI.py $BACMON_HOME; \
#       chmod +x $BACMON_HOME/BACmonWSGI.py; \
#       sudo -u bacmon cp XML.py $BACMON_HOME; \
#       sudo -u bacmon cp XHTML.py $BACMON_HOME; \
#       sudo -u bacmon cp timeutil.py $BACMON_HOME
#       cp bacmon_apache_wsgi /etc/apache2/sites-available/bacmon; \
#       a2dissite default || echo "(no default site to disable)"
#       a2ensite bacmon; \
#       apache2ctl restart

#TODO in the entrypoint
#RUN apt-get install -y daemonlogger; \
#       cp bacmonlogger_init /etc/init.d/bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc0.d/K20bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc1.d/K20bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc2.d/S20bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc3.d/S20bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc4.d/S20bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc5.d/S20bacmonlogger; \
#       ln /etc/init.d/bacmonlogger /etc/rc6.d/K20bacmonlogger; \
#       sudo -u bacmon cp bacmonlogger_purge.sh $BACMON_HOME/; \
#       sudo -u bacmon crontab bacmonlogger_purge.crontab; \
#       /etc/init.d/bacmonlogger start

# TODO: ENTRYPOINT
#RUN sudo -u bacmon cp BACmon.py $BACMON_HOME; \
#       cp bacmon.conf /etc/init/bacmon.conf; \
#       initctl reload-configuration; \
#       start bacmon

