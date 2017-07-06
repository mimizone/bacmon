from cyrhenry/rpi-ubuntu:trusty 


RUN apt-get update && \
	 apt-get install -y \
		git \
		python

ENV BACMON_HOME="/home/bacmon" BACMON_INI="${BACMON_HOME}/BACmon.ini"

RUN adduser --system bacmon --home ${BACMON_HOME}

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

COPY BACmon.ini ${BACMON_INI}	

RUN BACMON_LOGDIR=`cat ${BACMON_INI} | grep ^logdir: | awk -F:\  '{ print $2 }'` && \
	sudo -u bacmon mkdir -p ${BACMON_LOGDIR} && \
	sudo -u bacmon chmod +rw ${BACMON_LOGDIR}

RUN BACMON_APACHEDIR=`cat /home/bacmon/BACmon.ini | grep ^apachedir: | awk -F:\  '{ print $2 }'` && \
	sudo -u bacmon mkdir ${BACMON_APACHEDIR} && \
        sudo -u bacmon chmod +rw ${BACMON_APACHEDIR}

RUN BACMON_STATICDIR=`cat /home/bacmon/BACmon.ini | grep ^staticdir: | awk -F:\  '{ print $2 }'` && \
	sudo -u bacmon mkdir ${BACMON_STATICDIR} && \
        sudo -u bacmon chmod +rw ${BACMON_STATICDIR} && \
        sudo -u bacmon mkdir $BACMON_STATICDIR/js && \
        sudo -u bacmon chmod +rw $BACMON_STATICDIR/js && \
        sudo -u bacmon cp -v ./static/* $BACMON_STATICDIR && \
        sudo -u bacmon cp -v ./static/js/* $BACMON_STATICDIR/js

RUN BACMON_TEMPLATEDIR=`cat /home/bacmon/BACmon.ini | grep ^templatedir: | awk -F:\  '{ print $2 }' && \
	sudo -u bacmon mkdir $BACMON_TEMPLATEDIR; \
        sudo -u bacmon chmod +rw $BACMON_TEMPLATEDIR; \
        sudo -u bacmon cp -v ./template/* $BACMON_TEMPLATEDIR

RUN apt-get install -y libapache2-mod-wsgi && \
	sudo -u bacmon cp BACmonWSGI.py $BACMON_HOME && \
    	chmod +x $BACMON_HOME/BACmonWSGI.py && \
    	sudo -u bacmon cp XML.py $BACMON_HOME && \
   	sudo -u bacmon cp XHTML.py $BACMON_HOME && \
    	sudo -u bacmon cp timeutil.py $BACMON_HOME && \
	cp bacmon_apache_wsgi /etc/apache2/sites-available/bacmon && \
	a2dissite default || echo "(no default site to disable)" && \
    	a2ensite bacmon

#TODO ADD TO ENTRYPOINT
#	apache2ctl restart

#convert so ENTRYPOINT/SYSTEMD
#RUN apt-get install -y daemonlogger; \
#	cp bacmonlogger_init /etc/init.d/bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc0.d/K20bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc1.d/K20bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc2.d/S20bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc3.d/S20bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc4.d/S20bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc5.d/S20bacmonlogger; \
#    	ln /etc/init.d/bacmonlogger /etc/rc6.d/K20bacmonlogger; \
#    	sudo -u bacmon cp bacmonlogger_purge.sh $BACMON_HOME/; \
#    	sudo -u bacmon crontab bacmonlogger_purge.crontab; \
#    	/etc/init.d/bacmonlogger start

# TODO: ENTRYPOINT
#RUN sudo -u bacmon cp BACmon.py $BACMON_HOME; \
#	cp bacmon.conf /etc/init/bacmon.conf; \
#   	initctl reload-configuration; \
#	start bacmon

# TODO: EXPOSE PORTS (APACHE)

