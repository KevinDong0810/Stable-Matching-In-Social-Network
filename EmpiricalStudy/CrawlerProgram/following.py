#coding=utf-8
from selenium import webdriver #use selenium to imitate the crawler process
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
import time  
import xlrd
import xlwt
import xlutils.copy
import socket
socket.setdefaulttimeout(100) #set timeout to 100s, to prevent process from running too long

def getName(name,url,table):#get names of each professor's following people
    browser.get(url) #get to the url
    browser.find_element_by_class_name("ga-view-all-profile-following").click()#click the button to open the list of following people
    time.sleep(3)   #sleep 3s to wait for the click delay, in case the list doesn't open
    global count
    following = browser.find_elements_by_class_name("display-name") #find names of the following people
    for i in range(150):
        try:
            print(following[i].text)
            count = count+1
            table.write(count,0, name)              #write names to excel
            table.write(count,1,following[i].text)
        except:                                     #if there is some mistake, such as the number of names is less than 150
            return
        
browser = webdriver.Chrome()                    #open a chrome browser
browser.get('https://www.researchgate.net/login')  #get to the login page
browser.find_element_by_id('input-login').send_keys(u'username')  #input the username
browser.find_element_by_id('input-password').send_keys(u'password')  #input the password
browser.find_element_by_xpath("//form/button").click() #click the button to login in
time.sleep(1)                                  #sleep 1 time to wait for the network delay

data = xlrd.open_workbook('member_7.xlsx')     #open the excel of these people need to get their followings
table = data.sheets()[0]
rb = xlrd.open_workbook('following_7.xls')     #open the excel of followings
wb = xlutils.copy.copy(rb)                     #continue to write instead of replacing
ws = wb.get_sheet(0)                           #get the sheet
count = 0
for i in range(table.nrows):                   #go through all the rows
    name = table.col(0)[i].value               #get the name of the professor
    url_i = str(table.col(5)[i].value)         #get the homepage of the professor
    getName(name,url_i,ws)                     #get names of his followings
    wb.save('following_7.xls')
