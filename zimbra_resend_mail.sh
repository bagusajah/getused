#!/bin/bash

# begin loop to add the requirements to each acct in this file
for i in `cat /tmp/users_accts`

do
    user_name=`echo $i || grep -o '^[^@]+'`
    cd /opt/zimbra/store/0/8/msg/0
    file_name=`grep -l $user_name *`
    if [ ! -f //opt/zimbra/store/0/8/msg/0/$file_name ] ; then
         echo "filename not found, save to list"
         echo "$i email file not found" >> /tmp/resend_mail_notfound
    else
         echo "email address is $i and username is $user_name and filename is $file_name"
         echo "resend quarantine emails to mailbox for this account...."
         zmlmtpinject -r $user_name -s agenbni46-support@bni.co.id $file_name
         echo "Done, moving to the next acct"
         eecho "$user_name file is $file_name" >> /tmp/resend_mail_found
    fi
    cd /tmp
    sleep 1
    echo ""
done
