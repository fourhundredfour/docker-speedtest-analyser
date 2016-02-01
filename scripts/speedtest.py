#!/usr/bin/python

# Script originally provided by AlekseyP
# https://www.reddit.com/r/technology/comments/43fi39/i_set_up_my_raspberry_pi_to_automatically_tweet/
# modifications by roest - https://github.com/roest01

import os
import csv
import datetime
import time

def runSpeedtest():

        #run speedtest-cli
        print 'running test'
        a = os.popen("python "+os.path.dirname(os.path.abspath(__file__))+"/speedtest-cli/speedtest_cli.py --simple").read()
        print 'ran'
        #split the 3 line result (ping,down,up)
        lines = a.split('\n')
        print a
        ts = time.time()
        date =datetime.datetime.fromtimestamp(ts).strftime('%d.%m.%Y %H:%M:%S')
        print date
        #if speedtest could not connect set the speeds to 0
        if "Cannot" in a:
                p = 100
                d = 0
                u = 0
        #extract the values for ping down and up values
        else:
                p = lines[0][6:11]
                d = lines[1][10:14]
                u = lines[2][8:12]
        print date,p, d, u
        #save the data to file for local network plotting
        out_file = open(os.path.dirname(os.path.abspath(__file__))+'/../data/result.csv', 'a')
        writer = csv.writer(out_file)
        writer.writerow((ts*1000,p,d,u))
        out_file.close()

        return

if __name__ == '__main__':
        runSpeedtest()
        print 'speedtest complete'